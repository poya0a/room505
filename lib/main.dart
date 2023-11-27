import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:room505/auth/login.dart';
import 'package:room505/screen/mainScreen.dart';
import 'package:room505/theme.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:room505/mediaQuery.dart';

void main() {
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

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String? userId = "";

  void initState() {
    super.initState();
    getLocalStorageData();
  }

  void getLocalStorageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userId = prefs.getString('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: userId != '' && userId != null
              ? const MainScreen()
              : const Login(),
        ),
      );
    });
  }
}
