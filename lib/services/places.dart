import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Place {
  final String name, type; // hospital | police | fire
  final double lat, lon;
  final double distance;
  final String? phone;
  Place(this.name, this.type, this.lat, this.lon, this.distance, this.phone);
}

/// Nearby emergency facilities from OpenStreetMap (Overpass API, free).
/// This is community-maintained data, NOT officially verified. The UI says so.
Future<List<Place>> fetchNearby(double lat, double lon, {int radius = 6000}) async {
  final q = '[out:json][timeout:20];('
      'nwr["amenity"="hospital"](around:$radius,$lat,$lon);'
      'nwr["amenity"="police"](around:$radius,$lat,$lon);'
      'nwr["amenity"="fire_station"](around:$radius,$lat,$lon););out center 80;';
  const endpoints = [
    'https://overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
  ];
  Object? lastErr;
  for (final ep in endpoints) {
    try {
      final r = await http
          .post(Uri.parse(ep), body: {'data': q}, headers: {'User-Agent': 'SOS-Egypt-App/1.0'})
          .timeout(const Duration(seconds: 25));
      if (r.statusCode != 200) {
        lastErr = 'HTTP ${r.statusCode}';
        continue;
      }
      final j = jsonDecode(utf8.decode(r.bodyBytes));
      final out = <Place>[];
      for (final e in (j['elements'] as List)) {
        final tags = (e['tags'] ?? {}) as Map;
        final amenity = tags['amenity'];
        final type = amenity == 'hospital' ? 'hospital' : amenity == 'police' ? 'police' : 'fire';
        final la = (e['lat'] ?? e['center']?['lat']) as num?;
        final lo = (e['lon'] ?? e['center']?['lon']) as num?;
        if (la == null || lo == null) continue;
        final name = (tags['name:ar'] ?? tags['name'] ?? tags['name:en'] ?? '').toString();
        if (name.isEmpty) continue;
        final phone = (tags['phone'] ?? tags['contact:phone'])?.toString();
        out.add(Place(name, type, la.toDouble(), lo.toDouble(),
            Geolocator.distanceBetween(lat, lon, la.toDouble(), lo.toDouble()), phone));
      }
      out.sort((a, b) => a.distance.compareTo(b.distance));
      return out;
    } catch (e) {
      lastErr = e;
    }
  }
  throw Exception('places: $lastErr');
}
