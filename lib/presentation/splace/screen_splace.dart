import 'package:expance/core/common.dart';
import 'package:expance/presentation/main/main.dart';

class ScreenSplacePage extends StatefulWidget {
  const ScreenSplacePage({super.key});

  @override
  State<ScreenSplacePage> createState() => _ScreenSplacePageState();
}

class _ScreenSplacePageState extends State<ScreenSplacePage> {
  goToPage() async {
    await Future.delayed(Duration(seconds: 2));
    NavigatorService.pushReplacement(ScreenAdminMainPage());
  }

  @override
  void initState() {
    super.initState();
    goToPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
