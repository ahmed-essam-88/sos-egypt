import 'package:flutter/material.dart';
import '../data/content.dart';
import '../data/store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (_, __) => Scaffold(
        appBar: AppBar(title: Text(tr('دليل خدمات الطوارئ', 'Emergency services directory'))),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          InfoBox(tr('كل الأرقام من صفحات حكومية رسمية. اضغط على أي رقم لفتح الاتصال. الأرقام الحمراء للطوارئ الأساسية.', 'All numbers come from official government pages. Tap any to open the dialer. Red ones are the core emergency lines.'),
              color: navy2, icon: Icons.verified_rounded),
          const SizedBox(height: 12),
          for (final s in services)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => callNumber(context, s.number),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(color: (s.critical ? sosRed : navy2).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                          child: Icon(svcIcon(s.id), color: s.critical ? sosRed : navy2, size: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(app.ar ? s.nameAr : s.nameEn, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                        Text(app.ar ? s.descAr : s.descEn, style: const TextStyle(color: Colors.black54, height: 1.3)),
                      ])),
                      const SizedBox(width: 8),
                      Column(children: [
                        Text(s.number, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: s.critical ? sosRed : navy)),
                        const Icon(Icons.call_rounded, color: ok),
                      ]),
                    ]),
                  ),
                ),
              ),
            ),
          SectionTitle(tr('المصادر', 'Sources')),
          for (final u in numbersSources)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: InkWell(
                    onTap: () => launchUrl(Uri.parse(u), mode: LaunchMode.externalApplication),
                    child: Text(Uri.decodeFull(u), style: const TextStyle(color: navy2, decoration: TextDecoration.underline, fontSize: 13)))),
          const SizedBox(height: 8),
          InfoBox(tr('لم نُدرج أي رقم لم نتمكن من التأكد منه من صفحة رسمية.', 'We did not list any number we could not confirm on an official page.'), color: warn),
        ]),
      ),
    );
  }
}
