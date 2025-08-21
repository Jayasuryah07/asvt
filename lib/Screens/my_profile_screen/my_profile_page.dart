import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/home_controller.dart';
import '../../utils/api_helper.dart';
import '../../utils/const_helper.dart';
import '../../utils/shared_pref_helper.dart';
import '../home_screen/members_data_show_page.dart';
import '../login_screen/login_page.dart';
import 'edit_photo.dart';
import 'edit_profile_page.dart';

class InfoRow extends StatelessWidget {
  final String title;
  final String? value;
  final TextStyle titleStyle;
  final TextStyle valueStyle;
  final String? suffix;
  final bool? isTrue;

  const InfoRow({
    required this.title,
    required this.value,
    required this.titleStyle,
    required this.valueStyle,
    this.suffix,
    super.key,
    this.isTrue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Get.width / 90),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(title.trim().isEmpty ? " - - - -" : title,
                  style: titleStyle)),
          isTrue != null && isTrue == true
              ? const SizedBox()
              : threeDotWidget(),
          if (suffix != null) Text(suffix!, style: valueStyle),
          isTrue != null && isTrue == true
              ? const SizedBox()
              : Expanded(
                  child: Text(
                    value?.trim().isEmpty ?? true ? '-' : value!,
                    style: valueStyle,
                  ),
                ),
        ],
      ),
    );
  }
}

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    print(homeController.userData.value.updatedAt);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Profile",
            style: TextStyle(
              fontSize: Get.width * 0.055,
              color: ConstHelper.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(
              'assets/image/drawerIconSVG.svg',
              height: Get.width / 18,
              width: Get.width / 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: ConstHelper.whiteColor,
          surfaceTintColor: ConstHelper.whiteColor,
          elevation: 10,
          shadowColor: ConstHelper.greyColor.withOpacity(0.1),
          actions: [
            IconButton(
              onPressed: () async {
                Get.back();
                await Future.delayed(
                  const Duration(
                    milliseconds: 300,
                  ),
                );
                homeController.advancedDrawerController.hideDrawer();
              },
              icon: SvgPicture.asset(
                'assets/image/homeSVG.svg',
                height: Get.width / 18,
                width: Get.width / 18,
                color: ConstHelper.orangeColor,
              ),
            ),
          ],
          // elevation: 3,
          // shadowColor: Colors.grey.shade50.withOpacity(0.3),
        ),
        backgroundColor: ConstHelper.whiteColor,
        body: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width / 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.width / 30,
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Center(
                        child: Container(
                          height: Get.width / 1.6,
                          width: Get.width / 1.6,
                          margin: EdgeInsets.only(top: Get.height * 0.01),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ConstHelper.blackColor.withOpacity(0.8),
                                ConstHelper.orangeColor.withOpacity(0.8),
                              ],
                            ),
                          ),
                          padding: EdgeInsets.all(Get.width / 80),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: CachedNetworkImage(
                              imageUrl: homeController.userData.value
                                              .profileFullFacePhotoFileName !=
                                          null &&
                                      homeController.userData.value
                                          .profileFullFacePhotoFileName!
                                          .trim()
                                          .isNotEmpty
                                  ? '${ConstHelper.userImagesPath}${homeController.userData.value.profileFullFacePhotoFileName!}'
                                  : ConstHelper.profileImagePath,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: ConstHelper.whiteColor,
                                ),
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color: ConstHelper.orangeColor,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: ConstHelper.whiteColor,
                                ),
                                child: Image.asset(
                                  'assets/image/imageNotFound.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 30,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(EditPhotoPage());
                          },
                          child: Container(
                            padding: EdgeInsets.all(Get.height * 0.01),
                            decoration: BoxDecoration(
                                color: ConstHelper.orangeDarkColor,
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.mode_edit_sharp,
                              color: ConstHelper.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.width / 15,
                  ),
                  Center(
                    child: Text(
                      homeController.userData.value.name == null ||
                              homeController.userData.value.name!.trim().isEmpty
                          ? ConstHelper.nameNotAvailableMsg
                          : homeController.userData.value.name!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ConstHelper.blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.width * 0.055,
                      ),
                    ),
                  ),
                  Center(
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'User ID : ',
                            style: TextStyle(
                              color: ConstHelper.blackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: Get.width * 0.045,
                            ),
                          ),
                          TextSpan(
                            text: homeController.userData.value.id == null ||
                                    homeController.userData.value.id == 0
                                ? ConstHelper.naMsg
                                : homeController.userData.value.id!.toString(),
                            style: TextStyle(
                              color: ConstHelper.orangeColor,
                              fontWeight: FontWeight.w500,
                              fontSize: Get.width * 0.045,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.width / 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/image/personWithRoundedSVG.svg',
                            height: Get.width / 25,
                            width: Get.width / 25,
                            color: ConstHelper.blackColor,
                          ),
                          SizedBox(
                            width: Get.width / 30,
                          ),
                          Flexible(
                            child: Text(
                              'Personal Information',
                              style: headingTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 20,
                      ),
                      InfoRow(
                        title: 'Date of Birth',
                        value:
                            homeController.userData.value.profileDateOfBirth ==
                                    null
                                ? null
                                : DateFormat('dd | MMM | yyyy').format(
                                    homeController
                                        .userData.value.profileDateOfBirth!),
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Time of Birth',
                        value: normalizeTime(
                            homeController.userData.value.profileTimeOfBirth ??
                                ""),
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Place of Birth',
                        value:
                            homeController.userData.value.profilePlaceOfBirth,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Height',
                        value:
                            homeController.userData.value.profileHeight == null
                                ? null
                                : convertInchesToFeetInch(homeController
                                        .userData.value.profileHeight
                                        ?.toInt() ??
                                    0),
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Gender',
                        value: homeController.userData.value.profileGender,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Email',
                        value: homeController.userData.value.email,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      /*InfoRow(
                        title: 'Mobile No',
                        value:
                            homeController.userData.value.profileMainContactNum,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Whatsapp No',
                        value: homeController.userData.value.sWhatsapp,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Married Before',
                        value: homeController
                            .userData.value.profileHaveMarriedBefore,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),*/
                      InfoRow(
                        title: 'Physical Disability(if any)',
                        value: homeController
                            .userData.value.profilePhysicalDisablity,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      myDividerWidget(),
                    ],
                  ),
                  SizedBox(
                    height: Get.width / 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/image/occupationSVG.svg',
                            height: Get.width / 25,
                            width: Get.width / 25,
                            color: ConstHelper.blackColor,
                          ),
                          SizedBox(
                            width: Get.width / 30,
                          ),
                          Flexible(
                            child: Text(
                              'Occupation Details',
                              style: headingTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 20,
                      ),
                      InfoRow(
                        title: 'Qualification Category',
                        value: homeController
                            .userData.value.profileEducationQualification,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Profession',
                        value: homeController.userData.value.profileProfession,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Organization',
                        value: homeController
                            .userData.value.profileProfessionOrgName,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Org. type',
                        value: homeController
                            .userData.value.profileProfessionOrgType,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Annual Income (In lacs)',
                        value: homeController
                            .userData.value.profileProfessionAnnualNetIncome
                            .toString(),
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      myDividerWidget(),
                    ],
                  ),
                  SizedBox(
                    height: Get.width / 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/image/familySVG.svg',
                            height: Get.width / 25,
                            width: Get.width / 25,
                            color: ConstHelper.blackColor,
                          ),
                          SizedBox(
                            width: Get.width / 30,
                          ),
                          Flexible(
                            child: Text(
                              'Family Details',
                              style: headingTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 20,
                      ),
                      InfoRow(
                        title: 'Father Name',
                        value:
                            homeController.userData.value.profileFatherFullName,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Mother Name',
                        value:
                            homeController.userData.value.profileMotherFullName,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: "Mobile (Father)",
                        value:
                            homeController.userData.value.profileMainContactNum,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: "Mobile (Mother)",
                        value: homeController
                            .userData.value.profileAlternateContactNum,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Brother',
                        value:
                            "M - ${homeController.userData.value.profileMarriedBrother ?? ""}   Un-M - ${homeController.userData.value.profileUnmarriedBrother ?? ""}",
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Sister',
                        value:
                            "M - ${homeController.userData.value.profileMarriedSister ?? ""}   Un-M - ${homeController.userData.value.profileUnmarriedSister ?? ""}",
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      /* InfoRow(
                        title: 'Present City',
                        value: homeController.userData.value.profilePresentCity,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),*/
                      InfoRow(
                        title:
                            'Currant Address (${homeController.userData.value.profileHouseType ?? '-'}  - ${homeController.userData.value.profileNumOfYearsAtThisAddress ?? '-'})',
                        value: homeController
                            .userData.value.profileCurrentResidAddress,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      /*InfoRow(
                        title: 'Brief of father profession',
                        value:
                            homeController.userData.value.briefFatherProfession,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Important Note',
                        value: homeController.userData.value.profileNote,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),*/
                      myDividerWidget(),
                    ],
                  ),
                  SizedBox(
                    height: Get.width / 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/image/kundaliSVG.svg',
                            height: Get.width / 25,
                            width: Get.width / 25,
                            color: ConstHelper.blackColor,
                          ),
                          SizedBox(
                            width: Get.width / 30,
                          ),
                          Flexible(
                            child: Text(
                              'Kundali',
                              style: headingTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 20,
                      ),
                      InfoRow(
                        title: 'Gotra',
                        value: homeController.userData.value.profileGotra,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Matching kundali',
                        value:
                            homeController.userData.value.profileWillMatchGanna,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Marry in same gotra',
                        value: homeController
                            .userData.value.profileMarryInComunity,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Are you Manglik?',
                        value: homeController.userData.value.profileIsManglik,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Will you Marry A Manglik?',
                        value: homeController
                            .userData.value.profileWillMarryManglink,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      /*  InfoRow(
                        title: 'Community',
                        value:
                            homeController.userData.value.profileComunityName,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Community',
                        value: homeController
                            .userData.value.profileMarryInComunity,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),*/
                      myDividerWidget(),
                    ],
                  ),
                  SizedBox(
                    height: Get.width / 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/image/partnerSVG.svg',
                            height: Get.width / 25,
                            width: Get.width / 25,
                            color: ConstHelper.blackColor,
                          ),
                          SizedBox(
                            width: Get.width / 30,
                          ),
                          Flexible(
                            child: Text(
                              'Partner preferences',
                              style: headingTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 20,
                      ),
                      InfoRow(
                        title: 'P. Spouse can be elder(> yrs)',
                        value: homeController
                                .userData.value.profileSpouseCanBeOlderBy ??
                            '-',
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'P. Spouse can be younger(< yrs)',
                        value: homeController
                            .userData.value.profileSpouseCanBeYoungerBy,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Bride permitted',
                        value: homeController.userData.value
                            .profileBridePermittedToWorkAfterMarriage,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Current city',
                        value: homeController.userData.value.collageCity,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Resident after marriage',
                        value: homeController
                            .userData.value.profilePlaceOfResidAfterMarriage,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      myDividerWidget(),
                    ],
                  ),
                  SizedBox(
                    height: Get.width / 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/image/familySVG.svg',
                            height: Get.width / 25,
                            width: Get.width / 25,
                            color: ConstHelper.blackColor,
                          ),
                          SizedBox(
                            width: Get.width / 30,
                          ),
                          Flexible(
                            child: Text(
                              'Contact References',
                              style: headingTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 20,
                      ),
                      InfoRow(
                        title: 'Name',
                        value: homeController
                            .userData.value.profileMainContactFullName,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Mobile',
                        value:
                            homeController.userData.value.profileMainContactNum,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Location',
                        value: homeController
                            .userData.value.profileCurrentResidAddress,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      myDividerWidget(),
                    ],
                  ),
                  SizedBox(
                    height: Get.width / 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/image/ruppeSVG.svg',
                            height: Get.width / 25,
                            width: Get.width / 25,
                            color: ConstHelper.blackColor,
                          ),
                          SizedBox(
                            width: Get.width / 30,
                          ),
                          Flexible(
                            child: Text(
                              'Budget Info (In lacs)',
                              style: headingTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 20,
                      ),
                      InfoRow(
                        title: 'Budget Bride',
                        value: homeController
                            .userData.value.profileBudgetCategoryId,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title: 'Budget Groom',
                        value: homeController
                            .userData.value.profileGroomBudgetCategoryId,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      SizedBox(
                        height: Get.width / 30,
                      ),
                      InfoRow(
                        title:
                            'Profile Created - ${DateFormat("dd-MM-yyyy").format(homeController.userData.value.profileRegistrationDate ?? DateTime.now())}',
                        value: "",
                        isTrue: true,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      InfoRow(
                        title:
                            'Update Date - ${DateFormat("dd-MM-yyyy").format(homeController.userData.value.profileModifyDate ?? DateTime.now())}',
                        value: "",
                        isTrue: true,
                        titleStyle: titleTextStyle,
                        valueStyle: valueTextStyle,
                      ),
                      myDividerWidget(),
                    ],
                  ),
                  SizedBox(
                    height: Get.width / 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(Editprofilepage());
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
                              'Edit Profile',
                              style: TextStyle(
                                color: ConstHelper.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Get.width * 0.045,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.01,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            deleteDialog(
                              context,
                              Get.height,
                              Get.width,
                              () async {
                                await ApiHelper.apiHelper
                                    .postDeleteProfileApi()
                                    .then((value) async {
                                  try {
                                    if (value.isNotEmpty) {
                                      if (value['code'] == 200) {
                                        final responseData = value;
                                        debugPrint(responseData.toString());
                                        if (responseData['code'] == 200) {
                                          SharedPrefHelper.sharedPreferences
                                              .setBool(
                                            'login',
                                            false,
                                          );
                                          ConstHelper.successDialog(
                                            text: jsonDecode(value)['msg'] ??
                                                ConstHelper
                                                    .dataDeletedSuccessfullyMsg,
                                            seconds: 2,
                                          );
                                          Future.delayed(
                                            const Duration(seconds: 1),
                                            () {
                                              return Get.offAll(
                                                const LoginPage(),
                                              );
                                            },
                                          );
                                        } else {
                                          ConstHelper.errorDialog(
                                            text: value['msg'] ??
                                                ConstHelper
                                                    .somethingWantWrongMsg,
                                            seconds: 3,
                                          );
                                        }
                                      } else {
                                        ConstHelper.errorDialog(
                                          text: value['msg'] ??
                                              ConstHelper.somethingWantWrongMsg,
                                          seconds: 3,
                                        );
                                      }
                                    }
                                  } on TimeoutException catch (e) {
                                    ConstHelper.errorDialog(
                                      text: e.message.toString(),
                                      seconds: 3,
                                    );
                                  }
                                });
                              },
                            );
                          },
                          child: Text(
                            "Delete Account".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Get.height / 50,
                              decoration: TextDecoration.underline,
                              color: ConstHelper.orangeColor,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.width / 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  deleteDialog(
      context, double height, double width, void Function()? onPressed) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: ConstHelper.whiteColor,
        surfaceTintColor: ConstHelper.whiteColor,
        insetPadding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: height * 0.02),
                Text(
                  "Delete Profile?".toUpperCase(),
                  style: TextStyle(
                    fontSize: Get.width * 0.045,
                    fontWeight: FontWeight.w600,
                    color: ConstHelper.orangeColor,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  "Are you sure you want to delete your account? This will permanently erase your account.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.w400,
                    color: ConstHelper.blackColor,
                    letterSpacing: 1,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: height * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstHelper.orangeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Get.height / 60,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.04,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: ConstHelper.orangeColor,
                            fontSize: Get.height / 60,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle headingTextStyle = TextStyle(
      color: ConstHelper.orangeColor,
      fontWeight: FontWeight.w600,
      fontSize: Get.width * 0.045,
      letterSpacing: 1);

  TextStyle titleTextStyle = TextStyle(
    color: ConstHelper.blackColor.withOpacity(0.8),
    fontSize: Get.width * 0.04,
    fontWeight: FontWeight.w500,
  );

  TextStyle valueTextStyle = TextStyle(
    color: ConstHelper.blackColor,
    fontSize: Get.width * 0.04,
    fontWeight: FontWeight.w500,
  );

  Widget threeDotWidget() => Padding(
        padding: EdgeInsets.only(
          right: Get.width / 30,
          left: Get.width / 90,
        ),
        child: Text(
          ':',
          style: titleTextStyle,
        ),
      );

  Widget myDividerWidget() => Column(
        children: [
          SizedBox(
            height: Get.width / 20,
          ),
          Divider(
            color: ConstHelper.cementColor,
          ),
          SizedBox(
            height: Get.width / 20,
          ),
        ],
      );
}

String normalizeTime(String input) {
  try {
    // Split input by space to separate time and period (AM/PM)
    final parts = input.trim().split(' ');
    if (parts.length != 2) throw FormatException('Invalid format');

    final timeParts = parts[0].split(':');
    if (timeParts.length != 2) throw FormatException('Invalid time');

    final hour = timeParts[0].padLeft(2, '0');
    final minute = timeParts[1].padLeft(2, '0');
    final period = parts[1].toUpperCase();

    final normalized = '$hour:$minute $period';
    final parsed = DateFormat('hh:mm a').parse(normalized);
    return DateFormat('hh:mm a').format(parsed);
  } catch (e) {
    return 'Invalid Time';
  }
}
