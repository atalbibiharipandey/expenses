import 'package:expance/core/constants/constants.dart';
import 'package:expance/core/size_utils.dart';
import 'package:expance/core/utils/my_colors.dart';
import 'package:expance/core/utils/navigator_service.dart';
import 'package:expance/core/utils/snack_bar.dart';
import 'package:expance/presentation/splace/screen_splace.dart';
import 'package:expance/services/local_db/db_models.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeLocalDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getSize(context);
    return MaterialApp(
      title: constants.appName,
      scaffoldMessengerKey: globalMessengerKey,
      navigatorKey: NavigatorService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: cPrimery),
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
