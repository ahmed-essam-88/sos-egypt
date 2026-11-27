import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/content.dart';
import '../data/store.dart';
import '../services/sos_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});
  void _go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (_, __) => Scaffold(
        appBar: AppBar(title: Text(tr('المزيد', 'More'))),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          AppCardTile(icon: Icons.contacts_rounded, title: tr('جهات اتصال الطوارئ', 'Emergency contacts'), subtitle: tr('${app.contacts.length} جهة', '${app.contacts.length} saved'), onTap: () => _go(context, const ContactsScreen())),
          const SizedBox(height: 10),
          AppCardTile(icon: Icons.sms_rounded, title: tr('قوالب الرسالة', 'Message templates'), subtitle: tr('خصص رسالة الاستغاثة', 'Customise your distress message'), onTap: () => _go(context, const TemplateScreen())),
          const SizedBox(height: 10),
          AppCardTile(icon: Icons.badge_rounded, title: tr('ملف الطوارئ', 'Emergency profile'), subtitle: tr('اختياري، بموافقتك فقط', 'Optional, only with your consent'), onTap: () => _go(context, const ProfileScreen())),
          const SizedBox(height: 10),
          AppCardTile(icon: Icons.history_rounded, title: tr('سجل الاستغاثات', 'Alert history'), subtitle: tr('${app.history.length} سجل', '${app.history.length} records'), onTap: () => _go(context, const HistoryScreen())),
          const SizedBox(height: 10),
          AppCardTile(icon: Icons.record_voice_over_rounded, title: tr('ماذا أقول للمشغل', 'What to say to the operator'), subtitle: tr('تقرير جاهز للقراءة بالهاتف', 'A ready-to-read report for the call'), onTap: () => _go(context, const ReportScreen())),
          const SizedBox(height: 10),
          AppCardTile(icon: Icons.school_rounded, title: tr('مركز التوعية', 'Safety education'), subtitle: tr('نصائح وإرشادات موثوقة', 'Credible tips and guidance'), onTap: () => _go(context, const EducationScreen())),
          const SizedBox(height: 10),
          AppCardTile(icon: Icons.checklist_rounded, title: tr('قائمة الاستعداد', 'Preparedness checklist'), subtitle: tr('${app.checked.length} من ${checklist.length}', '${app.checked.length} of ${checklist.length} done'), onTap: () => _go(context, const ChecklistScreen())),
          const SizedBox(height: 10),
          AppCardTile(icon: Icons.settings_rounded, title: tr('الإعدادات والخصوصية', 'Settings and privacy'), onTap: () => _go(context, const SettingsScreen())),
        ]),
      ),
    );
  }
}

