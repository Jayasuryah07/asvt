import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../models/user_data_model.dart';
import '../../utils/api_helper.dart';
import '../../utils/const_helper.dart';
import '../../utils/shared_pref_helper.dart';
import '../home_screen/home_page.dart';
import '../sign_up_screen/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  HomeController homeController = Get.put(HomeController());
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool hidePassword = true.obs;

  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    //EasyLoading.dismiss();
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstHelper.whiteColor,
        body: Form(
          key: formKey,
          child: Stack(
            children: [
              Container(
                width: Get.width,
                height: Get.height,
                color: ConstHelper.lightBlackColor,
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'assets/image/loginPage.jpg',
                    width: Get.width,
                    height: Get.height,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(),
              Obx(
                    () => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * 0.04,
                      ),
                      Center(
                        child: Container(
                          height: Get.width / 2.2,
                          width: Get.width / 2.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/image/applogo.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.width / 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'AGRAWAL SAMAJ VIKAS TRUST',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ConstHelper.whiteColor,
                                fontSize: Get.width * 0.065,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.04,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width / 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login'.toUpperCase(),
                              style: TextStyle(
                                color: ConstHelper.whiteColor,
                                fontSize: Get.width * 0.055,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: Get.width / 30,
                            ),
                            TextFormField(
                              controller: txtUsername,
                              cursorColor: ConstHelper.whiteColor,
                              style: TextStyle(
                                fontSize: Get.width * 0.045,
                                letterSpacing: 1,
                                color: ConstHelper.whiteColor,
                              ),
                              focusNode: usernameFocusNode,
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Please enter userId';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                counterText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: ConstHelper.whiteColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: ConstHelper.whiteColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: ConstHelper.whiteColor,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Get.width / 30,
                                ),
                                labelText: 'User ID',
                                errorStyle: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  letterSpacing: 1,
                                  color: ConstHelper.whiteColor,
                                ),
                                labelStyle: TextStyle(
                                  fontSize: Get.width * 0.035,
                                  letterSpacing: 1,
                                  color: ConstHelper.whiteColor,
                                ),
                                prefixIcon: SizedBox(
                                  height: Get.width / 20,
                                  width: Get.width / 20,
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/image/personSVG.svg',
                                      height: Get.width / 20,
                                      width: Get.width / 20,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Get.width / 20,
                            ),
                            TextFormField(
                              controller: txtPassword,
                              style: TextStyle(
                                color: ConstHelper.whiteColor,
                              ),
                              maxLength: 12,
                              cursorColor: ConstHelper.whiteColor,
                              focusNode: passwordFocusNode,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              obscureText: hidePassword.value,
                              decoration: InputDecoration(
                                counterText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: ConstHelper.whiteColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: ConstHelper.whiteColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: ConstHelper.whiteColor,
                                  ),
                                ),
                                errorStyle: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  letterSpacing: 1,
                                  color: ConstHelper.whiteColor,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: Get.width / 30,
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  fontSize: Get.width * 0.035,
                                  letterSpacing: 1,
                                  color: ConstHelper.whiteColor,
                                ),
                                prefixIcon: SizedBox(
                                    height: Get.width / 20,
                                    width: Get.width / 20,
                                    child: Center(
                                        child: SvgPicture.asset(
                                          'assets/image/passwordSVG.svg',
                                          height: Get.width / 20,
                                          width: Get.width / 20,
                                          fit: BoxFit.contain,
                                        ))),
                                // suffixIcon: SizedBox(height: Get.width/20,width: Get.width/20,child: Center(child: SvgPicture.asset('assets/image/eyeNoVisibleSVG.svg',height: Get.width/20,width: Get.width/20,fit: BoxFit.contain,))),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    hidePassword.value = !hidePassword.value;
                                  },
                                  icon: hidePassword.value
                                      ? Image.asset(
                                    'assets/image/eyeVisibility.png',
                                    height: Get.width / 20,
                                    width: Get.width / 20,
                                    fit: BoxFit.contain,
                                    color: ConstHelper.cementColor,
                                  )
                                      : SvgPicture.asset(
                                    'assets/image/eyeNoVisibleSVG.svg',
                                    height: Get.width / 20,
                                    width: Get.width / 20,
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(
                                      ConstHelper.cementColor,
                                      BlendMode.srcIn, // same effect as old `color`
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(height: Get.width/60,),
                            // Align(
                            //   alignment: Alignment.centerRight,
                            //   child: Text(
                            //     'Forget Password?',
                            //     style: TextStyle(
                            //       color: ConstHelper.cementColor,
                            //       fontWeight: FontWeight.w600,
                            //       fontSize: 14,
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: Get.width / 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                EasyLoading.show(
                                  status: ConstHelper.pleaseWaitMsg,
                                );
                                await Future.delayed(
                                  Duration(
                                    milliseconds: 200,
                                  ),
                                );
                                usernameFocusNode.unfocus();
                                passwordFocusNode.unfocus();
                                if (!(await ConstHelper.checkInternet())) {
                                  EasyLoading.dismiss();
                                  ConstHelper.errorDialog(
                                    text: ConstHelper.internetMsg,
                                    seconds: 10,
                                  );
                                } else {
                                  ///523
                                  ///asvt50965
                                  if (txtUsername.text.trim().isEmpty) {
                                    EasyLoading.dismiss();
                                    usernameFocusNode.requestFocus();
                                  } else if (txtPassword.text.trim().isEmpty) {
                                    EasyLoading.dismiss();
                                    passwordFocusNode.requestFocus();
                                  }

                                  if (formKey.currentState!.validate()) {
                                    try {
                                      String? token;
                                      if (Platform.isIOS) {
                                        token = await FirebaseMessaging.instance
                                            .getAPNSToken();
                                        debugPrint('APNS Token: $token');
                                      } else {
                                        FirebaseMessaging messaging =
                                            FirebaseMessaging.instance;
                                        token = await messaging.getToken();
                                        debugPrint('APNS Token: $token');
                                      }

                                      homeController.firebaseFCMToken.value =
                                          token ?? "";
                                      log("Token : $token");
                                      log("Token : ${homeController.firebaseFCMToken.value}");

                                      await ApiHelper.apiHelper
                                          .loginUser(
                                        profileId: txtUsername.text.toString(),
                                        password: txtPassword.text.trim(),
                                        deviceId: token ?? "",
                                      )
                                          .then(
                                            (userData) async {
                                          if (userData.isNotEmpty) {
                                            if (userData['code'] == 200) {
                                              UserDataModel userDataModel =
                                              UserDataModel.fromJson(
                                                  userData);

                                              debugPrint('userDataModel: ${userDataModel.data}');
                                              debugPrint(userDataModel.data?.token ??
                                                  "");
                                              SharedPrefHelper.sharedPreferences
                                                  .setBool(
                                                'login',
                                                true,
                                              );
                                              SharedPrefHelper.sharedPreferences
                                                  .setString(
                                                'userData',
                                                jsonEncode(userDataModel),
                                              );
                                              await homeController
                                                  .getUserData();
                                              EasyLoading.dismiss();
                                              homeController
                                                  .advancedDrawerController =
                                                  AdvancedDrawerController();
                                              Get.off(
                                                const HomePage(),
                                              );
                                              Get.snackbar(
                                                "Success",
                                                "Login Successfully",
                                                snackPosition:
                                                SnackPosition.BOTTOM,
                                              );
                                            } else {
                                              EasyLoading.dismiss();
                                              Get.snackbar(
                                                "Error! 1",
                                                userData['msg'] ??
                                                    ConstHelper
                                                        .somethingErrorMsg,
                                                snackPosition:
                                                SnackPosition.BOTTOM,
                                              );
                                            }
                                          } else {
                                            EasyLoading.dismiss();
                                            Get.snackbar(
                                              "Error! 2",
                                              'Unauthorised.',
                                              snackPosition:
                                              SnackPosition.BOTTOM,
                                            );
                                          }
                                        },
                                      );
                                    } catch (error) {
                                      EasyLoading.dismiss();
                                      debugPrint('Error3: $error');
                                      Get.snackbar(
                                        "Error! 3",
                                        error.toString(),
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  } else {
                                    EasyLoading.dismiss();
                                  }
                                }
                              },
                              child: Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: ConstHelper.orangeColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical: Get.width / 30,
                                ),
                                child: Text(
                                  'Login'.toUpperCase(),
                                  style: TextStyle(
                                    color: ConstHelper.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.width * 0.05,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Get.width / 15,
                            ),
                            Center(
                              child: Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: ConstHelper.whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Get.width * 0.04,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            // SizedBox(height: Get.width/90,),
                            Center(
                              child: InkWell(
                                onTap: () async {
                                  EasyLoading.show(status: 'Please wait...');
                                  await Future.delayed(
                                    const Duration(
                                      milliseconds: 100,
                                    ),
                                  );
                                  try {
                                    if (await ConstHelper.checkInternet()) {
                                      homeController.communityDataList.value =
                                      await ApiHelper.apiHelper
                                          .getCommunityDataList();
                                      homeController.budgetCateModel.value =
                                      await ApiHelper.apiHelper
                                          .getBudgetCate();
                                      await homeController.getDropDownData();
                                      homeController
                                          .gotraDataListCommunityIdWise
                                          .value = [];
                                      homeController.educationDataList.value =
                                      await ApiHelper.apiHelper
                                          .getEducationDataList();
                                      Get.to(
                                        const SignUpPage(),
                                      );
                                      EasyLoading.dismiss();
                                    } else {
                                      EasyLoading.dismiss();
                                      ConstHelper.errorDialog(
                                        text: ConstHelper.internetMsg,
                                        seconds: 10,
                                      );
                                    }
                                  } catch (error) {
                                    EasyLoading.dismiss();
                                    ConstHelper.errorDialog(
                                      text: ConstHelper.somethingErrorMsg,
                                      seconds: 10,
                                    );
                                  }
                                },
                                child: Text(
                                  "Join us today!",
                                  style: TextStyle(
                                    color: ConstHelper.orangeColor,
                                    decoration: TextDecoration.underline,
                                    decorationColor: ConstHelper.orangeColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: Get.width * 0.05,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Get.width / 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
