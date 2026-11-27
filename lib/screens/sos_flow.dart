import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../data/content.dart';
import '../data/store.dart';
import '../services/sos_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

enum Stage { countdown, working, ready, cancelled }

class SosFlow extends StatefulWidget {
  final bool test;
  const SosFlow({super.key, required this.test});
  @override
  State<SosFlow> createState() => _SosFlowState();
}

class _SosFlowState extends State<SosFlow> {
  Stage stage = Stage.countdown;
  int left = 5;
  Timer? t;
  Position? pos;
  String? locError;
  String message = '';
  bool confirmedSent = false;
  final opened = <String>{};

  @override
  void initState() {
    super.initState();
    if (widget.test) {
      _prepare();
    } else {
      t = Timer.periodic(const Duration(seconds: 1), (tm) {
        HapticFeedback.mediumImpact();
        setState(() => left--);
        if (left <= 0) {
          tm.cancel();
          _prepare();
        }
      });
    }
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  Future<void> _prepare() async {
    setState(() => stage = Stage.working);
    final r = await getLocation();
    pos = r.pos;
    locError = r.error;
    message = buildMessage(test: widget.test, pos: pos);
    if (!mounted) return;
    setState(() => stage = Stage.ready);
    await app.addHistory(AlertRecord(
        DateTime.now(),
        widget.test ? AlertStatus.test : (app.selectedContacts.isEmpty ? AlertStatus.failed : AlertStatus.prepared),
        widget.test
            ? tr('اختبار الإعداد', 'Setup test')
            : (app.selectedContacts.isEmpty
                ? tr('لا توجد جهات اتصال. لم يتم تجهيز إرسال.', 'No contacts. Nothing could be sent.')
                : tr('تم تجهيز الرسالة على الهاتف', 'Message prepared on the phone')),
        app.selectedContacts.length,
        lat: pos?.latitude,
        lon: pos?.longitude));
  }

  void _cancel() {
    t?.cancel();
    if (stage == Stage.countdown) {
      app.addHistory(AlertRecord(DateTime.now(), AlertStatus.cancelled, tr('أُلغي خلال العد التنازلي', 'Cancelled during countdown'), 0));
    }
    Navigator.pop(context);
  }

  Future<void> _markSent(bool v) async {
    setState(() => confirmedSent = v);
    if (v && !widget.test) {
      await app.replaceFirstHistory(AlertRecord(DateTime.now(), AlertStatus.opened,
          tr('أكّدت أنك ضغطت إرسال. التسليم غير مؤكد.', 'You confirmed pressing send. Delivery is not verified.'), app.selectedContacts.length,
          lat: pos?.latitude, lon: pos?.longitude));
    }
  }

  @override
  Widget build(BuildContext context) {
    final danger = !widget.test;
    return Scaffold(
      backgroundColor: stage == Stage.countdown && danger ? sosRed : bg,
      appBar: stage == Stage.countdown && danger
          ? null
          : AppBar(title: Text(widget.test ? tr('اختبار الإعداد', 'Setup test') : tr('حالة الاستغاثة', 'SOS status'))),
      body: SafeArea(child: stage == Stage.countdown && danger ? _countdown() : _body()),
    );
  }

  Widget _countdown() => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const Spacer(),
          Text(tr('سيتم تجهيز الاستغاثة خلال', 'Preparing your SOS in'), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Text('$left', style: const TextStyle(color: Colors.white, fontSize: 130, fontWeight: FontWeight.w800)),
          Text(tr('لم يُرسل شيء بعد.', 'Nothing has been sent yet.'), style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 72,
            child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: sosRed),
                onPressed: _cancel,
                child: Text(tr('إلغاء - كان ذلك بالخطأ', 'CANCEL - this was a mistake'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
          ),
        ]),
      );

