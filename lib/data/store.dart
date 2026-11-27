import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String tr(String ar, String en) => app.ar ? ar : en;

class Contact {
  String id, name, phone;
  bool primary, selected;
  Contact(this.id, this.name, this.phone,
      {this.primary = false, this.selected = true});
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'primary': primary,
        'selected': selected
      };
  factory Contact.fromJson(Map<String, dynamic> j) => Contact(
      j['id'], j['name'], j['phone'],
      primary: j['primary'] ?? false, selected: j['selected'] ?? true);
}

class Profile {
  String name = '', blood = '', conditions = '', allergies = '', meds = '', notes = '';
  bool shareInSos = false; // explicit consent
  Map<String, dynamic> toJson() => {
        'name': name,
        'blood': blood,
        'conditions': conditions,
        'allergies': allergies,
        'meds': meds,
        'notes': notes,
        'share': shareInSos
      };
  void load(Map<String, dynamic> j) {
    name = j['name'] ?? '';
    blood = j['blood'] ?? '';
    conditions = j['conditions'] ?? '';
    allergies = j['allergies'] ?? '';
    meds = j['meds'] ?? '';
    notes = j['notes'] ?? '';
    shareInSos = j['share'] ?? false;
  }

  bool get isEmpty =>
      name.isEmpty && blood.isEmpty && conditions.isEmpty && allergies.isEmpty && meds.isEmpty && notes.isEmpty;
}

enum AlertStatus { cancelled, prepared, opened, failed, test }

class AlertRecord {
  final DateTime time;
  final AlertStatus status;
  final String detail;
  final double? lat, lon;
  final int recipients;
  AlertRecord(this.time, this.status, this.detail, this.recipients, {this.lat, this.lon});
  Map<String, dynamic> toJson() => {
        't': time.toIso8601String(),
        's': status.index,
        'd': detail,
        'lat': lat,
        'lon': lon,
        'n': recipients
      };
  factory AlertRecord.fromJson(Map<String, dynamic> j) => AlertRecord(
      DateTime.parse(j['t']), AlertStatus.values[j['s']], j['d'] ?? '', j['n'] ?? 0,
      lat: (j['lat'] as num?)?.toDouble(), lon: (j['lon'] as num?)?.toDouble());
}

const defaultTemplateAr =
    'أنا في حالة طارئة وأحتاج مساعدة. من فضلك اتصل بي أو أبلغ الجهات المختصة.';
const defaultTemplateEn =
    'I am in an emergency and need help. Please call me or alert the authorities.';

class AppState extends ChangeNotifier {
  bool ar = true;
  bool loaded = false;
  final List<Contact> contacts = [];
  final Profile profile = Profile();
  final List<AlertRecord> history = [];
  final Set<String> checked = {};
  String templateAr = defaultTemplateAr, templateEn = defaultTemplateEn;
  bool onboarded = false;

  static const _secure = FlutterSecureStorage();
  SharedPreferences? _prefs;

  String get template => ar ? templateAr : templateEn;

  Future<String?> _read(String k) async {
    try {
      return await _secure.read(key: k);
    } catch (_) {
      return _prefs?.getString('fallback_$k');
    }
  }

  Future<void> _write(String k, String v) async {
    try {
      await _secure.write(key: k, value: v);
    } catch (_) {
      await _prefs?.setString('fallback_$k', v);
    }
  }

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    ar = _prefs!.getBool('ar') ?? true;
    onboarded = _prefs!.getBool('onboarded') ?? false;
    checked.addAll(_prefs!.getStringList('checked') ?? []);
    templateAr = _prefs!.getString('tplAr') ?? defaultTemplateAr;
    templateEn = _prefs!.getString('tplEn') ?? defaultTemplateEn;
    try {
      final c = await _read('contacts');
      if (c != null) {
        contacts
          ..clear()
          ..addAll((jsonDecode(c) as List).map((e) => Contact.fromJson(e)));
      }
      final p = await _read('profile');
      if (p != null) profile.load(jsonDecode(p));
      final h = await _read('history');
      if (h != null) {
        history
          ..clear()
          ..addAll((jsonDecode(h) as List).map((e) => AlertRecord.fromJson(e)));
      }
    } catch (_) {}
    loaded = true;
    notifyListeners();
  }

  Future<void> setLang(bool arabic) async {
    ar = arabic;
    await _prefs?.setBool('ar', arabic);
    notifyListeners();
  }

  Future<void> finishOnboarding() async {
    onboarded = true;
    await _prefs?.setBool('onboarded', true);
    notifyListeners();
  }

  Future<void> saveContacts() async {
    await _write('contacts', jsonEncode(contacts.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  Future<void> saveProfile() async {
    await _write('profile', jsonEncode(profile.toJson()));
    notifyListeners();
  }

  Future<void> saveTemplates(String a, String e) async {
    templateAr = a;
    templateEn = e;
    await _prefs?.setString('tplAr', a);
    await _prefs?.setString('tplEn', e);
    notifyListeners();
  }

  Future<void> addHistory(AlertRecord r) async {
    history.insert(0, r);
    if (history.length > 100) history.removeLast();
    await _write('history', jsonEncode(history.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  Future<void> replaceFirstHistory(AlertRecord r) async {
    if (history.isEmpty) return addHistory(r);
    history[0] = r;
    await _write('history', jsonEncode(history.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  Future<void> clearHistory() async {
    history.clear();
    await _write('history', '[]');
    notifyListeners();
  }

  Future<void> toggleCheck(String id) async {
    checked.contains(id) ? checked.remove(id) : checked.add(id);
    await _prefs?.setStringList('checked', checked.toList());
    notifyListeners();
  }

  Future<void> wipeAll() async {
    contacts.clear();
    history.clear();
    checked.clear();
    profile.load({});
    try {
      await _secure.deleteAll();
    } catch (_) {}
    await _prefs?.clear();
    ar = true;
    onboarded = false;
    templateAr = defaultTemplateAr;
    templateEn = defaultTemplateEn;
    notifyListeners();
  }

  List<Contact> get selectedContacts => contacts.where((c) => c.selected).toList();
}

final app = AppState();
