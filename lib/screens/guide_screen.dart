import 'package:flutter/material.dart';
import '../data/content.dart';
import '../data/store.dart';
import '../services/assistant.dart';
import '../theme.dart';
import '../widgets/common.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});
  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final ctl = TextEditingController();
  AssistantAnswer? ans;

  void ask([String? q]) {
    if (q != null) ctl.text = q;
    FocusScope.of(context).unfocus();
    setState(() => ans = analyze(ctl.text));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (_, __) => Scaffold(
        appBar: AppBar(title: Text(tr('مساعد السلامة', 'Safety Assistant'))),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          InfoBox(tr('مساعد يعمل على هاتفك بدون إنترنت، يعتمد على إرشادات مكتوبة ومراجعة وليس ذكاءً اصطناعياً توليدياً. لا يخترع تعليمات.', 'Works offline on your phone from written, curated guidance. It is not a generative AI and does not invent instructions.'),
              color: navy2, icon: Icons.verified_user_rounded),
          const SizedBox(height: 12),
          TextField(
            controller: ctl,
            minLines: 2,
            maxLines: 4,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                hintText: tr('اكتب ما يحدث... مثال: في حريق في المطبخ', 'Describe what is happening... e.g. there is a fire in the kitchen'),
                suffixIcon: IconButton(icon: const Icon(Icons.send_rounded, color: navy), tooltip: tr('اسأل', 'Ask'), onPressed: ask)),
            onSubmitted: (_) => ask(),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final s in (app.ar ? suggestionsAr : suggestionsEn)) ActionChip(label: Text(s), onPressed: () => ask(s)),
          ]),
          if (ans != null) _answer(ans!),
          SectionTitle(tr('أقسام الطوارئ', 'Emergency categories')),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.25,
            children: [
              for (final c in categories)
                Card(
                    child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(c))),
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(iconFor(c.icon), size: 34, color: c.id == 'fire' ? sosRed : navy),
                        const SizedBox(height: 8),
                        Text(app.ar ? c.titleAr : c.titleEn, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800)),
                      ])),
                )),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _answer(AssistantAnswer a) {
    final c = a.category;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (a.immediateDanger)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: sosRed, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.warning_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(tr('يبدو أن هناك خطراً الآن. اتصل بالطوارئ أولاً.', 'This sounds like danger right now. Call emergency services first.'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
              ]),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8, children: [for (final id in c.call) CallChip(svcById(id))]),
            ]),
          )
        else
          InfoBox(tr('يبدو سؤالاً عاماً عن السلامة. إذا تغير الوضع إلى خطر مباشر اتصل بالطوارئ.', 'This looks like a general safety question. If it turns into immediate danger, call emergency services.'), color: ok, icon: Icons.info_rounded),
        const SizedBox(height: 10),
        Card(
            child: Pad(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(iconFor(c.icon), color: navy),
            const SizedBox(width: 8),
            Expanded(child: Text(a.matched ? (app.ar ? c.titleAr : c.titleEn) : tr('لم أفهم نوع الحالة', 'Could not tell the type of situation'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
          ]),
          const SizedBox(height: 8),
          Text(tr('ماذا تفعل أولاً', 'What to do first'), style: const TextStyle(fontWeight: FontWeight.w800, color: sosRed)),
          const SizedBox(height: 4),
          BulletList((app.ar ? c.stepsAr : c.stepsEn).take(3).toList(), numbered: true),
          const SizedBox(height: 8),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryScreen(c))), child: Text(tr('عرض القسم كاملاً', 'Open the full section'))),
          if (!a.matched) Text(tr('اختر القسم المناسب من الأسفل أو اتصل بالطوارئ إن كنت غير متأكد.', 'Pick the right section below, or call emergency services if you are unsure.')),
        ]))),
      ]),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final Category c;
  const CategoryScreen(this.c, {super.key});
  @override
  Widget build(BuildContext context) {
    final ar = app.ar;
    return Scaffold(
      appBar: AppBar(title: Text(ar ? c.titleAr : c.titleEn)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(ar ? c.whatAr : c.whatEn, style: const TextStyle(fontSize: 16, height: 1.45)),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [for (final id in c.call) CallChip(svcById(id))]),
        SectionTitle(tr('الإجراءات الفورية', 'Immediate actions')),
        Card(child: Pad(BulletList(ar ? c.stepsAr : c.stepsEn, numbered: true))),
        SectionTitle(tr('احتياطات مهمة', 'Important precautions')),
        Card(child: Pad(BulletList(ar ? c.careAr : c.careEn))),
        SectionTitle(tr('متى تحتاج مساعدة متخصصة', 'When professional help is needed')),
        Card(child: Pad(BulletList(ar ? c.whenAr : c.whenEn))),
        const SizedBox(height: 14),
        InfoBox(tr('إرشادات عامة للتوعية وليست بديلاً عن الإسعاف أو الشرطة أو المطافئ.', 'General awareness guidance. It does not replace the ambulance, police or fire service.')),
      ]),
    );
  }
}
