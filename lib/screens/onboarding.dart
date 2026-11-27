import 'package:flutter/material.dart';
import '../data/store.dart';
import '../theme.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                  onPressed: () => app.setLang(!app.ar),
                  child: Text(app.ar ? 'English' : 'العربية', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
            ),
            const Spacer(),
            Center(
              child: Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(color: sosRed, shape: BoxShape.circle),
                  child: const Icon(Icons.sos_rounded, color: Colors.white, size: 64)),
            ),
            const SizedBox(height: 24),
            const Text('SOS EGYPT', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
            const SizedBox(height: 8),
            Text(tr('مساعدة الطوارئ والسلامة الشخصية في مصر', 'Emergency help and personal safety in Egypt'),
                textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 28),
            _pt(Icons.call_rounded, tr('الاتصال بالإسعاف 123 والنجدة 122 والمطافئ 180 بضغطة واحدة.', 'One tap to call ambulance 123, police 122, fire 180.')),
            _pt(Icons.sms_rounded, tr('يجهز رسالة استغاثة بموقعك لجهات اتصالك، وأنت تضغط إرسال.', 'Prepares a distress message with your location for your contacts. You press send.')),
            _pt(Icons.privacy_tip_rounded, tr('بياناتك تبقى على هاتفك. الموقع يُطلب فقط عند الحاجة.', 'Your data stays on your phone. Location is only requested when needed.')),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(14)),
              child: Text(
                  tr('تنبيه: هذا التطبيق لا يتصل بخدمات الطوارئ نيابة عنك ولا يحل محلها. في الخطر الحقيقي اتصل بالأرقام الرسمية مباشرة.',
                      'Notice: this app does not contact emergency services for you and does not replace them. In real danger, call the official numbers directly.'),
                  style: const TextStyle(color: Colors.white, height: 1.4)),
            ),
            const Spacer(),
            FilledButton(
                style: FilledButton.styleFrom(backgroundColor: sosRed, minimumSize: const Size.fromHeight(56)),
                onPressed: () => app.finishOnboarding(),
                child: Text(tr('ابدأ', 'Get started'))),
          ]),
        ),
      ),
    );
  }

  Widget _pt(IconData i, String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(children: [
          Icon(i, color: Colors.white, size: 26),
          const SizedBox(width: 14),
          Expanded(child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4))),
        ]),
      );
}
