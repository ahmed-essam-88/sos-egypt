import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/store.dart';

class LocResult {
  final Position? pos;
  final String? error; // human readable
  LocResult(this.pos, this.error);
}

Future<LocResult> getLocation() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocResult(null, tr('خدمة الموقع (GPS) مغلقة.', 'Location service (GPS) is turned off.'));
    }
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      return LocResult(null, tr('لم يتم السماح بالوصول للموقع.', 'Location permission was not granted.'));
    }
    final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 12)));
    return LocResult(p, null);
  } catch (_) {
    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return LocResult(last, null);
    } catch (_) {}
    return LocResult(null, tr('تعذر تحديد الموقع الآن.', 'Could not get your location right now.'));
  }
}

String mapsLink(double lat, double lon) =>
    'https://maps.google.com/?q=${lat.toStringAsFixed(6)},${lon.toStringAsFixed(6)}';

String normalizePhone(String raw) {
  var s = raw.replaceAll(RegExp(r'[^\d+]'), '');
  if (s.startsWith('00')) s = '+${s.substring(2)}';
  if (s.startsWith('01') && s.length == 11) s = '+20${s.substring(1)}';
  return s;
}

bool validPhone(String raw) {
  final d = normalizePhone(raw).replaceAll('+', '');
  return d.length >= 8 && d.length <= 15;
}

String buildMessage({required bool test, Position? pos, bool includeProfile = true}) {
  final b = StringBuffer();
  if (test) b.writeln(tr('[رسالة تجريبية - لا توجد حالة طارئة]', '[TEST MESSAGE - not a real emergency]'));
  b.writeln(app.template);
  if (pos != null) {
    b.writeln('${tr('موقعي:', 'My location:')} ${mapsLink(pos.latitude, pos.longitude)}');
  } else {
    b.writeln(tr('(الموقع غير متاح)', '(location unavailable)'));
  }
  final p = app.profile;
  if (includeProfile && p.shareInSos && !p.isEmpty) {
    if (p.name.isNotEmpty) b.writeln('${tr('الاسم', 'Name')}: ${p.name}');
    if (p.blood.isNotEmpty) b.writeln('${tr('فصيلة الدم', 'Blood type')}: ${p.blood}');
    if (p.conditions.isNotEmpty) b.writeln('${tr('حالات صحية', 'Conditions')}: ${p.conditions}');
    if (p.allergies.isNotEmpty) b.writeln('${tr('حساسية', 'Allergies')}: ${p.allergies}');
    if (p.meds.isNotEmpty) b.writeln('${tr('أدوية', 'Medicines')}: ${p.meds}');
    if (p.notes.isNotEmpty) b.writeln('${tr('ملاحظات', 'Notes')}: ${p.notes}');
  }
  b.write(tr('أُرسلت من تطبيق SOS مصر.', 'Sent from the SOS Egypt app.'));
  return b.toString();
}

/// Opens the phone's SMS app with the message prepared. This does NOT send it
/// and the app cannot know whether the user pressed send.
Future<bool> openSmsComposer(List<String> phones, String body) async {
  final nums = phones.map(normalizePhone).join(',');
  final uri = Uri(scheme: 'sms', path: nums, queryParameters: {'body': body});
  try {
    return await launchUrl(uri);
  } catch (_) {
    return false;
  }
}

Future<bool> openWhatsApp(String phone, String body) async {
  final n = normalizePhone(phone).replaceAll('+', '');
  final uri = Uri.parse('https://wa.me/$n?text=${Uri.encodeComponent(body)}');
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}

Future<bool> dial(String number) async {
  try {
    return await launchUrl(Uri(scheme: 'tel', path: number));
  } catch (_) {
    return false;
  }
}

Future<bool> openNavigation(double lat, double lon, String label) async {
  final geo = Uri.parse('geo:$lat,$lon?q=$lat,$lon(${Uri.encodeComponent(label)})');
  try {
    if (await launchUrl(geo)) return true;
  } catch (_) {}
  try {
    return await launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lon'),
        mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
