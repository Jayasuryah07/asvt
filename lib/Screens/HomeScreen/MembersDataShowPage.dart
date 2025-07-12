import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/HomeController.dart';
import '../../Models/MembersDataModel.dart';
import '../../Utils/ApiHelper.dart';
import '../../Utils/ConstHelper.dart';
import '../MyProfileScreen/EditProfilePage.dart';
import '../MyProfileScreen/MyProfilePage.dart';

class MembersDataShowPage extends StatefulWidget {
  const MembersDataShowPage({super.key});

  @override
  State<MembersDataShowPage> createState() => _MembersDataShowPageState();
}

class _MembersDataShowPageState extends State<MembersDataShowPage> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    print(homeController.selectedMembersData.value.profileMainContactNum ?? "");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: Get.width * 0.055,
              color: ConstHelper.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () async {
              Get.back();
              await Future.delayed(
                const Duration(
                  milliseconds: 300,
                ),
              );
              homeController.advancedDrawerController.hideDrawer();
            },
            icon: Icon(
              Icons.arrow_back,
              size: Get.width / 13,
              color: ConstHelper.blackColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: ConstHelper.whiteColor,
          surfaceTintColor: ConstHelper.whiteColor,
          elevation: 10,
          shadowColor: ConstHelper.greyColor.withOpacity(0.1),
          // elevation: 3,
          // shadowColor: Colors.grey.shade50.withOpacity(0.3),
        ),
        backgroundColor: ConstHelper.whiteColor,
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Get.width / 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: Get.width / 3,
                      width: Get.width / 3,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(12),
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: ConstHelper.orangeColor,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: homeController.selectedMembersData.value
                                          .profileFullFacePhotoFileName ==
                                      null ||
                                  homeController.selectedMembersData.value
                                      .profileFullFacePhotoFileName!
                                      .trim()
                                      .isEmpty
                              ? ConstHelper.profileImagePath
                              : '${ConstHelper.userImagesPath}${homeController.selectedMembersData.value.profileFullFacePhotoFileName!}',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'User ID',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ConstHelper.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Get.width * 0.05,
                          ),
                        ),
                        Text(
                          homeController.selectedMembersData.value.id == null ||
                                  homeController.selectedMembersData.value.id ==
                                      0
                              ? ConstHelper.naMsg
                              : homeController.selectedMembersData.value.id!
                                  .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ConstHelper.blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: Get.width * 0.045,
                          ),
                        ),
                        Center(
                          child: Text(
                            homeController.selectedMembersData.value.name ==
                                        null ||
                                    homeController
                                        .selectedMembersData.value.name!
                                        .trim()
                                        .isEmpty
                                ? ConstHelper.nameNotAvailableMsg
                                : homeController
                                    .selectedMembersData.value.name!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ConstHelper.orangeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Get.width * 0.05,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.width / 30,
                ),
                Container(
                  width: Get.width,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                      vertical: MediaQuery.of(context).size.width * 0.02),
                  decoration: BoxDecoration(
                    color: ConstHelper.orangeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width / 30,
                    vertical: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          ConstHelper.constHelper
                              .showNetworkImageInDialog(imgPath: [
                            homeController.selectedMembersData.value
                                            .profileFullFacePhotoFileName ==
                                        null ||
                                    homeController.selectedMembersData.value
                                        .profileFullFacePhotoFileName!
                                        .trim()
                                        .isEmpty
                                ? ''
                                : homeController.selectedMembersData.value
                                    .profileFullFacePhotoFileName!,
                            homeController.selectedMembersData.value
                                            .profileFullLengthPhotoFileName ==
                                        null ||
                                    homeController.selectedMembersData.value
                                        .profileFullLengthPhotoFileName!
                                        .trim()
                                        .isEmpty
                                ? ''
                                : homeController.selectedMembersData.value
                                    .profileFullLengthPhoto!,
                          ]);
                        },
                        icon: Icon(
                          Icons.photo_outlined,
                          color: ConstHelper.whiteColor,
                          size: Get.width / 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            final String? phoneNumber = homeController
                                .selectedMembersData
                                .value
                                .profileMainContactNum;

                            if (phoneNumber != null &&
                                phoneNumber.trim().isNotEmpty) {
                              final Uri uri = Uri.parse(
                                  'whatsapp://send?phone=+91${phoneNumber.trim()}');

                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                                print(
                                    "Launching WhatsApp chat with: $phoneNumber");
                              } else {
                                ConstHelper.errorDialog(
                                  text: ConstHelper.somethingErrorMsg,
                                  seconds: 10,
                                );
                              }
                            } else {
                              ConstHelper.errorDialog(
                                text: ConstHelper.mobileNoNotAvailableMsg,
                                seconds: 10,
                              );
                            }
                          } catch (error) {
                            ConstHelper.errorDialog(
                              text: ConstHelper.somethingErrorMsg,
                              seconds: 10,
                            );
                            print("Error launching WhatsApp: $error");
                          }
                        },
                        icon: Image.asset(
                          'assets/image/whatsapp_outlined.png',
                          color: ConstHelper.whiteColor,
                          height: Get.width / 15,
                          width: Get.width / 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
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
                          } else if (homeController.profileShorted.value) {
                            try {
                              await ApiHelper.apiHelper
                                  .unSetMyShortlistProfile(
                                profileId: (homeController
                                            .selectedMembersData.value.id ??
                                        0)
                                    .toString(),
                              )
                                  .then(
                                (data) async {
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
                                  if (data['code'] == 200) {
                                    homeController
                                            .allShortlistedDataList.value =
                                        await ApiHelper.apiHelper
                                            .getAllShortlistedDataList();
                                    EasyLoading.dismiss();
                                    ConstHelper.successDialog(
                                      text: data['msg'] ??
                                          'Profile Removed from Shortlist.',
                                      seconds: 10,
                                    );
                                  } else {
                                    EasyLoading.dismiss();
                                    ConstHelper.errorDialog(
                                      text: data['msg'] ??
                                          ConstHelper.somethingErrorMsg,
                                      seconds: 10,
                                    );
                                  }
                                },
                              );
                            } catch (error) {
                              EasyLoading.dismiss();
                              ConstHelper.errorDialog(
                                text: ConstHelper.somethingErrorMsg,
                                seconds: 10,
                              );
                            }
                          } else {
                            try {
                              await ApiHelper.apiHelper
                                  .setMyShortlistProfile(
                                profileId: (homeController
                                            .selectedMembersData.value.id ??
                                        0)
                                    .toString(),
                              )
                                  .then(
                                (data) async {
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
                                  if (data['code'] == 200) {
                                    EasyLoading.dismiss();
                                    ConstHelper.successDialog(
                                      text: data['msg'] ??
                                          'Profile Shortlisted Successfully.',
                                      seconds: 10,
                                    );
                                  } else {
                                    EasyLoading.dismiss();
                                    ConstHelper.errorDialog(
                                      text: data['msg'] ??
                                          ConstHelper.somethingErrorMsg,
                                      seconds: 10,
                                    );
                                  }
                                },
                              );
                            } catch (error) {
                              EasyLoading.dismiss();
                              ConstHelper.errorDialog(
                                text: ConstHelper.somethingErrorMsg,
                                seconds: 10,
                              );
                            }
                          }
                        },
                        icon: Icon(
                          homeController.profileShorted.value
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: ConstHelper.whiteColor,
                          size: Get.width / 11,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showFeedbackDialog(
                            context,
                            false,
                            (val) async {
                              if (!(await ConstHelper.checkInternet())) {
                                ConstHelper.errorDialog(
                                  text: ConstHelper.internetMsg,
                                  seconds: 10,
                                );
                              } else {
                                try {
                                  EasyLoading.show(
                                    status: ConstHelper.pleaseWaitMsg,
                                  );
                                  await Future.delayed(
                                    const Duration(
                                      milliseconds: 100,
                                    ),
                                  );
                                  await ApiHelper.apiHelper
                                      .insertFeedback(
                                    profileId: homeController
                                        .selectedMembersData.value.id!
                                        .toString(),
                                    description: val,
                                  )
                                      .then(
                                    (msg) {
                                      EasyLoading.dismiss();
                                      if (msg.trim().isEmpty) {
                                        ConstHelper.errorDialog(
                                          text: ConstHelper.somethingErrorMsg,
                                          seconds: 10,
                                        );
                                      } else {
                                        Get.back();
                                        Get.back();
                                        showToastWidget(
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 50),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              // Semi-transparent black background
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.check_circle,
                                                    color: Colors.white,
                                                    size: 28),
                                                const SizedBox(width: 14),
                                                Flexible(
                                                  child: Text(
                                                    msg,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      // White text
                                                      fontSize: 16.0,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          context: context,
                                          duration: const Duration(seconds: 2),
                                          // Short duration for simple toasts
                                          animation: StyledToastAnimation.fade,
                                          // Simple fade animation
                                          reverseAnimation:
                                              StyledToastAnimation.fade,
                                          position: StyledToastPosition.bottom,
                                          // Toast appears at the bottom
                                          animDuration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          reverseCurve: Curves.easeOut,
                                        );
                                      }
                                    },
                                  );
                                } catch (error) {
                                  EasyLoading.dismiss();
                                  ConstHelper.errorDialog(
                                    text: ConstHelper.somethingErrorMsg,
                                    seconds: 10,
                                  );
                                }
                              }
                            },
                          );
                        },
                        icon: Icon(
                          Icons.error,
                          color: ConstHelper.whiteColor,
                          size: Get.width / 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showFeedbackDialog(
                            context,
                            true,
                            (val) async {
                              if (!(await ConstHelper.checkInternet())) {
                                ConstHelper.errorDialog(
                                  text: ConstHelper.internetMsg,
                                  seconds: 10,
                                );
                              } else {
                                try {
                                  EasyLoading.show(
                                    status: ConstHelper.pleaseWaitMsg,
                                  );
                                  await Future.delayed(
                                    const Duration(
                                      milliseconds: 100,
                                    ),
                                  );
                                  await ApiHelper.apiHelper
                                      .insertFeedback(
                                    profileId: homeController
                                        .selectedMembersData.value.id!
                                        .toString(),
                                    description: val,
                                  )
                                      .then(
                                    (msg) {
                                      EasyLoading.dismiss();
                                      if (msg.trim().isEmpty) {
                                        ConstHelper.errorDialog(
                                          text: ConstHelper.somethingErrorMsg,
                                          seconds: 10,
                                        );
                                      } else {
                                        Get.back();
                                        Get.back();

                                        showToastWidget(
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 50),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              // Semi-transparent black background
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.check_circle,
                                                    color: Colors.white,
                                                    size: 28),
                                                const SizedBox(width: 14),
                                                Flexible(
                                                  child: Text(
                                                    msg,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      // White text
                                                      fontSize: 16.0,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          context: context,
                                          duration: const Duration(seconds: 2),
                                          // Short duration for simple toasts
                                          animation: StyledToastAnimation.fade,
                                          // Simple fade animation
                                          reverseAnimation:
                                              StyledToastAnimation.fade,
                                          position: StyledToastPosition.bottom,
                                          // Toast appears at the bottom
                                          animDuration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          reverseCurve: Curves.easeOut,
                                        );
                                      }
                                    },
                                  );
                                } catch (error) {
                                  EasyLoading.dismiss();
                                  ConstHelper.errorDialog(
                                    text: ConstHelper.somethingErrorMsg,
                                    seconds: 10,
                                  );
                                }
                              }
                            },
                          );
                        },
                        icon: Icon(
                          Icons.person_off_outlined,
                          color: ConstHelper.whiteColor,
                          size: Get.width / 15,
                        ),
                      ),
                    ],
                  ),
                ),
                InfoCard(
                  icon: 'assets/image/personWithRoundedSVG.svg',
                  title: "Personal Information",
                  data: [
                    {
                      'Date of Birth': homeController.selectedMembersData.value
                                      .profileDateOfBirth ==
                                  null ||
                              homeController.selectedMembersData.value
                                      .profileDateOfBirth!.year <=
                                  0
                          ? ConstHelper.naMsg
                          : DateFormat('dd | MMM | yyyy').format(homeController
                              .selectedMembersData.value.profileDateOfBirth!)
                    },
                    {
                      'Time of Birth': homeController.selectedMembersData.value
                                      .profileTimeOfBirth ==
                                  null ||
                              homeController
                                  .selectedMembersData.value.profileTimeOfBirth!
                                  .trim()
                                  .isEmpty
                          ? ConstHelper.naMsg
                          : normalizeTime(homeController.selectedMembersData
                                  .value.profileTimeOfBirth ??
                              '')
                    },
                    {
                      'Place of Birth': homeController.selectedMembersData.value
                                      .profilePlaceOfBirth ==
                                  null ||
                              homeController.selectedMembersData.value
                                  .profilePlaceOfBirth!
                                  .trim()
                                  .isEmpty
                          ? ConstHelper.naMsg
                          : homeController
                              .selectedMembersData.value.profilePlaceOfBirth!
                    },
                    {
                      'Height': homeController.selectedMembersData.value
                                      .profileHeight ==
                                  null ||
                              homeController
                                  .selectedMembersData.value.profileHeight!
                                  .toString()
                                  .trim()
                                  .isEmpty
                          ? ConstHelper.naMsg
                          : convertInchesToFeetInch(homeController
                                  .selectedMembersData.value.profileHeight
                                  ?.toInt() ??
                              0),
                    },
                    {
                      "Physical Disability (If any)": homeController
                                      .selectedMembersData
                                      .value
                                      .profilePhysicalDisablity ==
                                  null ||
                              homeController.selectedMembersData.value
                                  .profilePhysicalDisablity!
                                  .trim()
                                  .isEmpty
                          ? ConstHelper.naMsg
                          : homeController.selectedMembersData.value
                              .profilePhysicalDisablity!
                    },
                  ],
                ),
                SizedBox(
                  height: Get.width / 60,
                ),
                InfoCard(
                  icon: 'assets/image/occupationSVG.svg',
                  title: 'Occupation Details',
                  data: [
                    {
                      'Qualification': homeController.selectedMembersData.value
                                      .profileEducationQualification ==
                                  null ||
                              homeController.selectedMembersData.value
                                  .profileEducationQualification!
                                  .trim()
                                  .isEmpty
                          ? ConstHelper.naMsg
                          : homeController.selectedMembersData.value
                              .profileEducationQualification!,
                    },
                    {
                      'Profession': homeController.selectedMembersData.value
                                      .profileProfession ==
                                  null ||
                              homeController
                                  .selectedMembersData.value.profileProfession!
                                  .trim()
                                  .isEmpty
                          ? ConstHelper.naMsg
                          : homeController
                              .selectedMembersData.value.profileProfession!,
                    },
                    {
                      'Organization': homeController.selectedMembersData.value
                              .profileProfessionOrgName ??
                          ConstHelper.naMsg
                    },
                    {
                      'Org. Type': homeController.selectedMembersData.value
                              .profileProfessionOrgType ??
                          ConstHelper.naMsg
                    },
                    {
                      'Annual Income (In lacs)': homeController
                              .selectedMembersData
                              .value
                              .profileProfessionAnnualNetIncome
                              ?.toString() ??
                          ConstHelper.naMsg
                    },
                  ],
                ),
                SizedBox(
                  height: Get.width / 60,
                ),
                InfoCard(
                  icon: 'assets/image/familySVG.svg',
                  title: 'Family Details',
                  data: [
                    {
                      'Father Name': homeController.selectedMembersData.value
                              .profileFatherFullName ??
                          ConstHelper.naMsg
                    },
                    {
                      'Mother Name': homeController.selectedMembersData.value
                              .profileMotherFullName ??
                          ConstHelper.naMsg
                    },
                    {
                      "Mobile (Father)":
                          "${homeController.selectedMembersData.value.profileMainContactNum ?? ConstHelper.naMsg}"
                    },
                    {
                      "Mobile (Mother)":
                          "${homeController.selectedMembersData.value.profileAlternateContactNum ?? ConstHelper.naMsg}"
                    },
                    {
                      "Brother":
                          "M - ${homeController.selectedMembersData.value.profileMarriedBrother ?? ConstHelper.naMsg}   Un M - ${homeController.selectedMembersData.value.profileUnmarriedBrother ?? ConstHelper.naMsg}"
                    },
                    {
                      "Sister":
                          "M - ${homeController.selectedMembersData.value.profileMarriedSister ?? ConstHelper.naMsg}   Un M - ${homeController.selectedMembersData.value.profileUnmarriedSister ?? ConstHelper.naMsg}"
                    },
                    {
                      'Current Address (${homeController.selectedMembersData.value.profileHouseType ?? ConstHelper.naMsg} - ${homeController.selectedMembersData.value.profileNumOfYearsAtThisAddress ?? ConstHelper.naMsg})':
                          homeController.selectedMembersData.value
                                  .profileCurrentResidAddress ??
                              ConstHelper.naMsg
                    },
                  ],
                ),
                SizedBox(
                  height: Get.width / 60,
                ),
                if ((homeController.selectedMembersData.value
                                .profileHaveMarriedBefore ??
                            "")
                        .toString()
                        .toLowerCase() !=
                    "no")
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      InfoCard(
                        icon: 'assets/image/kundaliSVG.svg',
                        title: 'Earlier Marriage',
                        data: [
                          {
                            'Is Married Before': homeController
                                    .selectedMembersData
                                    .value
                                    .profileHaveMarriedBefore ??
                                "-"
                          },
                          (homeController.selectedMembersData.value
                                              .profileHaveMarriedBefore ??
                                          "")
                                      .toString()
                                      .toLowerCase() ==
                                  "yes and divorced"
                              ? {
                                  "Divorce Status": homeController
                                          .selectedMembersData
                                          .value
                                          .profileDivorceStatus ??
                                      "-"
                                }
                              : {
                                  "When Spouse Died?": homeController
                                          .selectedMembersData
                                          .value
                                          .profileSpouseDied ??
                                      "-"
                                },
                          {
                            "Num. Of Children From Prev. Marriage ":
                                homeController.selectedMembersData.value
                                        .profileChildrenNumFromPrevMarriage ??
                                    "-"
                          },
                          {
                            "Children with whom": homeController
                                    .selectedMembersData
                                    .value
                                    .profileChildrenWith ??
                                "-"
                          },
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          0,
                          Get.height * 0.005,
                          Get.height * 0.019,
                          0,
                        ),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Image.asset(
                            "assets/image/re-marriage.png",
                            height: Get.height * 0.06,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: Get.width / 60,
                ),
                InfoCard(
                  icon: 'assets/image/kundaliSVG.svg',
                  title: 'Kundali',
                  data: [
                    {
                      'Gotra': homeController
                              .selectedMembersData.value.profileGotra ??
                          ConstHelper.naMsg
                    },
                    {
                      'Matching kundali': homeController.selectedMembersData
                              .value.profileWillMatchGanna ??
                          ConstHelper.naMsg
                    },
                    {
                      "Marry in same gotra": homeController.selectedMembersData
                              .value.profileMarryInComunity ??
                          ConstHelper.naMsg
                    },
                    {
                      "Are you Manglik?": homeController
                              .selectedMembersData.value.profileIsManglik ??
                          ConstHelper.naMsg
                    },
                    {
                      "Will you Marry A Manglik?": homeController
                              .selectedMembersData
                              .value
                              .profileWillMarryManglink ??
                          ConstHelper.naMsg
                    },
                  ],
                ),
                SizedBox(
                  height: Get.width / 60,
                ),
                InfoCard(
                  icon: 'assets/image/partnerSVG.svg',
                  title: 'Partner Preferences',
                  data: [
                    {
                      'P. Spouse can be elder(> yrs)': homeController
                              .selectedMembersData
                              .value
                              .profileSpouseCanBeOlderBy ??
                          ConstHelper.naMsg
                    },
                    {
                      'P. Spouse can be younger(< yrs)': homeController
                              .selectedMembersData
                              .value
                              .profileSpouseCanBeYoungerBy ??
                          ConstHelper.naMsg
                    },
                    {
                      "Bride permitted to work after marriage?": homeController
                              .selectedMembersData
                              .value
                              .profileBridePermittedToWorkAfterMarriage ??
                          ConstHelper.naMsg
                    },
                    {
                      "Current city": homeController
                              .selectedMembersData.value.collageCity ??
                          ConstHelper.naMsg
                    },
                    {
                      "Resident after marriage": homeController
                              .selectedMembersData
                              .value
                              .profilePlaceOfResidAfterMarriage ??
                          ConstHelper.naMsg
                    },
                  ],
                ),
                SizedBox(
                  height: Get.width / 60,
                ),
                InfoCard(
                  icon: 'assets/image/partnerSVG.svg',
                  title: 'Contact References',
                  data: [
                    {
                      'Name': homeController.selectedMembersData.value
                              .profileMainContactFullName ??
                          ConstHelper.naMsg
                    },
                    {
                      'Mobile': homeController.selectedMembersData.value
                              .profileMainContactNum ??
                          ConstHelper.naMsg
                    },
                    {
                      "Location": homeController.selectedMembersData.value
                              .profileCurrentResidAddress ??
                          ConstHelper.naMsg
                    },
                  ],
                ),
                SizedBox(
                  height: Get.width / 60,
                ),
                if ((homeController.userData.value.profileType?.toString() ==
                    "2"))
                  InfoCard(
                    icon: 'assets/image/ruppeSVG.svg',
                    title: 'Budget Info (In lacs)',
                    data: [
                      {
                        'Budget Bride': homeController.selectedMembersData.value
                                .profileBudgetCategoryId ??
                            ConstHelper.naMsg
                      },
                      {
                        'Budget Groom': homeController.selectedMembersData.value
                                .profileGroomBudgetCategoryId ??
                            ConstHelper.naMsg
                      },
                      {
                        'Profile Created': DateFormat("dd-MM-yyyy").format(
                            homeController.selectedMembersData.value
                                    .profileRegistrationDate ??
                                DateTime.now()),
                      },
                      {
                        "Update Date": DateFormat("dd-MM-yyyy").format(
                            homeController.selectedMembersData.value
                                    .profileModifyDate ??
                                DateTime.now()),
                      },
                    ],
                  ),
                SizedBox(
                  height: Get.width / 60,
                ),
                InfoCard(
                  icon: 'assets/image/aboutMeRoundedSVG.svg',
                  title: 'Important Note',
                  data: [
                    {
                      'Note': homeController
                                      .selectedMembersData.value.profileNote ==
                                  null ||
                              homeController
                                  .selectedMembersData.value.profileNote!
                                  .trim()
                                  .isEmpty
                          ? ConstHelper.naMsg
                          : homeController
                              .selectedMembersData.value.profileNote!,
                    },
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
    );
  }
}

