import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/home_controller.dart';
import '../../models/members_data_model.dart';
import '../../models/sponsors_model.dart';
import '../../utils/api_helper.dart';
import '../../utils/const_helper.dart';
import '../../utils/shared_pref_helper.dart';
import '../about_us_screen/about_us_page.dart';
import '../feedback_screen/feedback_page.dart';
import '../login_screen/login_page.dart';
import '../my_profile_screen/my_profile_page.dart';
import '../my_shortlisted_screen/my_shortlisted_page.dart';
import '../settings_screen/settings_page.dart';
import 'members_data_show_page.dart';

RxBool maleFemale = true.obs;
RxInt totalMaleMembers = 0.obs;
RxInt totalFemaleMembers = 0.obs;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = Get.put(HomeController());
  RxBool startLoad = true.obs;
  RxBool searchClick = false.obs;
  RxBool searchStart = false.obs;
  FocusNode searchFocusNode = FocusNode();
  TextEditingController txtSearch = TextEditingController();
  RxList<MembersDataModel> searchedMembersDataListGenderWise =
      <MembersDataModel>[].obs;
  List<String> educationSelected = [];

  Future<void> fetchAllData() async {
    await getUserData();
    await getAd();
    await getAllMembersData();
  }

  Future<void> getAd() async {
    await homeController.getSponData();
    if(!mounted) return;
    ImageDialog.show(context, homeController.sponItemList);
  }

  Future<void> getUserData() async {
    await homeController.getUserData();
  }

  Future<void> getAllMembersData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    homeController.selectedGotra.value = prefs.getString("gotra") ?? "";
    homeController.selectedGotra.value = prefs.getString("gotra") ?? "";
    homeController.yearlyIncomeStart.value =
        double.parse(prefs.getString("yearlyIncomeStart") ?? "1");
    homeController.yearlyIncomeEnd.value =
        double.parse(prefs.getString("yearlyIncomeEnd") ?? "300");
    homeController.selectedAgeStart.value =
        double.parse(prefs.getString("selectedAgeStart") ?? "18");
    homeController.selectedAgeEnd.value =
        double.parse(prefs.getString("selectedAgeEnd") ?? "56");
    homeController.selectedMaxHeightValue.value =
        (double.parse(prefs.getString("selectedMaxHeightValue") ?? "7") * 12)
            .toStringAsFixed(0);
    homeController.selectedMinHeightValue.value =
        (double.parse(prefs.getString("selectedMinHeightValue") ?? "4") * 12)
            .toStringAsFixed(0);
    homeController.marriedBeforeStatus.value =
        prefs.getString("marriedBeforeStatus") ?? "All";
    homeController.maglikStatus.value =
        prefs.getString("maglikStatus") ?? "All";
    homeController.selectAll.value = prefs.getString("selectAll") == "true"
        ? true
        : prefs.getString("selectAll") == "false"
            ? false
            : true;
    educationSelected = prefs.getStringList("eductionSelected") ?? [];
    debugPrint('educationSelected: ${educationSelected.length}');
    homeController.educationDataList.value =
        await ApiHelper.apiHelper.getEducationDataList();
    debugPrint('educationDataList: ${homeController.educationDataList.length}');
    if (educationSelected.isEmpty) {
      for (int i = 0; i < homeController.educationDataList.length; i++) {
        homeController.educationDataList[i]['selected'] = true;
        debugPrint('educationDataList: ${homeController.educationDataList[i]['selected']}');
      }
    } else if (homeController.educationDataList.length ==
        educationSelected.length) {
      for (int i = 0; i < homeController.educationDataList.length; i++) {
        homeController.educationDataList[i]['selected'] =
            educationSelected[i].toLowerCase() == "true";
        debugPrint('educationDataList: ${homeController.educationDataList[i]['selected']}');
      }
    } else {
      debugPrint(
          "Error: Mismatched list lengths. Ensure both lists have the same size.");
    }
    startLoad.value = true;
    txtSearch.clear();
    searchFocusNode.unfocus();
    searchClick.value = false;
    searchStart.value = false;
    try {
      List<String> educationCategory = [];
      for (int i = 0; i < homeController.educationDataList.length; i++) {
        debugPrint('educationDataList: ${homeController.educationDataList[i]['selected']}');
        if (homeController.educationDataList[i]['selected'] == true) {
          educationCategory.add(
              homeController.educationDataList[i]['education_name'] ?? '-');
        }
      }
      List<MembersDataModel> allMembersDataList = await ApiHelper.apiHelper
          .getAllMembersDataList(
              heightFrom: homeController.selectedMinHeightValue.value
                  .toString()
                  .split(".")[0]
                  .toString(),
              heightTo: homeController.selectedMaxHeightValue.value
                  .toString()
                  .split(".")[0]
                  .toString(),
              educationCategory: educationCategory,
              haveMarriedBefore:
                  homeController.marriedBeforeStatus.value.toLowerCase(),
              ageFrom: homeController.selectedAgeStart.value.toStringAsFixed(0),
              ageTo: homeController.selectedAgeEnd.value.toStringAsFixed(0),
              excludeGotra: homeController.selectedGotra.value.trim().isEmpty ||
                      homeController.selectedGotra.value == "-- Select Gotra --"
                  ? "No Exclude"
                  : homeController.selectedGotra.value,
              incomeFrom:
                  homeController.yearlyIncomeStart.value.toStringAsFixed(0),
              incomeTo: homeController.yearlyIncomeEnd.value.toStringAsFixed(0),
              isManglik: homeController.maglikStatus.value);
      debugPrint('allMembersDataList: ${allMembersDataList.length}');
      debugPrint('profileType: ${homeController.userData.value.profileType?.toString()}');
      if (homeController.userData.value.profileType?.toString() == "1") {
        homeController.allMembersDataListGenderWise.value = allMembersDataList
            .where(
              (element) =>
                  element.profileGender.toString().trim().toLowerCase() ==
                  (homeController.userData.value.profileGender
                              ?.toString()
                              .trim()
                              .toLowerCase() ==
                          "Female".toLowerCase()
                      ? 'Male'.trim().toLowerCase()
                      : 'Female'.trim().toLowerCase()),
            )
            .toList();
        debugPrint('allMembersDataListGenderWise: ${homeController.allMembersDataListGenderWise.length}');
      } else {
        homeController.allMembersDataListGenderWise.value = allMembersDataList
            .where(
              (element) =>
                  element.profileGender.toString().trim().toLowerCase() ==
                  (maleFemale.value
                      ? 'Male'.trim().toLowerCase()
                      : 'Female'.trim().toLowerCase()),
            )
            .toList();
        totalMaleMembers.value = allMembersDataList
            .where(
              (element) =>
                  element.profileGender.toString().trim().toLowerCase() ==
                  'Male'.trim().toLowerCase(),
            )
            .toList()
            .length;
        totalFemaleMembers.value = allMembersDataList
            .where(
              (element) =>
                  element.profileGender.toString().trim().toLowerCase() ==
                  'Female'.trim().toLowerCase(),
            )
            .toList()
            .length;
      }
      searchedMembersDataListGenderWise.value =
          homeController.allMembersDataListGenderWise;
      startLoad.value = false;
    } catch (error) {
      homeController.allMembersDataListGenderWise.value = [];
      searchedMembersDataListGenderWise.value = [];
      startLoad.value = false;
    }
    startLoad.value = false;
  }

  void filterData(String searchValue) {
    // Backup the original data if it's not already backed up
    if (searchedMembersDataListGenderWise.isEmpty) {
      searchedMembersDataListGenderWise
          .assignAll(homeController.allMembersDataListGenderWise);
    }

    if (searchValue.isEmpty) {
      // Restore the original data when the search query is empty
      homeController.allMembersDataListGenderWise.value =
          List<MembersDataModel>.from(searchedMembersDataListGenderWise);
    } else {
      homeController.allMembersDataListGenderWise.value =
          searchedMembersDataListGenderWise.where((p0) {
        String dob =
            p0.profileDateOfBirth == null || p0.profileDateOfBirth!.year <= 0
                ? ''
                : DateFormat('dd | MMM | yyyy').format(p0.profileDateOfBirth!);
        return p0.id
                .toString()
                .trim()
                .toLowerCase()
                .contains(searchValue.trim().toLowerCase()) ||
            p0.name
                .toString()
                .trim()
                .toLowerCase()
                .contains(searchValue.trim().toLowerCase()) ||
            p0.profileFatherFullName
                .toString()
                .trim()
                .toLowerCase()
                .contains(searchValue.trim().toLowerCase()) ||
            dob
                .trim()
                .toLowerCase()
                .contains(searchValue.trim().toLowerCase()) ||
            p0.profileEducationQualification
                .toString()
                .trim()
                .toLowerCase()
                .contains(searchValue.trim().toLowerCase()) ||
            p0.profilePresentCity
                .toString()
                .trim()
                .toLowerCase()
                .contains(searchValue.trim().toLowerCase()) ||
            p0.profileCurrentResidAddress
                .toString()
                .trim()
                .toLowerCase()
                .contains(searchValue.trim().toLowerCase());
      }).toList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ImageDialog.show(context, homeController.sponItemList);
    EasyLoading.dismiss();
    debugPrint("token");
    debugPrint('userDataWithToken: ${homeController.userDataWithToken.value.data?.token ?? ""}');
    return SafeArea(
      child: AdvancedDrawer(
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          color: ConstHelper.blackColor,
        ),
        controller: homeController.advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: Padding(
          padding: EdgeInsets.fromLTRB(
            Get.width / 30,
            Get.width / 15,
            Get.width / 30,
            Get.width / 30,
          ),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/image/drawerWhiteSVG.svg',
                    height: Get.width / 18,
                    width: Get.width / 18,
                  ),
                  SizedBox(
                    height: Get.width / 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: Get.width / 4,
                        width: Get.width / 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              ConstHelper.orangeColor,
                              ConstHelper.orangeColor.withAlpha(230),
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(Get.width / 70),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: homeController.userData.value
                                            .profileFullFacePhotoFileName ==
                                        null ||
                                    homeController.userData.value
                                        .profileFullFacePhotoFileName!
                                        .trim()
                                        .isEmpty
                                ? ConstHelper.profileImagePath
                                : '${ConstHelper.userImagesPath}${homeController.userData.value.profileFullFacePhotoFileName!}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ConstHelper.whiteColor,
                              ),
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: Get.width / 20,
                                width: Get.width / 20,
                                child: CircularProgressIndicator(
                                  color: ConstHelper.orangeColor,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                      SizedBox(
                        width: Get.width / 30,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User ID : ',
                                  style: TextStyle(
                                    color: ConstHelper.whiteColor,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    homeController.userData.value.id == null ||
                                            homeController.userData.value.id! <=
                                                0
                                        ? ConstHelper.naMsg
                                        : homeController.userData.value.id
                                            .toString(),
                                    style: TextStyle(
                                      color: ConstHelper.whiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(height: Get.width/90,),
                            Text(
                              homeController.userData.value.name == null ||
                                      homeController.userData.value.name!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.nameNotAvailableMsg
                                  : homeController.userData.value.name!.trim(),
                              style: TextStyle(
                                color: ConstHelper.whiteColor,
                                fontWeight: FontWeight.w600,
                                fontSize: Get.width * 0.045,
                              ),
                            ),
                            // Text(
                            //   homeController.userData.value.email == null ||
                            //       homeController.userData.value.email!.trim().isEmpty
                            //       ? ConstHelper.emailNotAvailableMsg
                            //       : homeController.userData.value.email!.trim(),
                            //   style: TextStyle(
                            //     color: ConstHelper.whiteColor,
                            //   ),
                            // ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact : ',
                                  style: TextStyle(
                                    color: ConstHelper.whiteColor,
                                    fontSize: Get.width * 0.035,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    homeController.userData.value
                                                    .profileMainContactNum ==
                                                null ||
                                            homeController.userData.value
                                                .profileMainContactNum!
                                                .trim()
                                                .isEmpty
                                        ? ConstHelper.naMsg
                                        : homeController.userData.value
                                            .profileMainContactNum!
                                            .trim(),
                                    style: TextStyle(
                                      color: ConstHelper.whiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Get.width * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.width / 60,
                  ),
                  Divider(
                    color: ConstHelper.greyColor,
                  ),
                  SizedBox(
                    height: Get.width / 20,
                  ),
                  InkWell(
                    onTap: () {
                      //ImageDialog.show(context, homeController.sponItemList);
                      homeController.advancedDrawerController.hideDrawer();
                    },
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/image/homeSVG.svg',
                          height: Get.width / 20,
                          width: Get.width / 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            ConstHelper.whiteColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 30,
                        ),
                        Flexible(
                          child: Text(
                            'Home',
                            style: TextStyle(
                              color: ConstHelper.whiteColor,
                              fontSize: Get.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.width / 20,
                  ),
                  InkWell(
                    onTap: () async {
                      homeController.userData.value =
                          (await ApiHelper.apiHelper.fetchProfile())!;
                      Get.to(
                        const MyProfilePage(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/image/personSVG.svg',
                          height: Get.width / 20,
                          width: Get.width / 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            ConstHelper.whiteColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 30,
                        ),
                        Flexible(
                          child: Text(
                            'My Profile',
                            style: TextStyle(
                              color: ConstHelper.whiteColor,
                              fontSize: Get.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.width / 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(
                        const MyShortlistedPage(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/image/shortlistedSVG.svg',
                          height: Get.width / 20,
                          width: Get.width / 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            ConstHelper.whiteColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 30,
                        ),
                        Flexible(
                          child: Text(
                            'My Shortlisted',
                            style: TextStyle(
                              color: ConstHelper.whiteColor,
                              fontSize: Get.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: Get.width/20,),
                  // Row(
                  //   // crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     SvgPicture.asset('assets/image/eventSVG.svg',height: Get.width/20,width: Get.width/20,fit: BoxFit.contain,color: ConstHelper.whiteColor,),
                  //     SizedBox(width: Get.width/30,),
                  //     Flexible(
                  //       child: Text(
                  //         'Events',
                  //         style: TextStyle(
                  //           color: ConstHelper.whiteColor,
                  //           fontSize: 16,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    height: Get.width / 20,
                  ),
                  InkWell(
                    onTap: () async {
                      EasyLoading.show(
                        status: ConstHelper.pleaseWaitMsg,
                      );
                      await Future.delayed(
                        const Duration(
                          milliseconds: 200,
                        ),
                      );
                      if (!(await ConstHelper.checkInternet())) {
                        EasyLoading.dismiss();
                        ConstHelper.errorDialog(
                          text: ConstHelper.internetMsg,
                          seconds: 10,
                        );
                      } else {
                        try {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          homeController.selectedGotra.value =
                              prefs.getString("gotra") ?? "";
                          homeController.yearlyIncomeStart.value = double.parse(
                              prefs.getString("yearlyIncomeStart") ?? "1.0");
                          homeController.yearlyIncomeEnd.value = double.parse(
                              prefs.getString("yearlyIncomeEnd") ?? "300.0");
                          homeController.selectedAgeStart.value = double.parse(
                              prefs.getString("selectedAgeStart") ?? "18");
                          homeController.selectedAgeEnd.value = double.parse(
                              prefs.getString("selectedAgeEnd") ?? "50");
                          homeController.selectedMaxHeightValue.value =
                              prefs.getString("selectedMaxHeightValue") ??
                                  "7.0";
                          homeController.selectedMinHeightValue.value =
                              prefs.getString("selectedMinHeightValue") ??
                                  "4.0";
                          homeController.marriedBeforeStatus.value =
                              prefs.getString("marriedBeforeStatus") ?? "All";
                          homeController.maglikStatus.value =
                              prefs.getString("maglikStatus") ?? "All";
                          homeController.selectAll.value =
                              prefs.getString("selectAll") == "true"
                                  ? true
                                  : prefs.getString("selectAll") == "false"
                                      ? false
                                      : true;
                          educationSelected =
                              prefs.getStringList("eductionSelected") ??
                                  [];
                          homeController.educationDataList.value =
                              await ApiHelper.apiHelper.getEducationDataList();
                          debugPrint('educationDataList: ${homeController.educationDataList.length}');
                          if (educationSelected.isEmpty) {
                            for (int i = 0;
                                i < homeController.educationDataList.length;
                                i++) {
                              homeController.educationDataList[i]['selected'] =
                                  true;
                              debugPrint('educationDataList: ${homeController.educationDataList[i]['selected']}');
                            }
                          } else if (homeController.educationDataList.length ==
                              educationSelected.length) {
                            for (int i = 0;
                                i < homeController.educationDataList.length;
                                i++) {
                              homeController.educationDataList[i]['selected'] =
                                  educationSelected[i].toLowerCase() == "true";
                              debugPrint('educationDataList: ${homeController.educationDataList[i]['selected']}');
                            }
                          } else {
                            debugPrint(
                                "Error: Mismatched list lengths. Ensure both lists have the same size.");
                          }
                          homeController.gotraDataList.clear();
                          homeController.gotraDataList
                              .add("-- Select Gotra --");
                          await ApiHelper.apiHelper.getGotraDataList().then(
                            (value) {
                              homeController.gotraDataList.addAll(value);
                            },
                          );
                          homeController.selectedGotra.value =
                              "-- Select Gotra --";
                          debugPrint('gotraDataList: ${homeController.gotraDataList}');
                          Get.to(
                            const SettingsPage(),
                            transition: Transition.rightToLeft,
                          );
                          EasyLoading.dismiss();
                        } catch (error) {
                          debugPrint('Error: $error');
                          EasyLoading.dismiss();
                          ConstHelper.errorDialog(
                            text: ConstHelper.somethingErrorMsg,
                            seconds: 10,
                          );
                        }
                      }
                    },
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/image/settingsSVG.svg',
                          height: Get.width / 20,
                          width: Get.width / 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            ConstHelper.whiteColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 30,
                        ),
                        Flexible(
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              color: ConstHelper.whiteColor,
                              fontSize: Get.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.width / 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(
                        const FeedbackPage(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/image/feedbackSVG.svg',
                          height: Get.width / 20,
                          width: Get.width / 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            ConstHelper.whiteColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 30,
                        ),
                        Flexible(
                          child: Text(
                            'Feedback',
                            style: TextStyle(
                              color: ConstHelper.whiteColor,
                              fontSize: Get.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.width / 20,
                  ),
                  InkWell(
                    onTap: () async {
                      await homeController.getSamaj();
                      Get.to(
                        const AboutUsPage(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/image/aboutUsSVG.svg',
                          height: Get.width / 20,
                          width: Get.width / 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            ConstHelper.whiteColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 30,
                        ),
                        Flexible(
                          child: Text(
                            'About Us',
                            style: TextStyle(
                              color: ConstHelper.whiteColor,
                              fontSize: Get.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.width / 20,
                  ),
                  InkWell(
                    onTap: () {
                      ConstHelper.constHelper.areYouSureWantAlertDialog(
                        title: 'Log out now?',
                        description: 'Are you sure you want to log out?',
                        onPressed: () {
                          Get.back();
                          SharedPrefHelper.sharedPreferences.setBool(
                            'login',
                            false,
                          );
                          Get.off(
                            const LoginPage(),
                          );
                        },
                      );
                    },
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/image/logoutSVG.svg',
                          height: Get.width / 20,
                          width: Get.width / 20,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(
                            ConstHelper.whiteColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(
                          width: Get.width / 30,
                        ),
                        Flexible(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: ConstHelper.whiteColor,
                              fontSize: Get.width * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.width / 20,
                  ),
                ],
              ),
            ],
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (searchClick.value) {
                  txtSearch.clear();
                  searchFocusNode.unfocus();
                  searchClick.value = false;
                  searchStart.value = false;
                } else {
                  homeController.advancedDrawerController.showDrawer();
                }
              },
              icon: Obx(() => searchClick.value
                  ? Icon(
                      Icons.arrow_back_ios_rounded,
                      size: Get.width / 15,
                      color: ConstHelper.orangeColor,
                    )
                  : SvgPicture.asset(
                      'assets/image/drawerIconSVG.svg',
                      height: Get.width / 18,
                      width: Get.width / 18,
                    )),
            ),
            title: Obx(
              () => searchClick.value
                  ? TextField(
                      focusNode: searchFocusNode,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ConstHelper.greyColor.withAlpha(77),
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ConstHelper.greyColor.withAlpha(77),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ConstHelper.greyColor.withAlpha(77),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Get.width / 30,
                        ),
                        hintText: 'Search....',
                        hintStyle: TextStyle(
                          color: ConstHelper.greyColor.withAlpha(179),
                        ),
                      ),
                      onChanged: (value) {
                        filterData(value);
                        searchStart.value = value.trim().isNotEmpty;
                        /* if (value.trim().isNotEmpty) {
                          searchedMembersDataListGenderWise.value =
                              homeController.allMembersDataListGenderWise.where(
                            (p0) {
                              String dob = p0.profileDateOfBirth == null ||
                                      p0.profileDateOfBirth!.year <= 0
                                  ? ''
                                  : DateFormat('dd | MMM | yyyy')
                                      .format(p0.profileDateOfBirth!);
                              return p0.id
                                      .toString()
                                      .trim()
                                      .toLowerCase()
                                      .contains(value.trim().toLowerCase()) ||
                                  p0.name
                                      .toString()
                                      .trim()
                                      .toLowerCase()
                                      .contains(value.trim().toLowerCase()) ||
                                  p0.profileFatherFullName
                                      .toString()
                                      .trim()
                                      .toLowerCase()
                                      .contains(value.trim().toLowerCase()) ||
                                  dob
                                      .trim()
                                      .toLowerCase()
                                      .contains(value.trim().toLowerCase()) ||
                                  p0.profileEducationQualification
                                      .toString()
                                      .trim()
                                      .toLowerCase()
                                      .contains(value.trim().toLowerCase()) ||
                                  p0.profilePresentCity
                                      .toString()
                                      .trim()
                                      .toLowerCase()
                                      .contains(value.trim().toLowerCase()) ||
                                  p0.profileCurrentResidAddress
                                      .toString()
                                      .trim()
                                      .toLowerCase()
                                      .contains(value.trim().toLowerCase());
                            },
                          ).toList();
                        }*/
                      },
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ASVT".tr,
                          style: TextStyle(
                            fontSize: Get.width * 0.06,
                            color: ConstHelper.orangeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " Bangalore".tr,
                          style: TextStyle(
                            fontSize: Get.width * 0.06,
                            color: ConstHelper.blackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
            centerTitle: true,
            backgroundColor: ConstHelper.whiteColor,
            surfaceTintColor: ConstHelper.whiteColor,
            elevation: 10,
            shadowColor: ConstHelper.greyColor.withAlpha(25),
            actions: [
              IconButton(
                onPressed: () {
                  if (searchClick.value) {
                    txtSearch.clear();
                    searchFocusNode.unfocus();
                    searchStart.value = false;
                  } else {
                    searchFocusNode.requestFocus();
                  }

                  searchClick.value = !searchClick.value;
                },
                icon: Obx(() => searchClick.value
                    ? Icon(
                        Icons.close_rounded,
                        size: Get.width / 15,
                        color: ConstHelper.orangeColor,
                      )
                    : SvgPicture.asset(
                        'assets/image/searchIconSVG.svg',
                        height: Get.width / 18,
                        width: Get.width / 18,
                      )),
              ),
            ],
            // elevation: 3,
            // shadowColor: Colors.grey.shade50.withAlpha(77),
          ),
          backgroundColor: ConstHelper.whiteColor,
          body: RefreshIndicator(
            onRefresh: () async {
              await getAllMembersData();
            },
            color: ConstHelper.orangeColor,
            backgroundColor: ConstHelper.whiteColor,
            child: Obx(
              () => startLoad.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ConstHelper.orangeColor,
                      ),
                    )
                  : /* searchStart.value
                      ? searchedMembersDataListGenderWise.isEmpty
                          ? ListView(
                              children: [
                                SizedBox(
                                  height: Get.height / 2.5,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.04),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Oops! No data found. Try again later or contact admin.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ConstHelper.orangeDarkColor,
                                            fontSize: Get.width * 0.05,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount:
                                  searchedMembersDataListGenderWise.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    EasyLoading.show(
                                      status: ConstHelper.pleaseWaitMsg,
                                    );
                                    await Future.delayed(
                                      const Duration(
                                        milliseconds: 200,
                                      ),
                                    );
                                    if (!(await ConstHelper.checkInternet())) {
                                      EasyLoading.dismiss();
                                      ConstHelper.errorDialog(
                                        text: ConstHelper.internetMsg,
                                        seconds: 10,
                                      );
                                    } else {
                                      homeController.selectedMembersData.value =
                                          searchedMembersDataListGenderWise[
                                              index];
                                      List<MembersDataModel>
                                          allShortlistedDataList =
                                          await ApiHelper.apiHelper
                                              .getAllShortlistedDataLisfluttert();
                                      homeController.profileShorted.value =
                                          allShortlistedDataList
                                              .where(
                                                (element) =>
                                                    element.id ==
                                                    homeController
                                                        .selectedMembersData
                                                        .value
                                                        .id,
                                              )
                                              .toList()
                                              .isNotEmpty;
                                      Get.to(
                                        const MembersDataShowPage(),
                                        transition: Transition.fadeIn,
                                      )?.then((value) async =>
                                          await getAllMembersData());
                                      EasyLoading.dismiss();
                                    }

                                    EasyLoading.dismiss();
                                  },
                                  child: Container(
                                    width: Get.width,
                                    margin: EdgeInsets.fromLTRB(
                                      Get.width / 30,
                                      index == 0
                                          ? Get.width / 15
                                          : Get.width / 23,
                                      Get.width / 30,
                                      searchedMembersDataListGenderWise
                                                  .length !=
                                              (index + 1)
                                          ? 0
                                          : Get.width / 30,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ConstHelper.whiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ConstHelper.greyColor
                                              .withAlpha(25),
                                          offset: const Offset(0, 4),
                                          blurRadius: 2,
                                        ),
                                        BoxShadow(
                                          color: ConstHelper.greyColor
                                              .withOpacity(0.05),
                                          offset: const Offset(0, -1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                      border: Border.all(
                                        width: 0.3,
                                        color: ConstHelper.greyColor
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: Get.width / 30,
                                          ),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 2,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: ConstHelper
                                                              .orangeColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: Get.width / 30,
                                                      ),
                                                      IntrinsicHeight(
                                                        child: Container(
                                                            width:
                                                                Get.width / 5,
                                                            height:
                                                                Get.width / 5,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: ConstHelper
                                                                  .whiteColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7.5),
                                                              border:
                                                                  Border.all(
                                                                color: ConstHelper
                                                                    .greyColor
                                                                    .withOpacity(
                                                                        0.3),
                                                              ),
                                                            ),
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: searchedMembersDataListGenderWise[index].profileFullFacePhotoFileName ==
                                                                                null ||
                                                                            searchedMembersDataListGenderWise[index]
                                                                                .profileFullFacePhotoFileName!
                                                                                .trim()
                                                                                .isEmpty
                                                                        ? ConstHelper
                                                                            .profileImagePath
                                                                        : '${ConstHelper.userImagesPath}${searchedMembersDataListGenderWise[index].profileFullFacePhotoFileName!}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                        color: ConstHelper
                                                                            .whiteColor,
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            Get.width /
                                                                                20,
                                                                        width: Get.width /
                                                                            20,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              ConstHelper.orangeColor,
                                                                          strokeWidth:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                        color: ConstHelper
                                                                            .whiteColor,
                                                                      ),
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/image/imageNotFound.png',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                */ /* Image.asset(
                                                              "assets/image/re-merriage.png"),*/ /*
                                                              ],
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        width: Get.width / 30,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${searchedMembersDataListGenderWise[index].id == null || searchedMembersDataListGenderWise[index].id == 0 ? 'Id not available' : searchedMembersDataListGenderWise[index].id!} - ${searchedMembersDataListGenderWise[index].name == null || searchedMembersDataListGenderWise[index].name!.trim().isEmpty ? ConstHelper.nameNotAvailableMsg : searchedMembersDataListGenderWise[index].name}',
                                                              style: TextStyle(
                                                                color: ConstHelper
                                                                    .orangeDarkColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    Get.width *
                                                                        0.04,
                                                              ),
                                                            ),
                                                            // Text(
                                                            //   searchedMembersDataListGenderWise[
                                                            //                       index]
                                                            //                   .profileFatherFullName ==
                                                            //               null ||
                                                            //           searchedMembersDataListGenderWise[
                                                            //                   index]
                                                            //               .profileFatherFullName!
                                                            //               .trim()
                                                            //               .isEmpty
                                                            //       ? ConstHelper
                                                            //           .fatherNameNotAvailableMsg
                                                            //       : searchedMembersDataListGenderWise[
                                                            //               index]
                                                            //           .profileFatherFullName!,
                                                            //   style: TextStyle(
                                                            //     color: ConstHelper
                                                            //         .greyColor,
                                                            //     fontWeight:
                                                            //         FontWeight.w500,
                                                            //     fontSize: 12,
                                                            //   ),
                                                            // ),
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'DOB : ',
                                                                      style:
                                                                          TextStyle(
                                                                        color: ConstHelper
                                                                            .blackColor
                                                                            .withOpacity(0.8),
                                                                        fontSize:
                                                                            Get.width *
                                                                                0.035,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      searchedMembersDataListGenderWise[index].profileDateOfBirth == null ||
                                                                              searchedMembersDataListGenderWise[index].profileDateOfBirth!.year <=
                                                                                  0
                                                                          ? '-'
                                                                          : DateFormat('dd | MMM | yyyy')
                                                                              .format(searchedMembersDataListGenderWise[index].profileDateOfBirth!),
                                                                      style:
                                                                          TextStyle(
                                                                        color: ConstHelper
                                                                            .blackColor,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            Get.width *
                                                                                0.035,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      Get.width /
                                                                          30,
                                                                ),
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        'EDU : ',
                                                                        style:
                                                                            TextStyle(
                                                                          color: ConstHelper
                                                                              .blackColor
                                                                              .withOpacity(0.8),
                                                                          fontSize:
                                                                              Get.width * 0.035,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          searchedMembersDataListGenderWise[index].profileEducationQualification == null || searchedMembersDataListGenderWise[index].profileEducationQualification!.trim().isEmpty
                                                                              ? '-'
                                                                              : searchedMembersDataListGenderWise[index].profileEducationQualification!,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                ConstHelper.blackColor,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontSize:
                                                                                Get.width * 0.035,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),

                                                            Expanded(
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Profession : ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: ConstHelper
                                                                          .blackColor
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontSize:
                                                                          Get.width *
                                                                              0.035,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      searchedMembersDataListGenderWise[index].profileProfession == null ||
                                                                              searchedMembersDataListGenderWise[index].profileProfession!.trim().isEmpty
                                                                          ? '-'
                                                                          : searchedMembersDataListGenderWise[index].profileProfession!,
                                                                      style:
                                                                          TextStyle(
                                                                        color: ConstHelper
                                                                            .blackColor,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            Get.width *
                                                                                0.035,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                */ /*SvgPicture.asset(
                                            'assets/image/menuVerticalIconSVG.svg',
                                            height: Get.width / 25,
                                            width: Get.width / 25,
                                          ),
                                          SizedBox(
                                            width: Get.width / 90,
                                          ),*/ /*
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (searchedMembersDataListGenderWise[
                                                        index]
                                                    .profileHaveMarriedBefore !=
                                                null &&
                                            searchedMembersDataListGenderWise[
                                                        index]
                                                    .profileHaveMarriedBefore
                                                    .toString()
                                                    .toLowerCase() !=
                                                "no")
                                          Image.asset(
                                            "assets/image/re-marriage.png",
                                            height: Get.height * 0.06,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                      :*/
                  homeController.allMembersDataListGenderWise.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: Get.height / 2.5,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.04),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Oops! No data found. Try again later or contact admin.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ConstHelper.orangeDarkColor,
                                        fontSize: Get.width * 0.05,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: homeController
                              .allMembersDataListGenderWise.length,
                          itemBuilder: (context, index) {
                            debugPrint('allMembersDataListGenderWise: ${homeController.allMembersDataListGenderWise[index].profileHaveMarriedBefore}');
                            debugPrint('allMembersDataListGenderWise: ${homeController
                                .allMembersDataListGenderWise[index]
                                .profileHaveMarriedBefore
                                .toString()
                                .toLowerCase() !=
                                "no"}');
                            return GestureDetector(
                              onTap: () async {
                                EasyLoading.show(
                                  status: ConstHelper.pleaseWaitMsg,
                                );
                                await Future.delayed(
                                  const Duration(
                                    milliseconds: 200,
                                  ),
                                );
                                if (!(await ConstHelper.checkInternet())) {
                                  EasyLoading.dismiss();
                                  ConstHelper.errorDialog(
                                    text: ConstHelper.internetMsg,
                                    seconds: 10,
                                  );
                                } else {
                                  homeController.selectedMembersData.value =
                                      homeController
                                          .allMembersDataListGenderWise[index];
                                  List<MembersDataModel>
                                      allShortlistedDataList = await ApiHelper
                                          .apiHelper
                                          .getAllShortlistedDataList();
                                  homeController.profileShorted.value =
                                      allShortlistedDataList
                                          .where(
                                            (element) =>
                                                element.id ==
                                                homeController
                                                    .selectedMembersData
                                                    .value
                                                    .id,
                                          )
                                          .toList()
                                          .isNotEmpty;
                                  homeController.selectedMembersData.value =
                                      await ApiHelper.apiHelper
                                          .getSelectedembersDataList(
                                              id: homeController
                                                  .allMembersDataListGenderWise[
                                                      index]
                                                  .id
                                                  .toString());
                                  Get.to(
                                    const MembersDataShowPage(),
                                    transition: Transition.fadeIn,
                                  )?.then((value) async =>
                                      await getAllMembersData());
                                  EasyLoading.dismiss();
                                }

                                EasyLoading.dismiss();
                              },
                              child: Container(
                                width: Get.width,
                                margin: EdgeInsets.fromLTRB(
                                  Get.width / 30,
                                  index == 0 ? Get.width / 15 : Get.width / 23,
                                  Get.width / 30,
                                  homeController.allMembersDataListGenderWise
                                              .length !=
                                          (index + 1)
                                      ? 0
                                      : Get.width / 30,
                                ),
                                decoration: BoxDecoration(
                                  color: ConstHelper.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ConstHelper.greyColor
                                          .withAlpha(25),
                                      offset: const Offset(0, 4),
                                      blurRadius: 2,
                                    ),
                                    BoxShadow(
                                      color: ConstHelper.greyColor
                                          .withAlpha(13),
                                      offset: const Offset(0, -1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                  border: Border.all(
                                    width: 0.3,
                                    color:
                                        ConstHelper.greyColor.withAlpha(51),
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: Get.width / 30,
                                      ),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 2,
                                                    decoration: BoxDecoration(
                                                      color: ConstHelper
                                                          .orangeColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width / 30,
                                                  ),
                                                  Stack(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    children: [
                                                      IntrinsicHeight(
                                                        child: Container(
                                                          width: Get.width / 5,
                                                          height: Get.width / 5,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: ConstHelper
                                                                .whiteColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7.5),
                                                            border: Border.all(
                                                              color: ConstHelper
                                                                  .greyColor
                                                                  .withAlpha(
                                                                      77),
                                                            ),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: homeController
                                                                              .allMembersDataListGenderWise[
                                                                                  index]
                                                                              .profileFullFacePhotoFileName ==
                                                                          null ||
                                                                      homeController
                                                                          .allMembersDataListGenderWise[
                                                                              index]
                                                                          .profileFullFacePhotoFileName!
                                                                          .trim()
                                                                          .isEmpty
                                                                  ? ConstHelper
                                                                      .profileImagePath
                                                                  : '${ConstHelper.userImagesPath}${homeController.allMembersDataListGenderWise[index].profileFullFacePhotoFileName!}',
                                                              fit: BoxFit.cover,
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  color: ConstHelper
                                                                      .whiteColor,
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: SizedBox(
                                                                  height:
                                                                      Get.width /
                                                                          20,
                                                                  width:
                                                                      Get.width /
                                                                          20,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: ConstHelper
                                                                        .orangeColor,
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
                                                                ),
                                                              ),
                                                              errorWidget:
                                                                  (context, url,
                                                                          error) =>
                                                                      Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6),
                                                                  color: ConstHelper
                                                                      .whiteColor,
                                                                ),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/image/imageNotFound.png',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      /*if (homeController
                                                            .allMembersDataListGenderWise[
                                                                index]
                                                            .profileHaveMarriedBefore
                                                            .toString()
                                                            .toLowerCase() !=
                                                        "no")
                                                      Image.asset(
                                                        "assets/image/re-merriage.png",
                                                        height:
                                                            Get.height * 0.06,
                                                      ),*/
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: Get.width / 30,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${homeController.allMembersDataListGenderWise[index].id == null || homeController.allMembersDataListGenderWise[index].id == 0 ? 'Id not available' : homeController.allMembersDataListGenderWise[index].id!} - ${homeController.allMembersDataListGenderWise[index].name == null || homeController.allMembersDataListGenderWise[index].name!.trim().isEmpty ? ConstHelper.nameNotAvailableMsg : homeController.allMembersDataListGenderWise[index].name}',
                                                          style: TextStyle(
                                                            color: ConstHelper
                                                                .orangeDarkColor,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                Get.width *
                                                                    0.04,
                                                          ),
                                                        ),
                                                        // Text(
                                                        //   homeController
                                                        //                   .allMembersDataListGenderWise[
                                                        //                       index]
                                                        //                   .profileFatherFullName ==
                                                        //               null ||
                                                        //           homeController
                                                        //               .allMembersDataListGenderWise[
                                                        //                   index]
                                                        //               .profileFatherFullName!
                                                        //               .trim()
                                                        //               .isEmpty
                                                        //       ? ConstHelper
                                                        //           .fatherNameNotAvailableMsg
                                                        //       : homeController
                                                        //           .allMembersDataListGenderWise[
                                                        //               index]
                                                        //           .profileFatherFullName!,
                                                        //   style: TextStyle(
                                                        //     color: ConstHelper
                                                        //         .greyColor,
                                                        //     fontWeight:
                                                        //         FontWeight.w500,
                                                        //     fontSize: 12,
                                                        //   ),
                                                        // ),
                                                        Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'DOB : ',
                                                                  style:
                                                                      TextStyle(
                                                                    color: ConstHelper
                                                                        .blackColor
                                                                        .withAlpha(
                                                                            204),
                                                                    fontSize:
                                                                        Get.width *
                                                                            0.035,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  homeController.allMembersDataListGenderWise[index].profileDateOfBirth ==
                                                                              null ||
                                                                          homeController.allMembersDataListGenderWise[index].profileDateOfBirth!.year <=
                                                                              0
                                                                      ? '-'
                                                                      : DateFormat('dd | MMM | yyyy').format(homeController
                                                                          .allMembersDataListGenderWise[
                                                                              index]
                                                                          .profileDateOfBirth!),
                                                                  style:
                                                                      TextStyle(
                                                                    color: ConstHelper
                                                                        .blackColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        Get.width *
                                                                            0.035,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: Get.width /
                                                                  30,
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'EDU : ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: ConstHelper
                                                                          .blackColor
                                                                          .withAlpha(
                                                                              204),
                                                                      fontSize:
                                                                          Get.width *
                                                                              0.035,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      homeController.allMembersDataListGenderWise[index].profileEducationQualification == null || homeController.allMembersDataListGenderWise[index].profileEducationQualification!.trim().isEmpty
                                                                          ? '-'
                                                                          : homeController
                                                                              .allMembersDataListGenderWise[index]
                                                                              .profileEducationQualification!,
                                                                      style:
                                                                          TextStyle(
                                                                        color: ConstHelper
                                                                            .blackColor,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            Get.width *
                                                                                0.035,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Profession : ',
                                                              style: TextStyle(
                                                                color: ConstHelper
                                                                    .blackColor
                                                                    .withAlpha(
                                                                        204),
                                                                fontSize:
                                                                    Get.width *
                                                                        0.035,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                homeController.allMembersDataListGenderWise[index].profileProfession ==
                                                                            null ||
                                                                        homeController
                                                                            .allMembersDataListGenderWise[
                                                                                index]
                                                                            .profileProfession!
                                                                            .trim()
                                                                            .isEmpty
                                                                    ? '-'
                                                                    : homeController
                                                                        .allMembersDataListGenderWise[
                                                                            index]
                                                                        .profileProfession!,
                                                                style:
                                                                    TextStyle(
                                                                  color: ConstHelper
                                                                      .blackColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      Get.width *
                                                                          0.035,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            /*SvgPicture.asset(
                                            'assets/image/menuVerticalIconSVG.svg',
                                            height: Get.width / 25,
                                            width: Get.width / 25,
                                          ),
                                          SizedBox(
                                            width: Get.width / 90,
                                          ),*/
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (homeController
                                                .allMembersDataListGenderWise[
                                                    index]
                                                .profileHaveMarriedBefore !=
                                            null &&
                                        homeController
                                                .allMembersDataListGenderWise[
                                                    index]
                                                .profileHaveMarriedBefore
                                                .toString()
                                                .toLowerCase() !=
                                            "no")
                                      Image.asset(
                                        "assets/image/re-marriage.png",
                                        height: Get.height * 0.06,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
          bottomNavigationBar: (homeController.userData.value.profileType
                      ?.toString() ==
                  "2")
              ? IntrinsicHeight(
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: ConstHelper.orangeColor.withAlpha(64),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        margin: EdgeInsets.only(
                          top: Get.width / 60,
                          bottom: Get.width / 30,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (!maleFemale.value) {
                                  maleFemale.value = true;
                                  await getAllMembersData();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: maleFemale.value
                                      ? ConstHelper.orangeColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: Get.width / 40,
                                  horizontal: Get.width / 25,
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/image/maleIconSVG.svg',
                                      height: Get.width / 30,
                                      width: Get.width / 30,
                                      colorFilter: ColorFilter.mode(
                                        maleFemale.value
                                            ? ConstHelper.whiteColor
                                            : ConstHelper.orangeColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width / 60,
                                    ),
                                    Text(
                                      //profile_gender
                                      'Male ${totalMaleMembers.value}',
                                      style: TextStyle(
                                        color: maleFemale.value
                                            ? ConstHelper.whiteColor
                                            : ConstHelper.orangeColor,
                                        fontSize: Get.width * 0.04,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (maleFemale.value) {
                                  maleFemale.value = false;
                                  await getAllMembersData();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !maleFemale.value
                                      ? ConstHelper.orangeColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: Get.width / 40,
                                  horizontal: Get.width / 25,
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/image/femaleIconSVG.svg',
                                      height: Get.width / 30,
                                      width: Get.width / 30,
                                      colorFilter: ColorFilter.mode(
                                        maleFemale.value
                                            ? ConstHelper.orangeColor
                                            : ConstHelper.whiteColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width / 60,
                                    ),
                                    Text(
                                      'Female ${totalFemaleMembers.value}',
                                      style: TextStyle(
                                        color: maleFemale.value
                                            ? ConstHelper.orangeColor
                                            : ConstHelper.whiteColor,
                                        fontSize: Get.width * 0.04,
                                        fontWeight: FontWeight.w600,
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
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}

class ImageDialog {
  static Future<void> show(BuildContext context, List<SponsorItem> imageUrls,
      {int initialIndex = 0}) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "ImageDialog",
      barrierColor: Colors.black.withAlpha(204),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Column(
          children: [
            Spacer(),
            SizedBox(
              height: Get.height * 0.05,
            ),
            CarouselSlider.builder(
              itemCount: imageUrls.length,
              options: CarouselOptions(
                initialPage: initialIndex,
                enableInfiniteScroll: true,
                enlargeCenterPage: false,
                autoPlay: imageUrls.length != 1 ? true : false,
                height: Get.height * 0.75,
                viewportFraction: 1.1,
              ),
              itemBuilder: (context, index, realIndex) {
                return InteractiveViewer(
                  child: Image.network(
                    ConstHelper.sponsorImgPath + (imageUrls[index].image ?? ""),
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      return progress == null
                          ? child
                          : const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            Spacer(),
          ],
        );
      },
    );
  }
}
