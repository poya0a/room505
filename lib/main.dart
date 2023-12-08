import 'package:flutter/material.dart';
import 'dart:io';
// import 'package:desktop_window/desktop_window.dart';
import 'package:provider/provider.dart';
import 'package:room505/auth/login.dart';
import 'package:room505/screen/mainScreen.dart';
import 'package:room505/theme.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:room505/mediaQuery.dart';
import 'package:room505/temp/tempClass.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await DesktopWindow.setMinWindowSize(const Size(200, 600));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SelectedProvider()),
        ChangeNotifierProvider(create: (_) => CreatedProvider()),
        ChangeNotifierProvider(create: (_) => MediaQueryProvider())
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool exitApp = Provider.of<SelectedProvider>(context).getExitApp();
    if (exitApp) {
      Process.run('taskkill', ['/IM', 'room505.exe'])
          .then((ProcessResult results) {});
    }
    User user = Provider.of<CreatedProvider>(context).getUserInfo();
    return Consumer4<ThemeProvider, SelectedProvider, CreatedProvider,
            MediaQueryProvider>(
        builder: (context, themeProvider, selectedProvider, CreatedProvider,
            MediaQueryProvider, _) {
      return MaterialApp(
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultMaterialLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: themeProvider.currentTheme,
        home: ChangeNotifierProvider.value(
          value: selectedProvider,
          child: user.seq != 0 ? const MainScreen() : const Login(),
        ),
      );
    });
  }
}