void showFeedbackDialog(
    BuildContext context, bool isTrue, void Function(String val)? onPressed) {
  showDialog(
    barrierColor: Colors.black.withOpacity(0.3), // Adjust overlay color
    context: context,
    builder: (BuildContext context) {
      RxInt selectedOption = (-1).obs;
      return Dialog(
        insetPadding: EdgeInsets.zero, // Remove padding around the dialog
        alignment: Alignment.center, // Position the dialog at the bottom
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95, // Full-width dialog
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8), // Dialog background color
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(0), // Rounded top corners
            ),
          ),
          child: SingleChildScrollView(
            child: isTrue
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Text(
                        "Report/Block User".toUpperCase(),
                        style: TextStyle(
                          fontSize: Get.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ).paddingSymmetric(
                          vertical: MediaQuery.of(context).size.width * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.height * 0.005,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04),
                        child: Text(
                          "Blocked profiles won’t appear in your suggestions.",
                          style: TextStyle(
                              fontSize: Get.width * 0.045,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Get.height * 0.01,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  onPressed!("Report and block user");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Profile Feedback".toUpperCase(),
                        style: TextStyle(
                          fontSize: Get.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ).paddingSymmetric(
                          vertical: MediaQuery.of(context).size.width * 0.02),
                      const Divider(
                        color: Colors.white,
                        thickness: 1.5,
                      ).paddingSymmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04),
                      // Feedback Options
                      Obx(() => Column(
                            children: [
                              RadioOption(
                                title: "Married/Engaged",
                                selectedOption: selectedOption.value,
                                value: 0,
                                onChanged: (value) {
                                  selectedOption.value = value!;
                                },
                              ),
                              RadioOption(
                                title: "Duplicate Profile",
                                selectedOption: selectedOption.value,
                                value: 1,
                                onChanged: (value) {
                                  selectedOption.value = value!;
                                },
                              ),
                              RadioOption(
                                title: "Incomplete Information",
                                selectedOption: selectedOption.value,
                                value: 2,
                                onChanged: (value) {
                                  selectedOption.value = value!;
                                },
                              ),
                              RadioOption(
                                title: "Wrong Information",
                                selectedOption: selectedOption.value,
                                value: 3,
                                onChanged: (value) {
                                  selectedOption.value = value!;
                                },
                              ),
                              RadioOption(
                                title: "Other Reason",
                                selectedOption: selectedOption.value,
                                value: 4,
                                onChanged: (value) {
                                  selectedOption.value = value!;
                                },
                              ),
                            ],
                          )),
                      const Divider(
                        color: Colors.white,
                        thickness: 1.5,
                      ).paddingSymmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04),
                      // Buttons
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  onPressed!(selectedOption.value == 0
                                      ? "Married/Engaged"
                                      : selectedOption.value == 1
                                          ? "Duplicate Profile"
                                          : selectedOption.value == 2
                                              ? "Incomplete Information"
                                              : selectedOption.value == 3
                                                  ? "Wrong Information"
                                                  : "Other Reason");
                                }, // Handle Send

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Disclaimer
                      /*Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "*User will be removed from list after feedback.",
                          style: TextStyle(
                            fontSize: Get.width * 0.045,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),*/
                    ],
                  ),
          ),
        ),
      );
    },
  );
}

