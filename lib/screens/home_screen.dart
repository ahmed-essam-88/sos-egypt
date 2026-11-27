import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/content.dart';
import '../data/store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'sos_flow.dart';
import 'more_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int) goTo;
  const HomeScreen({super.key, required this.goTo});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

  @override
  void initState() {
    super.initState();
    c.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        HapticFeedback.heavyImpact();
        c.reset();
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SosFlow(test: false)));
      }
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (_, __) {
        final n = app.selectedContacts.length;
        return ListView(padding: EdgeInsets.zero, children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 14, 20, 24),
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [navy, navy2], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
            child: Column(children: [
              Row(children: [
                const Icon(Icons.shield_rounded, color: Colors.white),
                const SizedBox(width: 8),
                const Text('SOS EGYPT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20, letterSpacing: 1)),
                const Spacer(),
                TextButton(
                    onPressed: () => app.setLang(!app.ar),
                    child: Text(app.ar ? 'EN' : 'ع', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
              ]),
              const SizedBox(height: 10),
              Text(tr('اضغط مطولاً للاستغاثة', 'Press and hold for SOS'),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(tr('تحتاج ثانية ونصف حتى لا يحدث إنذار بالخطأ، ويمكنك الإلغاء.', 'Takes 1.5 seconds to prevent accidental alerts. You can cancel.'),
                  style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
              const SizedBox(height: 18),
              Semantics(
                button: true,
                label: tr('زر الاستغاثة. اضغط مطولاً', 'SOS button. Press and hold'),
                child: GestureDetector(
                  onTapDown: (_) => c.forward(),
                  onTapUp: (_) => c.reset(),
                  onTapCancel: () => c.reset(),
                  child: AnimatedBuilder(
                    animation: c,
                    builder: (_, __) => SizedBox(
                      width: 210,
                      height: 210,
                      child: Stack(alignment: Alignment.center, children: [
                        SizedBox(
                            width: 210,
                            height: 210,
                            child: CircularProgressIndicator(value: c.value, strokeWidth: 9, color: Colors.white, backgroundColor: Colors.white24)),
                        Container(
                          width: 172 - c.value * 10,
                          height: 172 - c.value * 10,
                          decoration: BoxDecoration(color: sosRed, shape: BoxShape.circle, boxShadow: [
                            BoxShadow(color: sosRed.withValues(alpha: 0.6), blurRadius: 30, spreadRadius: 4 + c.value * 8)
                          ]),
                          child: const Center(child: Text('SOS', style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w800, letterSpacing: 2))),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Pad(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (n == 0)
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactsScreen())),
                child: InfoBox(tr('لم تضف جهات اتصال طوارئ بعد. اضغط هنا لإضافتها حتى يعمل زر الاستغاثة معهم.', 'No emergency contacts yet. Tap here to add some so SOS can reach them.'),
                    color: sosRed, icon: Icons.person_add_alt_1_rounded),
              )
            else
              InfoBox(tr('سيتم تجهيز الرسالة لـ $n من جهات الاتصال.', 'The message will be prepared for $n contact(s).'), color: ok, icon: Icons.check_circle_rounded),
            const SizedBox(height: 14),
            Text(tr('اتصال مباشر', 'Call directly'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: navy)),
            const SizedBox(height: 8),
            for (final id in ['ambulance', 'police', 'fire'])
              Padding(padding: const EdgeInsets.only(bottom: 8), child: SizedBox(width: double.infinity, child: CallChip(svcById(id), big: true))),
            const SizedBox(height: 8),
            AppCardTile(
                icon: Icons.support_agent_rounded,
                title: tr('اسأل مساعد السلامة', 'Ask the Safety Assistant'),
                subtitle: tr('اكتب ما يحدث لتعرف ماذا تفعل أولاً', 'Describe what is happening to see what to do first'),
                onTap: () => widget.goTo(1),
                color: navy2),
            const SizedBox(height: 10),
            AppCardTile(
                icon: Icons.fact_check_rounded,
                title: tr('اختبر إعداد الطوارئ', 'Test your emergency setup'),
                subtitle: tr('بدون إرسال أي استغاثة حقيقية', 'Without sending a real alert'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SosFlow(test: true))),
                color: ok),
            const SizedBox(height: 14),
            InfoBox(tr('هذا التطبيق لا يتصل بالإسعاف أو الشرطة نيابة عنك. في الخطر الحقيقي اتصل بالأرقام أعلاه.', 'This app does not contact ambulance or police for you. In real danger, call the numbers above.')),
          ])),
        ]);
      },
    );
  }
}
