import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:room505/auth/login.dart';
import 'package:room505/screen/mainScreen.dart';
import 'package:room505/socket.dart';
import 'package:room505/theme.dart';
import 'package:room505/auth.dart';
import 'package:room505/chat.dart';
import 'package:room505/selected.dart';
import 'package:room505/mediaQuery.dart';
import 'package:room505/auth/authClass.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => SelectedProvider()),
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
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      //Provider.of<SocketProvider>(context, listen: false).connectToSocket();
      final appLifecycleState = WidgetsBinding.instance?.lifecycleState;
      if (appLifecycleState == AppLifecycleState.detached) {
        print("AppLifecycleState.detached");
        //Provider.of<SocketProvider>(context).socket.disconnect();
      }
    });

    bool exitApp = Provider.of<SelectedProvider>(context).getExitApp();
    if (exitApp) {
      Process.run('taskkill', ['/IM', 'room505.exe'])
          .then((ProcessResult results) {});
    }
    User user = Provider.of<AuthProvider>(context).getUserInfo();
    // print(user);
    return Consumer6<SocketProvider, ThemeProvider, AuthProvider, ChatProvider,
            SelectedProvider, MediaQueryProvider>(
        builder: (context, socketProvider, themeProvider, authProvider,
            chatProvider, selectedProvider, mediaQueryProvider, _) {
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
          child: user.uid != "" ? const MainScreen() : const Login(),
          // child: const MainScreen(),
        ),
      );
    });
  }
}
