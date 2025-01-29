import 'package:base_app/constants/AppPagePath.dart';
import 'package:base_app/services/SharedPrefService.dart';
import 'package:base_app/view/HomePage.dart';
import 'package:base_app/view/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/AppLifecycleObserver.dart';
import 'constants/AppThemes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isFirstLaunch = await _checkFirstLaunch();
  runApp(ProviderScope(child: MyApp(isFirstRun: isFirstLaunch,),),);
}

// Uygulama ilk açılış kontrolü
Future<bool> _checkFirstLaunch() async {
  bool isFirstLaunch = await SharedPrefService.readBool("isFirstLaunch");
  if (isFirstLaunch) {
    SharedPrefService.saveBool("isFirstLaunch", false);  // İlk açılışta veriyi güncelle
  }
  return isFirstLaunch;
}


class MyApp extends StatefulWidget {
  final bool isFirstRun;
  const MyApp({Key? key, required this.isFirstRun}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final AppLifecycleObserver _appLifecycleObserver;

  @override
  void initState() {
    super.initState();
    _appLifecycleObserver = AppLifecycleObserver(
        onBackground: () {  },
        onForeground: () {  }
    );
    WidgetsBinding.instance.addObserver(_appLifecycleObserver);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_appLifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: AppThemes.darkTheme,
      theme: AppThemes.lightTheme,
      home: widget.isFirstRun ? const SplashPage() : const HomePage(),
      routes: {
        AppPagePath.homePage.pathString: (context) => const HomePage(),
        AppPagePath.splashPage.pathString: (context) => const SplashPage(),
      },
    );
  }



}