  Widget _step(bool? done, String title, [String? sub]) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          done == null
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3))
              : Icon(done ? Icons.check_circle_rounded : Icons.error_rounded, color: done ? ok : sosRed),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            if (sub != null) Text(sub, style: const TextStyle(color: Colors.black54, height: 1.3)),
          ])),
        ]),
      );

  Widget _body() {
    final working = stage == Stage.working;
    final contacts = app.selectedContacts;
    return ListView(padding: const EdgeInsets.all(16), children: [
      if (widget.test) InfoBox(tr('وضع الاختبار: لن يتم إرسال أي شيء. نتحقق فقط من الإعداد.', 'Test mode: nothing will be sent. We only check your setup.'), color: ok, icon: Icons.science_rounded),
      Card(
          child: Pad(Column(children: [
        _step(true, tr('تم تفعيل الاستغاثة', 'Alert started')),
        _step(working ? null : pos != null, working ? tr('جارٍ تحديد الموقع...', 'Getting your location...') : (pos != null ? tr('تم تحديد الموقع', 'Location found') : tr('الموقع غير متاح', 'Location unavailable')),
            working ? null : (pos != null ? '±${pos!.accuracy.round()} m' : locError)),
        _step(working ? null : contacts.isNotEmpty, working ? tr('جارٍ تجهيز الرسالة', 'Preparing message') : (contacts.isNotEmpty ? tr('الرسالة جاهزة على هذا الهاتف', 'Message ready on this phone') : tr('لا توجد جهات اتصال محددة', 'No contacts selected')),
            working ? null : (contacts.isNotEmpty ? tr('لم تُرسل بعد. اضغط أدناه لفتح تطبيق الرسائل ثم اضغط إرسال.', 'Not sent yet. Tap below to open your messaging app, then press send.') : tr('أضف جهات اتصال من "المزيد".', 'Add contacts from "More".'))),
        if (!widget.test && !working) _step(confirmedSent, confirmedSent ? tr('أكّدت الإرسال (التسليم غير مؤكد)', 'You confirmed sending (delivery not verified)') : tr('لم يتم تأكيد الإرسال', 'Sending not confirmed')),
      ]))),
      const SizedBox(height: 12),
      if (!working) ...[
        if (!widget.test) ...[
          Text(tr('اتصل بالجهة المناسبة الآن', 'Call the right service now'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: navy)),
          const SizedBox(height: 8),
          for (final id in ['ambulance', 'police', 'fire']) Padding(padding: const EdgeInsets.only(bottom: 8), child: SizedBox(width: double.infinity, child: CallChip(svcById(id), big: true))),
          const SizedBox(height: 8),
        ],
        Card(
            child: Pad(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tr('نص الرسالة', 'Message text'), style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          SelectableText(message, style: const TextStyle(height: 1.5)),
        ]))),
        const SizedBox(height: 12),
        if (!widget.test && contacts.isNotEmpty) ...[
          FilledButton.icon(
              icon: const Icon(Icons.sms_rounded),
              onPressed: () async {
                final ok2 = await openSmsComposer(contacts.map((c) => c.phone).toList(), message);
                if (!ok2 && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('تعذر فتح تطبيق الرسائل.', 'Could not open the SMS app.'))));
                }
              },
              label: Text(tr('فتح الرسائل لكل الجهات', 'Open SMS for all contacts'))),
          const SizedBox(height: 8),
          for (final c in contacts)
            Card(
                child: ListTile(
              leading: CircleAvatar(backgroundColor: navy, child: Text(c.name.isNotEmpty ? c.name[0] : '?', style: const TextStyle(color: Colors.white))),
              title: Text(c.name),
              subtitle: Text(c.phone),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(tooltip: 'WhatsApp', icon: const Icon(Icons.chat_rounded, color: ok), onPressed: () => openWhatsApp(c.phone, message)),
                IconButton(tooltip: tr('اتصال', 'Call'), icon: const Icon(Icons.call_rounded, color: navy), onPressed: () => callNumber(context, normalizePhone(c.phone))),
              ]),
            )),
          const SizedBox(height: 10),
          if (!confirmedSent)
            OutlinedButton(onPressed: () => _markSent(true), child: Text(tr('أرسلتُ الرسالة', 'I sent the message')))
          else
            InfoBox(tr('تم تسجيل أنك أرسلت الرسالة. التطبيق لا يستطيع التأكد من وصولها.', 'Recorded that you sent it. The app cannot confirm it was delivered.'), color: warn),
        ],
        if (widget.test) ..._testReport(contacts),
        const SizedBox(height: 12),
        OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: sosRed, side: const BorderSide(color: sosRed)),
            onPressed: () => Navigator.pop(context),
            child: Text(widget.test ? tr('إغلاق', 'Close') : tr('إلغاء / إنهاء', 'Cancel / finish'))),
        const SizedBox(height: 10),
        InfoBox(tr('التطبيق يجهز الرسالة فقط. لا يتصل بالإسعاف أو الشرطة ولا يضمن وصول الرسائل.', 'The app only prepares the message. It does not contact ambulance or police and cannot guarantee delivery.')),
      ],
    ]);
  }

  List<Widget> _testReport(List<Contact> contacts) {
    final bad = contacts.where((c) => !validPhone(c.phone)).toList();
    Widget row(bool good, String s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [Icon(good ? Icons.check_circle_rounded : Icons.cancel_rounded, color: good ? ok : sosRed), const SizedBox(width: 10), Expanded(child: Text(s))]));
    return [
      Card(
          child: Pad(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(tr('نتيجة الفحص', 'Check results'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        row(contacts.isNotEmpty, tr('جهات الاتصال المحددة: ${contacts.length}', 'Selected contacts: ${contacts.length}')),
        row(bad.isEmpty && contacts.isNotEmpty, bad.isEmpty ? tr('كل الأرقام تبدو صحيحة', 'All numbers look valid') : tr('أرقام غير صحيحة: ${bad.map((e) => e.name).join('، ')}', 'Invalid numbers: ${bad.map((e) => e.name).join(', ')}')),
        row(contacts.any((c) => c.primary), tr('جهة اتصال أساسية محددة', 'A primary contact is set')),
        row(pos != null, pos != null ? tr('الموقع يعمل', 'Location works') : tr('الموقع لا يعمل: ${locError ?? ''}', 'Location not working: ${locError ?? ''}')),
        row(app.profile.shareInSos ? !app.profile.isEmpty : true, app.profile.shareInSos ? tr('بيانات الطوارئ ستُرفق (بموافقتك)', 'Emergency info will be attached (with your consent)') : tr('بيانات الطوارئ لن تُرفق', 'Emergency info will not be attached')),
      ]))),
    ];
  }
}
