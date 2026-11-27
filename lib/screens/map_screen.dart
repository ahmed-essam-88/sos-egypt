import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../data/store.dart';
import '../services/places.dart';
import '../services/sos_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final map = MapController();
  Position? pos;
  LatLng? center;
  String? err;
  bool loading = false;
  List<Place> places = [];
  String filter = 'all';
  String q = '';
  bool started = false;

  Future<void> locate() async {
    setState(() {
      loading = true;
      err = null;
    });
    final r = await getLocation();
    if (r.pos == null) {
      setState(() {
        loading = false;
        err = r.error;
      });
      return;
    }
    pos = r.pos;
    await _load(LatLng(r.pos!.latitude, r.pos!.longitude));
  }

  Future<void> _load(LatLng c) async {
    setState(() {
      center = c;
      loading = true;
      err = null;
    });
    try {
      final p = await fetchNearby(c.latitude, c.longitude);
      places = p;
      map.move(c, 13);
    } catch (_) {
      err = tr('تعذر تحميل الأماكن القريبة. تأكد من الإنترنت وحاول مرة أخرى.', 'Could not load nearby places. Check your internet and try again.');
    }
    if (mounted) setState(() => loading = false);
  }

  Color _col(String t) => t == 'hospital' ? sosRed : t == 'police' ? navy : warn;
  IconData _ico(String t) => t == 'hospital' ? Icons.local_hospital_rounded : t == 'police' ? Icons.local_police_rounded : Icons.local_fire_department_rounded;
  String _lbl(String t) => t == 'hospital' ? tr('مستشفى', 'Hospital') : t == 'police' ? tr('شرطة', 'Police') : tr('حماية مدنية', 'Civil protection');

  @override
  Widget build(BuildContext context) {
    final shown = places.where((p) => (filter == 'all' || p.type == filter) && (q.isEmpty || p.name.toLowerCase().contains(q.toLowerCase()))).toList();
    return ListenableBuilder(
      listenable: app,
      builder: (_, __) => Scaffold(
        appBar: AppBar(title: Text(tr('خريطة الطوارئ', 'Emergency map'))),
        body: Column(children: [
          SizedBox(
            height: 260,
            child: FlutterMap(
              mapController: map,
              options: MapOptions(initialCenter: center ?? const LatLng(30.0444, 31.2357), initialZoom: center == null ? 10 : 13),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'eg.sosegypt.sos_egypt'),
                MarkerLayer(markers: [
                  if (pos != null) Marker(point: LatLng(pos!.latitude, pos!.longitude), width: 28, height: 28, child: Container(decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)))),
                  for (final p in shown.take(60))
                    Marker(point: LatLng(p.lat, p.lon), width: 34, height: 34, child: Icon(_ico(p.type), color: _col(p.type), size: 30)),
                ]),
                const SimpleAttributionWidget(source: Text('© OpenStreetMap contributors')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Column(children: [
              Row(children: [
                Expanded(
                    child: TextField(
                        decoration: InputDecoration(hintText: tr('ابحث بالاسم', 'Search by name'), prefixIcon: const Icon(Icons.search_rounded), isDense: true),
                        onChanged: (v) => setState(() => q = v))),
                const SizedBox(width: 8),
                FilledButton.icon(onPressed: loading ? null : locate, icon: const Icon(Icons.my_location_rounded), label: Text(tr('موقعي', 'Locate'))),
              ]),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (final f in ['all', 'hospital', 'police', 'fire'])
                    Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: ChoiceChip(label: Text(f == 'all' ? tr('الكل', 'All') : _lbl(f)), selected: filter == f, onSelected: (_) => setState(() => filter = f))),
                ]),
              ),
            ]),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: InfoBox(tr('البيانات من OpenStreetMap (مجتمعية) وغير موثقة رسمياً. اتصل قبل التوجه عند الإمكان. الأرقام الرسمية في تبويب الأرقام.', 'Data is from OpenStreetMap (community-made) and is not officially verified. Call before travelling when possible. Official numbers are in the Numbers tab.'), color: warn)),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : err != null
                    ? Center(child: Pad(Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(err!, textAlign: TextAlign.center),
                        const SizedBox(height: 10),
                        FilledButton(onPressed: locate, child: Text(tr('إعادة المحاولة', 'Try again'))),
                        const SizedBox(height: 8),
                        Text(tr('أو تصفح مركز المدينة (ليس موقعك):', 'Or browse a city centre (not your location):'), style: const TextStyle(color: Colors.black54)),
                        Wrap(spacing: 8, children: [
                          ActionChip(label: Text(tr('القاهرة', 'Cairo')), onPressed: () => _load(const LatLng(30.0444, 31.2357))),
                          ActionChip(label: Text(tr('الإسكندرية', 'Alexandria')), onPressed: () => _load(const LatLng(31.2001, 29.9187))),
                        ]),
                      ])))
                    : places.isEmpty
                        ? Center(child: Pad(Column(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.location_searching_rounded, size: 44, color: navy2),
                            const SizedBox(height: 8),
                            Text(tr('اضغط "موقعي" لعرض أقرب مستشفيات وأقسام شرطة وحماية مدنية. سنطلب إذن الموقع لهذا الغرض فقط.', 'Tap "Locate" to see the nearest hospitals, police and civil protection. We ask for location permission for this only.'), textAlign: TextAlign.center),
                          ])))
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                            itemCount: shown.length,
                            itemBuilder: (_, i) {
                              final p = shown[i];
                              return Card(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: ListTile(
                                    leading: Icon(_ico(p.type), color: _col(p.type), size: 30),
                                    title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                    subtitle: Text('${_lbl(p.type)} • ${(p.distance / 1000).toStringAsFixed(1)} ${tr('كم', 'km')}${p.phone != null ? ' • ${p.phone}' : ''}\n${tr('بيانات غير موثقة رسمياً', 'Unverified data')}'),
                                    isThreeLine: true,
                                    trailing: IconButton(
                                        tooltip: tr('ابدأ الملاحة', 'Navigate'),
                                        icon: const Icon(Icons.directions_rounded, color: navy),
                                        onPressed: () async {
                                          final ok2 = await openNavigation(p.lat, p.lon, p.name);
                                          if (!ok2 && context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('لا يوجد تطبيق خرائط متاح.', 'No map app available.'))));
                                          }
                                        }),
                                  ));
                            }),
          ),
        ]),
      ),
    );
  }
}
