import 'package:expance/core/common.dart';
import 'package:expance/core/constants/constants.dart';
import 'package:expance/presentation/splace/screen_splace.dart';
import 'package:expance/services/local_db/db_models.dart';
import 'package:expance/services/local_db/local_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeLocalDatabase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  changeThemeToggel() {
    print("Theme Change Function Called...");
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    if (themeMode == ThemeMode.dark) {
      LocalDb.prefs.setInt("theme", 1);
    } else {
      LocalDb.prefs.setInt("theme", 0);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    changeTheme = changeThemeToggel;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      themeMode = LocalDb.prefs.getInt("theme") == 1
          ? ThemeMode.dark
          : ThemeMode.light;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    getSize(context);
    return MaterialApp(
      title: constants.appName,
      scaffoldMessengerKey: globalMessengerKey,
      navigatorKey: NavigatorService.navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: cPrimery),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: cPrimery),
        ),
        scaffoldBackgroundColor: cwhite,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: cPrimery,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: cPrimery),
        ),
        scaffoldBackgroundColor: cwhite,
      ),
      home: const ScreenSplacePage(),
    );
  }
}
