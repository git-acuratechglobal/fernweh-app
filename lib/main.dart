import 'package:fernweh/services/local_storage_service/local_storage_service.dart';
import 'package:fernweh/utils/app_theme/app_theme.dart';
import 'package:fernweh/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp( ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);
    return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            home: const SplashScreen(),
          );
  }
}