// ---------------- Contacts ----------------
class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Future<void> _edit([Contact? c]) async {
    final name = TextEditingController(text: c?.name ?? '');
    final phone = TextEditingController(text: c?.phone ?? '');
    String? err;
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => StatefulBuilder(
            builder: (ctx, set) => Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text(c == null ? tr('إضافة جهة اتصال', 'Add contact') : tr('تعديل جهة الاتصال', 'Edit contact'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    const SizedBox(height: 12),
                    TextField(controller: name, decoration: InputDecoration(labelText: tr('الاسم', 'Name'))),
                    const SizedBox(height: 10),
                    TextField(controller: phone, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: tr('رقم الهاتف', 'Phone number'), errorText: err)),
                    const SizedBox(height: 14),
                    FilledButton(
                        onPressed: () async {
                          if (name.text.trim().isEmpty) {
                            set(() => err = tr('أدخل الاسم', 'Enter a name'));
                            return;
                          }
                          if (!validPhone(phone.text)) {
                            set(() => err = tr('رقم غير صحيح', 'Invalid number'));
                            return;
                          }
                          if (c == null) {
                            app.contacts.add(Contact(DateTime.now().microsecondsSinceEpoch.toString(), name.text.trim(), phone.text.trim(), primary: app.contacts.isEmpty));
                          } else {
                            c.name = name.text.trim();
                            c.phone = phone.text.trim();
                          }
                          await app.saveContacts();
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                        child: Text(tr('حفظ', 'Save'))),
                  ]),
                )));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('جهات اتصال الطوارئ', 'Emergency contacts'))),
      floatingActionButton: FloatingActionButton.extended(backgroundColor: sosRed, foregroundColor: Colors.white, onPressed: () => _edit(), icon: const Icon(Icons.person_add_rounded), label: Text(tr('إضافة', 'Add'))),
      body: app.contacts.isEmpty
          ? Center(child: Pad(Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.group_add_rounded, size: 56, color: navy2),
              const SizedBox(height: 10),
              Text(tr('لا توجد جهات اتصال. أضف أشخاصاً تثق بهم ليصلهم موقعك عند الاستغاثة.', 'No contacts yet. Add people you trust so your location can be sent to them in an emergency.'), textAlign: TextAlign.center),
            ])))
          : ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 90), children: [
              InfoBox(tr('المفعّلة (المؤشرة) ستصلها رسالة الاستغاثة. النجمة تحدد الجهة الأساسية.', 'Ticked contacts receive the SOS message. The star marks the primary contact.'), color: navy2),
              const SizedBox(height: 10),
              for (final c in app.contacts)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    child: ListTile(
                      leading: Checkbox(
                          value: c.selected,
                          onChanged: (v) async {
                            c.selected = v ?? true;
                            await app.saveContacts();
                            setState(() {});
                          }),
                      title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: Text(c.phone),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            tooltip: tr('جهة أساسية', 'Primary'),
                            icon: Icon(c.primary ? Icons.star_rounded : Icons.star_border_rounded, color: c.primary ? warn : Colors.black38),
                            onPressed: () async {
                              for (final x in app.contacts) {
                                x.primary = x == c;
                              }
                              await app.saveContacts();
                              setState(() {});
                            }),
                        IconButton(icon: const Icon(Icons.edit_rounded), onPressed: () => _edit(c)),
                        IconButton(
                            icon: const Icon(Icons.delete_rounded, color: sosRed),
                            onPressed: () async {
                              final yes = await showDialog<bool>(
                                  context: context,
                                  builder: (d) => AlertDialog(
                                          title: Text(tr('حذف ${c.name}؟', 'Delete ${c.name}?')),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(d, false), child: Text(tr('إلغاء', 'Cancel'))),
                                            TextButton(onPressed: () => Navigator.pop(d, true), child: Text(tr('حذف', 'Delete'), style: const TextStyle(color: sosRed))),
                                          ]));
                              if (yes == true) {
                                app.contacts.remove(c);
                                if (app.contacts.isNotEmpty && !app.contacts.any((x) => x.primary)) app.contacts.first.primary = true;
                                await app.saveContacts();
                                setState(() {});
                              }
                            }),
                      ]),
                    ),
                  ),
                ),
            ]),
    );
  }
}

// ---------------- Templates ----------------
class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});
  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  late final a = TextEditingController(text: app.templateAr);
  late final e = TextEditingController(text: app.templateEn);
  static const presetsAr = ['أنا في خطر وأحتاج مساعدة فورية. هذا موقعي.', 'حدث لي حادث على الطريق. من فضلك تواصل معي.', 'أشعر بتعب شديد وأحتاج مساعدة طبية.'];
  static const presetsEn = ['I am in danger and need immediate help. This is my location.', 'I had a road accident. Please contact me.', 'I feel seriously unwell and need medical help.'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('قوالب الرسالة', 'Message templates'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(tr('رسالة بالعربية', 'Arabic message'), style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        TextField(controller: a, maxLines: 3),
        const SizedBox(height: 12),
        Text(tr('رسالة بالإنجليزية', 'English message'), style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        TextField(controller: e, maxLines: 3, textDirection: TextDirection.ltr),
        const SizedBox(height: 12),
        Text(tr('قوالب جاهزة', 'Presets'), style: const TextStyle(fontWeight: FontWeight.w800)),
        for (var i = 0; i < presetsAr.length; i++)
          ListTile(
              dense: true,
              title: Text(app.ar ? presetsAr[i] : presetsEn[i]),
              trailing: const Icon(Icons.add_circle_outline_rounded),
              onTap: () => setState(() {
                    a.text = presetsAr[i];
                    e.text = presetsEn[i];
                  })),
        const SizedBox(height: 8),
        InfoBox(tr('يُضاف الموقع تلقائياً. بيانات الملف الشخصي تُضاف فقط إذا وافقت عليها.', 'Your location is added automatically. Profile details are added only if you consent.'), color: navy2),
        const SizedBox(height: 12),
        FilledButton(
            onPressed: () async {
              await app.saveTemplates(a.text.trim().isEmpty ? defaultTemplateAr : a.text.trim(), e.text.trim().isEmpty ? defaultTemplateEn : e.text.trim());
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(tr('حفظ', 'Save'))),
      ]),
    );
  }
}

