import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data/store.dart';
import 'screens/home_screen.dart';
import 'screens/guide_screen.dart';
import 'screens/map_screen.dart';
import 'screens/directory_screen.dart';
import 'screens/more_screen.dart';
import 'screens/onboarding.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await app.load();
  if (kIsWeb && Uri.base.queryParameters.containsKey('shot')) {
    // Preview-only: used to render screenshots of the web build. Not used on Android.
    app.onboarded = Uri.base.queryParameters['shot'] != 'onboarding';
    if (Uri.base.queryParameters['seed'] == '1') {
      app.contacts
        ..clear()
        ..add(Contact('1', 'Mona', '01001234567', primary: true))
        ..add(Contact('2', 'Ahmed', '01227654321'));
    }
  }
  runApp(const SosApp());
}

class SosApp extends StatelessWidget {
  const SosApp({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (_, __) => MaterialApp(
          title: 'SOS EGYPT',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          locale: Locale(app.ar ? 'ar' : 'en'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: app.onboarded ? const Shell() : const Onboarding(),
        ),
      );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = int.tryParse(kIsWeb ? (Uri.base.queryParameters['tab'] ?? '0') : '0') ?? 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(goTo: (n) => setState(() => i = n)),
      const GuideScreen(),
      const MapScreen(),
      const DirectoryScreen(),
      const MoreScreen(),
    ];
    return Scaffold(
      body: SafeArea(top: false, child: IndexedStack(index: i, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: i,
        onDestinationSelected: (v) => setState(() => i = v),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.sos_rounded), label: tr('الطوارئ', 'SOS')),
          NavigationDestination(icon: const Icon(Icons.support_agent_rounded), label: tr('المساعد', 'Assistant')),
          NavigationDestination(icon: const Icon(Icons.map_rounded), label: tr('الخريطة', 'Map')),
          NavigationDestination(icon: const Icon(Icons.call_rounded), label: tr('الأرقام', 'Numbers')),
          NavigationDestination(icon: const Icon(Icons.menu_rounded), label: tr('المزيد', 'More')),
        ],
      ),
    );
  }
}
