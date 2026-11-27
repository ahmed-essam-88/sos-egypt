import 'package:flutter/material.dart';
import '../data/content.dart';
import '../data/store.dart';
import '../services/sos_service.dart';
import '../theme.dart';

IconData iconFor(String n) {
  switch (n) {
    case 'medical': return Icons.medical_services_rounded;
    case 'fire': return Icons.local_fire_department_rounded;
    case 'road': return Icons.car_crash_rounded;
    case 'disaster': return Icons.tsunami_rounded;
    case 'shield': return Icons.shield_rounded;
    case 'search': return Icons.person_search_rounded;
    case 'leaf': return Icons.eco_rounded;
    case 'list': return Icons.checklist_rounded;
    default: return Icons.warning_amber_rounded;
  }
}

IconData svcIcon(String id) {
  switch (id) {
    case 'ambulance': return Icons.emergency_rounded;
    case 'police': return Icons.local_police_rounded;
    case 'fire': return Icons.local_fire_department_rounded;
    case 'tourist': return Icons.luggage_rounded;
    case 'traffic': return Icons.traffic_rounded;
    case 'gas': return Icons.propane_tank_rounded;
    default: return Icons.child_care_rounded;
  }
}

class Pad extends StatelessWidget {
  final Widget child;
  const Pad(this.child, {super.key});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(16), child: child);
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
      child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: navy)));
}

class InfoBox extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  const InfoBox(this.text, {super.key, this.color = warn, this.icon = Icons.info_outline_rounded});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.35))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(height: 1.4, fontWeight: FontWeight.w500))),
        ]),
      );
}

class CallChip extends StatelessWidget {
  final Svc svc;
  final bool big;
  const CallChip(this.svc, {super.key, this.big = false});
  @override
  Widget build(BuildContext context) {
    final name = app.ar ? svc.nameAr : svc.nameEn;
    return Semantics(
      button: true,
      label: '${tr('اتصل', 'Call')} $name ${svc.number}',
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
            backgroundColor: svc.critical ? sosRed : navy2,
            minimumSize: Size(big ? 120 : 64, big ? 56 : 48)),
        icon: Icon(svcIcon(svc.id)),
        label: Text('${svc.number}  $name', overflow: TextOverflow.ellipsis),
        onPressed: () => callNumber(context, svc.number),
      ),
    );
  }
}

Future<void> callNumber(BuildContext context, String n) async {
  final ok = await dial(n);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(tr('تعذر فتح تطبيق الاتصال. اطلب الرقم $n يدوياً.', 'Could not open the phone dialer. Dial $n manually.'))));
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;
  final bool numbered;
  const BulletList(this.items, {super.key, this.numbered = false});
  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: numbered ? navy : navy.withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: numbered
                      ? Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13))
                      : const Icon(Icons.circle, size: 8, color: navy)),
              const SizedBox(width: 10),
              Expanded(child: Text(items[i], style: const TextStyle(fontSize: 15.5, height: 1.45))),
            ]),
          ),
      ]);
}

class AppCardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color color;
  const AppCardTile({super.key, required this.icon, required this.title, this.subtitle, required this.onTap, this.color = navy});
  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                  child: Icon(icon, color: color)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                if (subtitle != null) Text(subtitle!, style: const TextStyle(color: Colors.black54, height: 1.3)),
              ])),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black38),
            ]),
          ),
        ),
      );
}