// Custom Radio Option Widget
class RadioOption extends StatelessWidget {
  final String title;
  final int selectedOption;
  final int value;
  final ValueChanged<int?> onChanged;

  const RadioOption({
    Key? key,
    required this.title,
    required this.selectedOption,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: Get.width * 0.04,
        ),
      ),
      leading: Radio<int>(
        value: value,
        groupValue: selectedOption,
        onChanged: onChanged,
        fillColor: const MaterialStatePropertyAll(Colors.white),
        activeColor: Colors.white,
      ),
      onTap: () => onChanged(value),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final dynamic icon;
  final Widget? text;
  final List<Map<String, String>> data;

  const InfoCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.data,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: MediaQuery.of(context).size.width * 0.02),
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: MediaQuery.of(context).size.width * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon is IconData
                  ? Icon(
                      icon,
                      color: ConstHelper.orangeColor,
                      size: 24,
                    )
                  : SvgPicture.asset(
                      icon,
                      height: Get.width / 25,
                      width: Get.width / 25,
                      color: ConstHelper.orangeColor,
                    ),
              const SizedBox(width: 10),
              Text(
                title,
                style: headingTextStyle,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...data.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: text ??
                        Text(
                          entry.keys.first,
                          style: titleTextStyle,
                        ),
                  ),
                  Text(
                    ":  ",
                    style: titleTextStyle,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      entry.values.first,
                      style: valueTextStyle,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
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
/*import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/HomeController.dart';
import '../../Models/MembersDataModel.dart';
import '../../Utils/ApiHelper.dart';
import '../../Utils/ConstHelper.dart';

class MembersDataShowPage extends StatefulWidget {
  const MembersDataShowPage({super.key});

  @override
  State<MembersDataShowPage> createState() => _MembersDataShowPageState();
}

class _MembersDataShowPageState extends State<MembersDataShowPage> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: 20,
              color: ConstHelper.blackColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () async {
              Get.back();
              await Future.delayed(
                const Duration(
                  milliseconds: 300,
                ),
              );
              homeController.advancedDrawerController.hideDrawer();
            },
            icon: Icon(
              Icons.arrow_back,
              size: Get.width / 18,
              color: ConstHelper.orangeColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: ConstHelper.whiteColor,
          surfaceTintColor: ConstHelper.whiteColor,
          elevation: 10,
          shadowColor: ConstHelper.greyColor.withOpacity(0.1),
          // elevation: 3,
          // shadowColor: Colors.grey.shade50.withOpacity(0.3),
        ),
        backgroundColor: ConstHelper.whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width / 20,
          ),
          child: SingleChildScrollView(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.width / 25,
                  ),
                  // Center(
                  //   child: Container(
                  //     height: Get.width/1.6,
                  //     width: Get.width/1.6,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(12),
                  //       gradient: LinearGradient(
                  //         begin: Alignment.topCenter,
                  //         end: Alignment.bottomCenter,
                  //         colors: [
                  //         colors: [
                  //           ConstHelper.blackColor.withOpacity(0.8),
                  //           ConstHelper.orangeColor.withOpacity(0.8),
                  //         ],
                  //       ),
                  //     ),
                  //     padding: EdgeInsets.all(Get.width/80),
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(9),
                  //       child: CachedNetworkImage(
                  //         imageUrl: homeController.selectedMembersData.value.profilePhoto == null || homeController.selectedMembersData.value.profilePhoto!.trim().isEmpty ? ConstHelper.noProfileImagePath : '${ConstHelper.userImagesPath}${homeController.selectedMembersData.value.profilePhoto!}',
                  //         fit: BoxFit.cover,
                  //         placeholder: (context, url) => Container(
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(9),
                  //             color: ConstHelper.whiteColor,
                  //           ),
                  //           alignment: Alignment.center,
                  //           child: CircularProgressIndicator(color: ConstHelper.orangeColor,),
                  //         ),
                  //         errorWidget: (context, url, error) => Container(
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(9),
                  //             color: ConstHelper.whiteColor,
                  //           ),
                  //           child: Image.asset(
                  //             'assets/image/imageNotFound.png',
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: Get.width / 1.6,
                          width: Get.width / 1.6,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(12),
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              color: ConstHelper.orangeColor,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: homeController.selectedMembersData.value
                                              .profileFullFacePhotoFileName ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profileFullFacePhotoFileName!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.profileImagePath
                                  : '${ConstHelper.userImagesPath}${homeController.selectedMembersData.value.profileFullFacePhotoFileName!}',
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.width / 30,
                  ),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: ConstHelper.orangeColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width / 30,
                      vertical: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            ConstHelper.constHelper.showNetworkImageInDialog(
                              imgPath: homeController.selectedMembersData.value
                                              .profilePhoto ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profilePhoto!
                                          .trim()
                                          .isEmpty
                                  ? ''
                                  : homeController
                                      .selectedMembersData.value.profilePhoto!,
                            );
                          },
                          icon: Icon(
                            Icons.photo_outlined,
                            color: ConstHelper.whiteColor,
                            size: Get.width / 15,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            try {
                              if (homeController.selectedMembersData.value
                                          .profileMobile !=
                                      null ||
                                  homeController
                                      .selectedMembersData.value.profileMobile!
                                      .trim()
                                      .isNotEmpty) {
                                Uri uri = Uri.parse(
                                    'whatsapp://send?phone=+91 ${homeController.selectedMembersData.value.profileMobile}');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri);
                                } else {
                                  ConstHelper.errorDialog(
                                    text: ConstHelper.somethingErrorMsg,
                                    seconds: 10,
                                  );
                                }
                              } else {
                                ConstHelper.errorDialog(
                                  text: ConstHelper.mobileNoNotAvailableMsg,
                                  seconds: 10,
                                );
                              }
                            } catch (error) {
                              ConstHelper.errorDialog(
                                text: ConstHelper.somethingErrorMsg,
                                seconds: 10,
                              );
                            }
                          },
                          icon: Image.asset(
                            'assets/image/whatsapp_outlined.png',
                            color: ConstHelper.whiteColor,
                            height: Get.width / 15,
                            width: Get.width / 15,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            EasyLoading.show(
                              status: ConstHelper.pleaseWaitMsg,
                            );
                            await Future.delayed(
                              Duration(
                                milliseconds: 200,
                              ),
                            );
                            if (!(await ConstHelper.checkInternet())) {
                              EasyLoading.dismiss();
                              ConstHelper.errorDialog(
                                text: ConstHelper.internetMsg,
                                seconds: 10,
                              );
                            } else if (homeController.profileShorted.value) {
                              try {
                                await ApiHelper.apiHelper
                                    .unSetMyShortlistProfile(
                                  profileId: (homeController
                                              .selectedMembersData.value.id ??
                                          0)
                                      .toString(),
                                )
                                    .then(
                                  (data) async {
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
                                    if (data['code'] == 200) {
                                      homeController
                                              .allShortlistedDataList.value =
                                          await ApiHelper.apiHelper
                                              .getAllShortlistedDataList();
                                      EasyLoading.dismiss();
                                      ConstHelper.successDialog(
                                        text: data['msg'] ??
                                            'Profile Removed from Shortlist.',
                                        seconds: 10,
                                      );
                                    } else {
                                      EasyLoading.dismiss();
                                      ConstHelper.errorDialog(
                                        text: data['msg'] ??
                                            ConstHelper.somethingErrorMsg,
                                        seconds: 10,
                                      );
                                    }
                                  },
                                );
                              } catch (error) {
                                EasyLoading.dismiss();
                                ConstHelper.errorDialog(
                                  text: ConstHelper.somethingErrorMsg,
                                  seconds: 10,
                                );
                              }
                            } else {
                              try {
                                await ApiHelper.apiHelper
                                    .setMyShortlistProfile(
                                  profileId: (homeController
                                              .selectedMembersData.value.id ??
                                          0)
                                      .toString(),
                                )
                                    .then(
                                  (data) async {
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
                                    if (data['code'] == 200) {
                                      EasyLoading.dismiss();
                                      ConstHelper.successDialog(
                                        text: data['msg'] ??
                                            'Profile Shortlisted Successfully.',
                                        seconds: 10,
                                      );
                                    } else {
                                      EasyLoading.dismiss();
                                      ConstHelper.errorDialog(
                                        text: data['msg'] ??
                                            ConstHelper.somethingErrorMsg,
                                        seconds: 10,
                                      );
                                    }
                                  },
                                );
                              } catch (error) {
                                EasyLoading.dismiss();
                                ConstHelper.errorDialog(
                                  text: ConstHelper.somethingErrorMsg,
                                  seconds: 10,
                                );
                              }
                            }
                          },
                          icon: Icon(
                            homeController.profileShorted.value
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: ConstHelper.whiteColor,
                            size: Get.width / 11,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.person_off_outlined,
                            color: ConstHelper.whiteColor,
                            size: Get.width / 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Center(
                  //   child: Text(
                  //     homeController.selectedMembersData.value.name == null || homeController.selectedMembersData.value.name!.trim().isEmpty ? ConstHelper.nameNotAvailableMsg : homeController.selectedMembersData.value.name!,
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       color: ConstHelper.blackColor,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 20,
                  //     ),
                  //   ),
                  // ),
                  // Center(
                  //   child: Text.rich(
                  //     textAlign: TextAlign.center,
                  //     TextSpan(
                  //       children: [
                  //         TextSpan(
                  //           text: 'User ID : ',
                  //           style: TextStyle(
                  //             color: ConstHelper.blackColor,
                  //             fontWeight: FontWeight.w500,
                  //             fontSize: 14,
                  //           ),
                  //         ),
                  //         TextSpan(
                  //           text: homeController.selectedMembersData.value.token == null || homeController.selectedMembersData.value.token!.trim().isEmpty ? ConstHelper.naMsg : homeController.selectedMembersData.value.token!,
                  //           style: TextStyle(
                  //             color: ConstHelper.orangeColor,
                  //             fontWeight: FontWeight.w500,
                  //             fontSize: 14,
                  //           ),
                  //         ),
                  //       ]
                  //     )
                  //   ),
                  // ),
                  SizedBox(
                    height: Get.width / 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'User ID',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ConstHelper.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                        ),
                      ),
                      Text(
                        homeController.selectedMembersData.value.id == null ||
                                homeController.selectedMembersData.value.id == 0
                            ? ConstHelper.naMsg
                            : homeController.selectedMembersData.value.id!
                                .toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ConstHelper.blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: Get.width*0.045,
                        ),
                      ),
                      Center(
                        child: Text(
                          homeController.selectedMembersData.value.name ==
                                      null ||
                                  homeController.selectedMembersData.value.name!
                                      .trim()
                                      .isEmpty
                              ? ConstHelper.nameNotAvailableMsg
                              : homeController.selectedMembersData.value.name!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ConstHelper.orangeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.width / 20,
                  ),

                  InfoCard(
                    icon: 'assets/image/personWithRoundedSVG.svg',
                    title: "Personal Information'",
                    data: [
                      {
                        'Date of Birth': homeController.selectedMembersData
                                        .value.profileDateOfBirth ==
                                    null ||
                                homeController.selectedMembersData.value
                                        .profileDateOfBirth!.year <=
                                    0
                            ? ConstHelper.naMsg
                            : DateFormat('dd | MMM | yyyy').format(
                                homeController.selectedMembersData.value
                                    .profileDateOfBirth!)
                      },
                      {
                        'Date of Time': homeController.selectedMembersData.value
                                        .profileTimeOfBirth ==
                                    null ||
                                homeController.selectedMembersData.value
                                    .profileTimeOfBirth!
                                    .trim()
                                    .isEmpty
                            ? ConstHelper.naMsg
                            : homeController
                                .selectedMembersData.value.profileTimeOfBirth!
                      },
                      {
                        'Place of Birth': homeController.selectedMembersData
                                        .value.profilePlaceOfBirth ==
                                    null ||
                                homeController.selectedMembersData.value
                                    .profilePlaceOfBirth!
                                    .trim()
                                    .isEmpty
                            ? ConstHelper.naMsg
                            : homeController
                                .selectedMembersData.value.profilePlaceOfBirth!
                      },
                      {
                        'Place of Birth': homeController.selectedMembersData
                                        .value.profilePlaceOfBirth ==
                                    null ||
                                homeController.selectedMembersData.value
                                    .profilePlaceOfBirth!
                                    .trim()
                                    .isEmpty
                            ? ConstHelper.naMsg
                            : homeController
                                .selectedMembersData.value.profilePlaceOfBirth!
                      },
                      {
                        'Height': homeController.selectedMembersData.value
                                        .profileHeight ==
                                    null ||
                                homeController
                                    .selectedMembersData.value.profileHeight!
                                    .toString()
                                    .trim()
                                    .isEmpty
                            ? ConstHelper.naMsg
                            : '${homeController.selectedMembersData.value.profileHeight!} ft ${homeController.selectedMembersData.value.profileHeight!.toString().substring(1)} Inch',
                      },
                      {
                        "Physical Disability (If any)": homeController
                                        .selectedMembersData
                                        .value
                                        .profilePhysicalDisablity ==
                                    null ||
                                homeController.selectedMembersData.value
                                    .profilePhysicalDisablity!
                                    .trim()
                                    .isEmpty
                            ? ConstHelper.naMsg
                            : homeController.selectedMembersData.value
                                .profilePhysicalDisablity!
                      },
                    ],
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
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Date of Birth',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profileDateOfBirth ==
                                          null ||
                                      homeController.selectedMembersData.value
                                              .profileDateOfBirth!.year <=
                                          0
                                  ? ConstHelper.naMsg
                                  : DateFormat('dd | MMM | yyyy').format(
                                      homeController.selectedMembersData.value
                                          .profileDateOfBirth!),
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Date of Time',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profileTimeOfBirth ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profileTimeOfBirth!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController.selectedMembersData.value
                                      .profileTimeOfBirth!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Place of Birth',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profilePlaceOfBirth ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profilePlaceOfBirth!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController.selectedMembersData.value
                                      .profilePlaceOfBirth!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Height',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profileHeight ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profileHeight!
                                          .toString()
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : '${homeController.selectedMembersData.value.profileHeight!} ft ${homeController.selectedMembersData.value.profileHeight!.toString().substring(1)} Inch',
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Physical Disability',
                                  style: titleTextStyle,
                                ),
                                Text(
                                  '(if any)',
                                  style: valueTextStyle,
                                ),
                              ],
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profilePhysicalDisablity ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profilePhysicalDisablity!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController.selectedMembersData.value
                                      .profilePhysicalDisablity!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
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
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Qualification',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profileprofileEducationQualification ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profileprofileEducationQualification!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController.selectedMembersData.value
                                      .profileprofileEducationQualification!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Occupation',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profileProfession ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profileProfession!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController.selectedMembersData.value
                                      .profileProfession!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: Get.width/90,),
                      // Row(
                      //   // crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         'Organization',
                      //         style: titleTextStyle,
                      //       ),
                      //     ),
                      //     threeDotWidget(),
                      //     Expanded(
                      //       child: Text(
                      //         ConstHelper.naMsg,
                      //         style: valueTextStyle,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: Get.width/90,),
                      // Row(
                      //   // crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         'Org. Type',
                      //         style: titleTextStyle,
                      //       ),
                      //     ),
                      //     threeDotWidget(),
                      //     Expanded(
                      //       child: Text(
                      //         ConstHelper.naMsg,
                      //         style: valueTextStyle,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: Get.width/90,),
                      // Row(
                      //   // crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         'Annual Income',
                      //         style: titleTextStyle,
                      //       ),
                      //     ),
                      //     threeDotWidget(),
                      //     Expanded(
                      //       child: Text(
                      //         ConstHelper.naMsg,
                      //         style: valueTextStyle,
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Father Name',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profileFatherFullName ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profileFatherFullName!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController.selectedMembersData.value
                                      .profileFatherFullName!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: Get.width/90,),
                      // Row(
                      //   // crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         'Mother Name',
                      //         style: titleTextStyle,
                      //       ),
                      //     ),
                      //     threeDotWidget(),
                      //     Expanded(
                      //       child: Text(
                      //         ConstHelper.naMsg,
                      //         style: valueTextStyle,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: homeController.selectedMembersData.value.profileFatherFullName == null || homeController.selectedMembersData.value.profileFatherFullName!.trim().isEmpty ? 0 : Get.width/90,),
                      // homeController.selectedMembersData.value.profileFatherFullName == null || homeController.selectedMembersData.value.profileFatherFullName!.trim().isEmpty ? SizedBox() : Row(
                      //   // crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         homeController.selectedMembersData.value.profileFatherFullName!,
                      //         style: titleTextStyle,
                      //       ),
                      //     ),
                      //     threeDotWidget(),
                      //     Expanded(
                      //       child: Text(
                      //         ConstHelper.naMsg,
                      //         style: valueTextStyle,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // // SizedBox(height: Get.width/90,),
                      // // Row(
                      // //   // crossAxisAlignment: CrossAxisAlignment.start,
                      // //   children: [
                      // //     Expanded(
                      // //       child: Text(
                      // //         'Suman Khautan',
                      // //         style: titleTextStyle,
                      // //       ),
                      // //     ),
                      // //     threeDotWidget(),
                      // //     Expanded(
                      // //       child: Text(
                      // //         '1213243567',
                      // //         style: valueTextStyle,
                      // //       ),
                      // //     ),
                      // //   ],
                      // // ),
                      // SizedBox(height: Get.width/90,),
                      // Row(
                      //   // crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         'Brother',
                      //         style: titleTextStyle,
                      //       ),
                      //     ),
                      //     threeDotWidget(),
                      //     Expanded(
                      //       child: Text.rich(
                      //         TextSpan(
                      //           children: [
                      //             TextSpan(
                      //               text: 'M-${ConstHelper.naMsg}',
                      //               style: valueTextStyle,
                      //             ),
                      //             TextSpan(
                      //               text: '      ',
                      //               style: valueTextStyle,
                      //             ),
                      //             TextSpan(
                      //               text: 'Un M-${ConstHelper.naMsg}',
                      //               style: valueTextStyle,
                      //             ),
                      //           ]
                      //         )
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: Get.width/90,),
                      // Row(
                      //   // crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         'Sister',
                      //         style: titleTextStyle,
                      //       ),
                      //     ),
                      //     threeDotWidget(),
                      //     Expanded(
                      //       child: Text.rich(
                      //         TextSpan(
                      //           children: [
                      //             TextSpan(
                      //               text: 'M-${ConstHelper.naMsg}',
                      //               style: valueTextStyle,
                      //             ),
                      //             TextSpan(
                      //               text: '      ',
                      //               style: valueTextStyle,
                      //             ),
                      //             TextSpan(
                      //               text: 'Un M-${ConstHelper.naMsg}',
                      //               style: valueTextStyle,
                      //             ),
                      //           ]
                      //         )
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Current Address (Rent - 5yrs)',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profilePermanentAddress ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profilePermanentAddress!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController.selectedMembersData.value
                                      .profilePermanentAddress!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Native Place',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              ConstHelper.naMsg,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Community',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profileComunityName ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profileComunityName!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController.selectedMembersData.value
                                      .profileComunityName!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Gotra',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profileGotra ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profileGotra!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController
                                      .selectedMembersData.value.profileGotra!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Reference Name',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profileRefContactName ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profileRefContactName!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController.selectedMembersData.value
                                      .profileRefContactName!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Reference Mobile No',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profileRefContactMobile ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profileRefContactMobile!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController.selectedMembersData.value
                                      .profileRefContactMobile!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 90,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Main Contact No',
                              style: titleTextStyle,
                            ),
                          ),
                          threeDotWidget(),
                          Expanded(
                            child: Text(
                              homeController.selectedMembersData.value
                                              .profileMainContactNum ==
                                          null ||
                                      homeController.selectedMembersData.value
                                          .profileMainContactNum!
                                          .trim()
                                          .isEmpty
                                  ? ConstHelper.naMsg
                                  : homeController.selectedMembersData.value
                                      .profileMainContactNum!,
                              style: valueTextStyle,
                            ),
                          ),
                        ],
                      ),
                      myDividerWidget(),
                    ],
                  ),
                  // SizedBox(height: Get.width/60,),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         SvgPicture.asset('assets/image/kundaliSVG.svg',height: Get.width/25,width: Get.width/25,color: ConstHelper.blackColor,),
                  //         SizedBox(width: Get.width/30,),
                  //         Flexible(
                  //           child: Text(
                  //             'Kundali',
                  //             style: headingTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/20,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'Gotra',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             homeController.selectedMembersData.value.profileGotra == null || homeController.selectedMembersData.value.profileGotra!.trim().isEmpty ? ConstHelper.naMsg : homeController.selectedMembersData.value.profileGotra!,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/90,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'Matching Janampatri',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             ConstHelper.naMsg,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/90,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'Marry in Same Gotra',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             ConstHelper.naMsg,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/90,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'Are you Manglik',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             ConstHelper.naMsg,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/90,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'Will you Marry Manglik',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             ConstHelper.naMsg,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     myDividerWidget(),
                  //   ],
                  // ),
                  // SizedBox(height: Get.width/60,),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         SvgPicture.asset('assets/image/partnerSVG.svg',height: Get.width/25,width: Get.width/25,color: ConstHelper.blackColor,),
                  //         SizedBox(width: Get.width/30,),
                  //         Flexible(
                  //           child: Text(
                  //             'Partner Preference',
                  //             style: headingTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/20,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'P. Spouse Can Be',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             ConstHelper.naMsg,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/90,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'P. Spouse Can Be',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             ConstHelper.naMsg,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/90,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'Desired Edu. of P. Spouse',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             ConstHelper.naMsg,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/90,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'Bride Permitted To Work After Marriage',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             ConstHelper.naMsg,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/90,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'Current City',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             ConstHelper.naMsg,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/90,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'Resident After Marriage',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             ConstHelper.naMsg,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     myDividerWidget(),
                  //   ],
                  // ),
                  SizedBox(
                    height: Get.width / 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/image/aboutMeRoundedSVG.svg',
                            height: Get.width / 25,
                            width: Get.width / 25,
                            color: ConstHelper.blackColor,
                          ),
                          SizedBox(
                            width: Get.width / 30,
                          ),
                          Flexible(
                            child: Text(
                              'Important Note',
                              style: headingTextStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.width / 20,
                      ),
                      Text(
                        homeController.selectedMembersData.value.profileNote ==
                                    null ||
                                homeController
                                    .selectedMembersData.value.profileNote!
                                    .trim()
                                    .isEmpty
                            ? ConstHelper.naMsg
                            : homeController
                                .selectedMembersData.value.profileNote!,
                        style: valueTextStyle,
                      ),
                      // myDividerWidget(),
                    ],
                  ),
                  // SizedBox(height: Get.width/60,),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         SvgPicture.asset('assets/image/ruppeSVG.svg',height: Get.width/25,width: Get.width/25,color: ConstHelper.blackColor,),
                  //         SizedBox(width: Get.width/30,),
                  //         Flexible(
                  //           child: Text(
                  //             'Budget Info',
                  //             style: headingTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(height: Get.width/20,),
                  //     Row(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Text(
                  //             'Budget',
                  //             style: titleTextStyle,
                  //           ),
                  //         ),
                  //         threeDotWidget(),
                  //         Expanded(
                  //           child: Text(
                  //             ConstHelper.naMsg,
                  //             style: valueTextStyle,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: Get.width/20,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SvgPicture.asset('assets/image/yagnArrowLeftSVG.svg',height: Get.width/30,width: Get.width/30,),
                  //     SizedBox(width: Get.width/30,),
                  //     SvgPicture.asset('assets/image/yagnSVG.svg',height: Get.width/4,width: Get.width/4,),
                  //     SizedBox(width: Get.width/30,),
                  //     SvgPicture.asset('assets/image/yagnArrowRightSVG.svg',height: Get.width/30,width: Get.width/30,),
                  //   ],
                  // ),
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
}

class InfoCard extends StatelessWidget {
  final String title;
  final dynamic icon;
  final Widget? text;
  final List<Map<String, String>> data;

  const InfoCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.data,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon is IconData
                  ? Icon(
                      icon,
                      color: ConstHelper.orangeColor,
                      size: 24,
                    )
                  : SvgPicture.asset(
                      icon,
                      height: Get.width / 25,
                      width: Get.width / 25,
                      color: ConstHelper.orangeColor,
                    ),
              const SizedBox(width: 10),
              Text(
                title,
                style: headingTextStyle,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...data.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: text ??
                        Text(
                          entry.keys.first,
                          style: titleTextStyle,
                        ),
                  ),
                  Text(
                    ":  ",
                    style: titleTextStyle,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      entry.values.first,
                      style: valueTextStyle,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

TextStyle headingTextStyle = TextStyle(
  color: ConstHelper.blackColor,
  fontWeight: FontWeight.w600,
  fontSize: 14,
);

TextStyle titleTextStyle = TextStyle(
  color: ConstHelper.blackColor,
  fontSize: 12,
  fontWeight: FontWeight.w500,
);

TextStyle valueTextStyle = TextStyle(
  color: ConstHelper.cementColor,
  fontSize: 12,
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
*/