// ---------------- Profile ----------------
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final p = app.profile;
  late final name = TextEditingController(text: p.name);
  late final blood = TextEditingController(text: p.blood);
  late final cond = TextEditingController(text: p.conditions);
  late final all = TextEditingController(text: p.allergies);
  late final meds = TextEditingController(text: p.meds);
  late final notes = TextEditingController(text: p.notes);
  late bool share = p.shareInSos;
  Widget f(TextEditingController c, String l, {int lines = 1}) => Padding(padding: const EdgeInsets.only(bottom: 10), child: TextField(controller: c, maxLines: lines, decoration: InputDecoration(labelText: l)));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('ملف الطوارئ', 'Emergency profile'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        InfoBox(tr('كل الحقول اختيارية. تُحفظ مشفرة على هذا الهاتف فقط ولا تُرفع لأي خادم.', 'All fields are optional. Stored encrypted on this phone only and never uploaded to a server.'), color: navy2, icon: Icons.lock_rounded),
        const SizedBox(height: 12),
        f(name, tr('الاسم الكامل', 'Full name')),
        f(blood, tr('فصيلة الدم', 'Blood type')),
        f(cond, tr('حالات صحية', 'Medical conditions'), lines: 2),
        f(all, tr('حساسية', 'Allergies')),
        f(meds, tr('أدوية', 'Medicines'), lines: 2),
        f(notes, tr('ملاحظات طوارئ', 'Emergency notes'), lines: 2),
        Card(
            child: SwitchListTile(
          title: Text(tr('أوافق على إرفاق هذه البيانات برسالة الاستغاثة', 'I consent to attach this info to SOS messages'), style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(tr('بدون هذه الموافقة لن تُرسل أي بيانات طبية.', 'Without this consent no medical data is sent.')),
          value: share,
          onChanged: (v) => setState(() => share = v),
        )),
        const SizedBox(height: 12),
        FilledButton(
            onPressed: () async {
              p
                ..name = name.text.trim()
                ..blood = blood.text.trim()
                ..conditions = cond.text.trim()
                ..allergies = all.text.trim()
                ..meds = meds.text.trim()
                ..notes = notes.text.trim()
                ..shareInSos = share;
              await app.saveProfile();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(tr('حفظ', 'Save'))),
      ]),
    );
  }
}

// ---------------- History ----------------
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  String _s(AlertStatus s) => switch (s) {
        AlertStatus.cancelled => tr('أُلغيت', 'Cancelled'),
        AlertStatus.prepared => tr('جُهزت (لم يتأكد الإرسال)', 'Prepared (sending not confirmed)'),
        AlertStatus.opened => tr('أكّدت الإرسال (التسليم غير مؤكد)', 'You confirmed sending (delivery not verified)'),
        AlertStatus.failed => tr('فشلت', 'Failed'),
        AlertStatus.test => tr('اختبار', 'Test'),
      };
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (_, __) => Scaffold(
        appBar: AppBar(title: Text(tr('سجل الاستغاثات', 'Alert history')), actions: [
          if (app.history.isNotEmpty) IconButton(icon: const Icon(Icons.delete_sweep_rounded), tooltip: tr('مسح', 'Clear'), onPressed: () => app.clearHistory()),
        ]),
        body: app.history.isEmpty
            ? Center(child: Text(tr('لا توجد سجلات بعد.', 'No records yet.')))
            : ListView(padding: const EdgeInsets.all(16), children: [
                for (final r in app.history)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: ListTile(
                        leading: Icon(r.status == AlertStatus.cancelled ? Icons.cancel_rounded : r.status == AlertStatus.failed ? Icons.error_rounded : r.status == AlertStatus.test ? Icons.science_rounded : Icons.sos_rounded,
                            color: r.status == AlertStatus.failed ? sosRed : r.status == AlertStatus.test ? ok : navy),
                        title: Text(_s(r.status), style: const TextStyle(fontWeight: FontWeight.w800)),
                        subtitle: Text('${r.time.toString().substring(0, 16)}\n${r.detail}${r.lat != null ? '\n${mapsLink(r.lat!, r.lon!)}' : ''}'),
                        isThreeLine: true,
                      ),
                    ),
                  ),
              ]),
      ),
    );
  }
}

