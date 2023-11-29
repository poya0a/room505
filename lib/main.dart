import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room505/auth/login.dart';
import 'package:room505/screen/mainScreen.dart';
import 'package:room505/theme.dart';
import 'package:room505/selected.dart';
import 'package:room505/created.dart';
import 'package:room505/mediaQuery.dart';
import 'package:room505/temp/tempClass.dart';

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

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<UserList> user = Provider.of<CreatedProvider>(context).getUserInfo();
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
          child: user.isNotEmpty ? const MainScreen() : const Login(),
        ),
      );
    });
  }
}
