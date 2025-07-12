import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../Controllers/HomeController.dart';
import '../../Utils/ConstHelper.dart';
import '../../Utils/SharedPrefHelper.dart';
import '../../Utils/network_connectivity_class.dart';
import '../HomeScreen/HomePage.dart';

class SplashCommonPage extends StatefulWidget {
  const SplashCommonPage({super.key});

  @override
  State<SplashCommonPage> createState() => _SplashCommonPageState();
}

class _SplashCommonPageState extends State<SplashCommonPage> {
  HomeController homeController = Get.put(HomeController());
  Map<dynamic, dynamic> data = {};
  bool isSkip = false;

  //AppUpdateInfo? _updateInfo;
  bool _flexibleUpdateAvailable = false;

  @override
  void initState() {
    // TODO: implement initState

    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
    super.initState();
  }

/*  Future<void> checkForUpdate() async {
    try {
      _updateInfo = await InAppUpdate.checkForUpdate();
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        startFlexibleUpdate();
      }
    } catch (e) {
      print("Error checking for updates: $e");
    }
  }

  // Start a flexible update
  Future<void> startFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
      print("Update installed successfully.");
    } catch (e) {
      print("Error during update: $e");
    }
  }*/
  Future<void> checkLogin() async {
    // Start a 3-second timeout fallback
/*    Future.delayed(Duration(seconds: 6), () {
      if (mounted) {
        EasyLoading.dismiss();
        Get.offNamed('getStarted');
      }
    });*/
    if (!(await ConstHelper.checkInternet())) {
      //  networkDialog(context);
      Get.to(const NoInternetScreen());
      return;
    }
    try {
      await Future.delayed(const Duration(seconds: 2));
      EasyLoading.show(status: ConstHelper.pleaseWaitMsg);

      final login =
          SharedPrefHelper.sharedPreferences.getBool('login') ?? false;
      if (!mounted) return;

      EasyLoading.dismiss();

      if (login) {
        Get.off(const HomePage());
      } else {
        Get.offNamed('getStarted');
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (mounted) {
        Get.offNamed('getStarted');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/image/AGS_LOGO.png",
                  height: Get.height * 0.15,
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                RichText(
                  text: TextSpan(
                    text: "AG ",
                    style: TextStyle(
                      fontSize: Get.height / 28,
                      color: const Color(0xFF076894),
                      fontWeight: FontWeight.w900,
                    ),
                    children: [
                      TextSpan(
                        text: "Solutions",
                        style: TextStyle(
                          fontSize: Get.height / 28,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFF076894),
            child: Text(
              "WEBSITE | WEB APPLICATION\nMOBILE APPLICATION | DIGITAL MARKETING",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Get.height / 50,
                color: const Color(0xFFffffff),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.15,
          ),
        ],
      ),
    ));
  }
}
