import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';

import 'Screens/GetStartedScreen/GetStartedPage.dart';
import 'Screens/HomeScreen/HomePage.dart';
import 'Screens/LoginScreen/LoginPage.dart';
import 'Screens/SplashScreen/splash_common_page.dart';
import 'Utils/ConstHelper.dart';
import 'Utils/SharedPrefHelper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
    print('Success to block screen recording and screenshots:');
  } catch (e) {
    print('Failed to block screen recording and screenshots: $e');
  }
  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyCc5j805URN9GPfM_yNZUH9X7EBuJBkdws',
          appId: '1:126017152083:android:38a6fbbf5a750a56c452a6',
          messagingSenderId: '126017152083',
          projectId: 'singleclick-13280',
          storageBucket: 'singleclick-13280.firebasestorage.app',
        ),
      );
    } else {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyCpxF0uajriuL0aKDAg81JwPHcURaeUyG8',
          appId: '1:126017152083:ios:5d4beafa820b0214c452a6',
          messagingSenderId: '126017152083',
          projectId: 'singleclick-13280',
          storageBucket: 'singleclick-13280.firebasestorage.app',
          iosClientId:
              '126017152083-l8s1qipceb1p44a9l6abslrd1pqtd04c.apps.googleusercontent.com',
          iosBundleId: 'ags.matrimony.asvtbangalore',
        ),
      );
    }
    await FirebaseMessaging.instance.requestPermission();
    print("✅ Firebase initialized successfully");
  } catch (e) {
    print("❌ Firebase Initialization Failed: $e");
  }
  await SharedPrefHelper.sharedPrefHelper.initSharedPref();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  configLoading();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ConstHelper.orangeColor,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: ConstHelper.orangeColor,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: ConstHelper.whiteColor,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ASVT Bangalore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      navigatorKey: ConstHelper.navigatorKey,
      builder: EasyLoading.init(),
      routes: {
        '/': (p0) => const SplashCommonPage(),
        'getStarted': (p0) => const GetStartedPage(),
        'login': (p0) => const LoginPage(),
        'home': (p0) => const HomePage(),
      },
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}