// ---------------- Report preparation ----------------
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String svc = 'ambulance';
  final what = TextEditingController();
  final people = TextEditingController(text: '1');
  String loc = '';
  bool busy = false;
  Future<void> _loc() async {
    setState(() => busy = true);
    final r = await getLocation();
    loc = r.pos != null ? mapsLink(r.pos!.latitude, r.pos!.longitude) : (r.error ?? '');
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = svcById(svc);
    final script = app.ar
        ? '1) أنا ${app.profile.name.isEmpty ? '[الاسم]' : app.profile.name}.\n2) المكان: ${loc.isEmpty ? '[اسم الشارع أو أقرب علامة]' : loc}\n3) ما حدث: ${what.text.isEmpty ? '[وصف مختصر]' : what.text}\n4) عدد المصابين أو المعرضين للخطر: ${people.text}\n5) رقم هاتفي للتواصل.\n6) لا تغلق الخط حتى يخبرك المشغل.'
        : '1) My name is ${app.profile.name.isEmpty ? '[name]' : app.profile.name}.\n2) Location: ${loc.isEmpty ? '[street name or nearest landmark]' : loc}\n3) What happened: ${what.text.isEmpty ? '[short description]' : what.text}\n4) People hurt or at risk: ${people.text}\n5) My phone number for call-back.\n6) Do not hang up until the operator says so.';
    return Scaffold(
      appBar: AppBar(title: Text(tr('ماذا أقول للمشغل', 'What to say to the operator'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        InfoBox(tr('يساعدك على ترتيب كلامك قبل الاتصال أو أثناءه. لا يرسل شيئاً.', 'Helps you organise what to say before or during the call. It sends nothing.'), color: navy2),
        const SizedBox(height: 12),
        Wrap(spacing: 8, children: [for (final x in services.where((x) => x.critical)) ChoiceChip(label: Text('${x.number}'), selected: svc == x.id, onSelected: (_) => setState(() => svc = x.id))]),
        const SizedBox(height: 10),
        TextField(controller: what, decoration: InputDecoration(labelText: tr('ماذا حدث؟', 'What happened?')), onChanged: (_) => setState(() {})),
        const SizedBox(height: 10),
        TextField(controller: people, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: tr('عدد المصابين', 'Number of people hurt')), onChanged: (_) => setState(() {})),
        const SizedBox(height: 10),
        OutlinedButton.icon(onPressed: busy ? null : _loc, icon: const Icon(Icons.my_location_rounded), label: Text(busy ? '...' : tr('إضافة موقعي', 'Add my location'))),
        const SizedBox(height: 12),
        Card(child: Pad(SelectableText(script, style: const TextStyle(height: 1.6, fontSize: 16)))),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: CallChip(s, big: true)),
      ]),
    );
  }
}

// ---------------- Education ----------------
class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('مركز التوعية', 'Safety education'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        for (final l in lessons)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                shape: const Border(),
                leading: Icon(iconFor(l.icon), color: navy),
                title: Text(app.ar ? l.titleAr : l.titleEn, style: const TextStyle(fontWeight: FontWeight.w800)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                children: [Align(alignment: AlignmentDirectional.centerStart, child: BulletList(app.ar ? l.pointsAr : l.pointsEn))],
              ),
            ),
          ),
        SectionTitle(tr('المصادر', 'Sources')),
        for (final s in (app.ar ? sourcesAr : sourcesEn)) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text(s)),
        for (final u in sourceLinks)
          InkWell(onTap: () => launchUrl(Uri.parse(u), mode: LaunchMode.externalApplication), child: Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Text(u, style: const TextStyle(color: navy2, decoration: TextDecoration.underline, fontSize: 13)))),
      ]),
    );
  }
}

