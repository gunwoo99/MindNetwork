import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindnetwork/Network/network_page.dart';
import 'package:mindnetwork/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'SplashView',
          builder: (context, state) => const SplashViewPage(),
        ),
        GoRoute(
          path: 'NetworkPage',
          builder: (context, state) => const NetworkPage(),
        ),
      ],
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // runApp을 provider로 감싸준다.
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.blueAccent,
        ),
      ),
      routerConfig: router,
    );
  }
}

class SplashViewPage extends StatefulWidget {
  const SplashViewPage({super.key});

  @override
  State<SplashViewPage> createState() => _SplashViewPageState();
}

class _SplashViewPageState extends State<SplashViewPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      router.push('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'SplashView',
      ),
    );
  }
}