// ---------------- Checklist ----------------
class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (_, __) => Scaffold(
        appBar: AppBar(title: Text(tr('قائمة الاستعداد', 'Preparedness checklist'))),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          LinearProgressIndicator(value: app.checked.length / checklist.length, minHeight: 10, borderRadius: BorderRadius.circular(8), color: ok),
          const SizedBox(height: 12),
          for (final c in checklist)
            Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: CheckboxListTile(value: app.checked.contains(c.id), title: Text(app.ar ? c.ar : c.en, style: const TextStyle(fontWeight: FontWeight.w600)), onChanged: (_) => app.toggleCheck(c.id))),
        ]),
      ),
    );
  }
}

// ---------------- Settings ----------------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: app,
      builder: (_, __) => Scaffold(
        appBar: AppBar(title: Text(tr('الإعدادات والخصوصية', 'Settings and privacy'))),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Card(
              child: Column(children: [
            ListTile(title: Text(tr('اللغة', 'Language'), style: const TextStyle(fontWeight: FontWeight.w800)), trailing: SegmentedButton<bool>(segments: const [ButtonSegment(value: true, label: Text('العربية')), ButtonSegment(value: false, label: Text('English'))], selected: {app.ar}, onSelectionChanged: (s) => app.setLang(s.first))),
          ])),
          SectionTitle(tr('الخصوصية والأمان', 'Privacy and security')),
          Card(
              child: Pad(BulletList(app.ar
                  ? ['جهات الاتصال والملف الشخصي والسجل تُحفظ مشفرة على هاتفك (Android Keystore) ولا تُرسل لأي خادم.', 'الموقع يُطلب فقط عند الاستغاثة أو فتح الخريطة، ولا يُشارك إلا برسالة تضغط أنت إرسالها.', 'الخريطة تتصل بخوادم OpenStreetMap لعرض الأماكن القريبة، وتُرسل إحداثيات تقريبية للبحث.', 'لا توجد حسابات أو تتبع أو إعلانات.']
                  : ['Contacts, profile and history are stored encrypted on your phone (Android Keystore) and never sent to any server.', 'Location is requested only for an SOS or when you open the map, and is shared only in a message you press send on.', 'The map contacts OpenStreetMap servers to show nearby places, sending approximate coordinates for the search.', 'No accounts, no tracking, no ads.']))),
          SectionTitle(tr('حدود التطبيق', 'Limitations')),
          Card(
              child: Pad(BulletList(app.ar
                  ? ['التطبيق لا يتصل بالإسعاف أو الشرطة أو المطافئ نيابة عنك.', 'يفتح تطبيق الرسائل برسالة جاهزة. لا يمكنه معرفة هل أُرسلت أو وصلت.', 'لا توجد جهة رسمية شريكة للتطبيق.', 'بيانات الأماكن من OpenStreetMap وغير موثقة رسمياً.']
                  : ['The app does not contact ambulance, police or fire service for you.', 'It opens your messaging app with a ready message. It cannot know whether it was sent or delivered.', 'No official body is partnered with this app.', 'Place data comes from OpenStreetMap and is not officially verified.']))),
          const SizedBox(height: 16),
          OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: sosRed, side: const BorderSide(color: sosRed)),
              icon: const Icon(Icons.delete_forever_rounded),
              onPressed: () async {
                final yes = await showDialog<bool>(
                    context: context,
                    builder: (d) => AlertDialog(title: Text(tr('حذف كل بياناتي؟', 'Delete all my data?')), content: Text(tr('سيتم حذف جهات الاتصال والملف والسجل.', 'Contacts, profile and history will be erased.')), actions: [
                          TextButton(onPressed: () => Navigator.pop(d, false), child: Text(tr('إلغاء', 'Cancel'))),
                          TextButton(onPressed: () => Navigator.pop(d, true), child: Text(tr('حذف', 'Delete'), style: const TextStyle(color: sosRed))),
                        ]));
                if (yes == true) await app.wipeAll();
              },
              label: Text(tr('حذف كل بياناتي', 'Delete all my data'))),
          const SizedBox(height: 12),
          Center(child: Text('SOS EGYPT v1.0.0', style: const TextStyle(color: Colors.black45))),
        ]),
      ),
    );
  }
}
