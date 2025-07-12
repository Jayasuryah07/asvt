import 'dart:convert';
import 'dart:developer';

import 'package:asvt_flutter_app/Models/budget_category_model.dart';
import 'package:asvt_flutter_app/Models/chidren_with_me_model.dart';
import 'package:asvt_flutter_app/Models/community_prefrence_model.dart';
import 'package:asvt_flutter_app/Models/divorce_status_mmodel.dart';
import 'package:asvt_flutter_app/Models/married_before_mmodel.dart';
import 'package:asvt_flutter_app/Models/profession_model.dart';
import 'package:asvt_flutter_app/Models/samaj_model.dart';
import 'package:asvt_flutter_app/Models/work_after_marriage_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getX;

import '../Controllers/HomeController.dart';
import '../Models/MembersDataModel.dart';
import '../Models/UserDataModel.dart';
import '../Models/sponsers_model.dart';
import 'API.dart';

class ApiHelper {
  ApiHelper._();

  static ApiHelper apiHelper = ApiHelper._();
  API api = API();
  String authorizationToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNjYzNjY5Mjg4Y2JjYWIxOTQyODY5NDNhYjczOTVlMjJjYzdlZTliMmQ3ZDNlNmM4NjYzMzVhYmFlZTJjZjg5ZjRjMTlkNzc2NWVmNzAzOTMiLCJpYXQiOjE3MjMwMDY1NjEuMjI2ODAwOTE4NTc5MTAxNTYyNSwibmJmIjoxNzIzMDA2NTYxLjIyNjgwNDAxODAyMDYyOTg4MjgxMjUsImV4cCI6MTc1NDU0MjU2MS4yMjUyNzE5NDAyMzEzMjMyNDIxODc1LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.awZQ8OEkGNtGq3ZauBAR76VuGLm8-QjEUbQTMv-SenGeEAabXtYJov5kyH0kn6lp8S7Enhr8Zerkl7Bbgkb1Bd0z0d4Mozh3hDr-nH7IjhB1tHoWp2f_XY1kE59BhILKVFB61iFNZZJHeC0MHLO84UjaiAI1Cei6gHaUZTL4TQU8VbO41C4yM85QTTRRgApg24wqZvUUNwLPyGz8tEqRN5GSQbmmW3RgyeF5kDsLlk3Ck3hOqTN20dfe9DPZj7Tj_E4bqZTGqBu45DZVagGiy92AuZeKhTzkPqh8vZGI1IS_IzbQkJd2BTkBCBeaTUuwgRRn8aMufbbliRh9JhSSp8h7UQq3Bh9YrcOfyL0WKYFdWe-_fHLCR_JBJfkDYMm4nKsEPfKgvMU0x2ZfoK2UEjsoKq9YJLQdfsMFlT55UVRObFX8zcYLeH8s8Bm7RI0ZAt8C7CdSqHRXF1kI662naciV0onCUTtBJcB_2lsIzvvDsK0iZ4FS9H3lrkjqHQ2Cp3LD9XlVUJfhnY_QG47qcjPOEz4B6u7vzZa-JkduMjqkySC38tDgB9fYR97Aor5JMhXnTqOLU8ci4jt27T8B57Jqmayx91m-bz4AFqK1-sYtOWmfOJhYBotGVAW-xAGErCjVZ43qTMpzUEchI0qgPtsRQPOmyf0lvwNTvl8PqyE';

  void getAuthorizationToken() {
    HomeController homeController = getX.Get.put(HomeController());
    authorizationToken =
        homeController.userDataWithToken.value.data?.token ?? '';
    log(authorizationToken);
  }

  Future<List> getCommunityDataList() async {
    try {
      getAuthorizationToken();
      // var data = FormData.fromMap({
      //   'school_id': schoolId,
      //   'current_std': currentStd,
      // });
      Response response = await api.dio.post(
        'comunity',
      );
      if (response.statusCode == 200) {
        var data = response.data;
        return data == null ? [] : data['data'] ?? [];
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<MembersDataModel>> getAllMembersDataList({
    required String heightFrom,
    required String heightTo,
    required List<String> educationCategory,
    required String haveMarriedBefore,
    required String ageFrom,
    required String ageTo,
    required String? incomeFrom,
    required String? incomeTo,
    required String isManglik,
    required String excludeGotra,
  }) async {
    getAuthorizationToken();
    print("${{
      'height_from': heightFrom,
      'height_to': heightTo,
      'have_married_before': haveMarriedBefore,
      'income_from': haveMarriedBefore,
      'income_to': haveMarriedBefore,
      'age_from': incomeFrom,
      'age_to': ageTo,
      'exclude_gotra': excludeGotra,
      'is_manglik': isManglik.toLowerCase(),
    }} ::::: filter data");
    var data = FormData.fromMap({
      'height_from': heightFrom,
      'height_to': heightTo,
      'have_married_before': haveMarriedBefore,
      'age_from': ageFrom,
      'age_to': ageTo,
      'income_from': incomeFrom,
      'income_to': incomeTo,
      'exclude_gotra': excludeGotra,
      'is_manglik': isManglik.toLowerCase(),
    });

    for (String category in educationCategory) {
      data.fields.add(MapEntry('education_category[]', category));
    }

    var headers = {
      'Authorization': 'Bearer $authorizationToken',
    };

    Response response = await api.dio.post('fetch-filter',
        data: data,
        options: Options(
          headers: headers,
        ));

    print(data.fields);
    if (response.statusCode == 200) {
      print(response.data);
      var data = response.data;
      print('asdadasd ${data.runtimeType} ${data}');
      return List.from(data == null
          ? []
          : data['data'] == null
              ? []
              : data['data'].map((e) => MembersDataModel.fromJson(e)).toList());
    } else {
      return [];
    }
  }

  Future<MembersDataModel> getSelectedembersDataList({
    required String id,
  }) async {
    getAuthorizationToken();
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      var data = FormData.fromMap({'profile_id': id});

      Response response = await api.dio.post('fetch-profiles-by-id',
          data: data,
          options: Options(
            headers: headers,
          ));

      if (response.statusCode == 200) {
        var data = response.data;
        print(data);
        return MembersDataModel.fromJson(data["data"][0]);
      } else {
        print(response.statusMessage);
        return MembersDataModel();
      }
    } catch (e) {
      return MembersDataModel();
    }
  }

  Future<List<SponItem>?> getSponsersList() async {
    getAuthorizationToken();
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      Response response = await api.dio.post('fetch-sponsers',
          options: Options(
            headers: headers,
          ));

      if (response.statusCode == 200) {
        var data = response.data;
        print(data);
        return SponseredModel.fromJson(data).data ?? [];
      } else {
        print(response.statusMessage);
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<BudgetCategoriesModel> getBudgetCate() async {
    getAuthorizationToken();

    Response response = await api.dio.post(
      'budgetCategories',
    );

    if (response.statusCode == 200) {
      var data = response.data;
      print(data);
      return BudgetCategoriesModel.fromJson(data);
    } else {
      print(response.statusMessage);
      return BudgetCategoriesModel();
    }
  }

  Future<ProfessionModel> getProfession() async {
    getAuthorizationToken();

    Response response = await api.dio.post(
      'fetch-profession',
    );

    if (response.statusCode == 200) {
      var data = response.data;
      print(data);
      return ProfessionModel.fromJson(data);
    } else {
      print(response.statusMessage);
      return ProfessionModel();
    }
  }

  Future<CommunityPreModel> getCommunityPreferences() async {
    getAuthorizationToken();

    Response response = await api.dio.post(
      'fetch-community-preferences',
    );

    if (response.statusCode == 200) {
      var data = response.data;
      print(data);
      return CommunityPreModel.fromJson(data);
    } else {
      print(response.statusMessage);
      return CommunityPreModel();
    }
  }

  Future<MarriedBeforeModel> getMarriedBefore() async {
    getAuthorizationToken();

    Response response = await api.dio.post(
      'fetch-married-before',
    );

    if (response.statusCode == 200) {
      var data = response.data;
      print(data);
      return MarriedBeforeModel.fromJson(data);
    } else {
      print(response.statusMessage);
      return MarriedBeforeModel();
    }
  }

  Future<DivorceStatusModel> getDivorceStatus() async {
    getAuthorizationToken();

    Response response = await api.dio.post(
      'fetch-divorce-status',
    );

    if (response.statusCode == 200) {
      var data = response.data;
      print(data);
      return DivorceStatusModel.fromJson(data);
    } else {
      print(response.statusMessage);
      return DivorceStatusModel();
    }
  }

  Future<ChildrenWithModel> getChildrenWith() async {
    getAuthorizationToken();

    Response response = await api.dio.post(
      'fetch-childrenwith',
    );

    if (response.statusCode == 200) {
      var data = response.data;
      print(data);
      return ChildrenWithModel.fromJson(data);
    } else {
      print(response.statusMessage);
      return ChildrenWithModel();
    }
  }

  Future<SamajModel> getSamaj() async {
    getAuthorizationToken();

    var headers = {
      'Authorization': 'Bearer $authorizationToken',
    };
    Response response = await api.dio.post('fetch-samaj',
        options: Options(
          headers: headers,
        ));

    if (response.statusCode == 200) {
      var data = response.data;
      print(data);
      return SamajModel.fromJson(data);
    } else {
      print(response.statusMessage);
      return SamajModel();
    }
  }

  Future<WorkAfterMarriageModel> getWorkMarriage() async {
    getAuthorizationToken();

    Response response = await api.dio.post(
      'fetch-workmarriage',
    );

    if (response.statusCode == 200) {
      var data = response.data;
      print(data);
      return WorkAfterMarriageModel.fromJson(data);
    } else {
      print(response.statusMessage);
      return WorkAfterMarriageModel();
    }
  }

  Future<User?> fetchProfile() async {
    try {
      getAuthorizationToken();

      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      Response response = await api.dio.post('fetch-profile',
          options: Options(
            headers: headers,
          ));
      if (response.statusCode == 200) {
        var data = response.data;
        log('asdadasd ${data.runtimeType} ${data['data']}');
        return User.fromJson(data["data"]);
      } else {
        return null;
      }
    } catch (error) {
      print('error $error');
      return null;
    }
  }

  Future postDeleteProfileApi() async {
    try {
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };
      Response response = await api.dio.post(
        'delete-account',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        debugPrint(data.toString());
        print('asdadasd ${data.runtimeType} ${data['data'].runtimeType}');

        return data;
      } else {
        return {};
      }
    } catch (error) {
      debugPrint(error.toString());
      return {};
    }
  }

  Future<String> editProfile({
    required String profession,
    required String compName,
    required String compType,
    required String incomeLakh,
    required String marriedBrother,
    required String unmarriedBrother,
    required String marriedSister,
    required String unmarriedSister,
    required String altContactName,
    required String alterCnctNum,
    required String fullPhoto,
    required String facePhoto,
    required String briefFatherProfession,
    required String sameGothra,
    required String matchGanna,
    required String isManglik,
    required String marryManglik,
    required String olderBy,
    required String youngerBy,
    required String bridebudget,
    required String groombudget,
    required String workAftrMarrige,
    required String numYraddrs,
    required String ownrent,
    required String marriedBfor,
    required String resAddress,
  }) async {
    try {
      getAuthorizationToken();
      var data = FormData.fromMap({
        'profession': profession,
        'compName': compName,
        'compType': compType,
        'incomeLakh': incomeLakh,
        'marriedbrother': marriedBrother,
        'unmarriedbrother': unmarriedBrother,
        'marriedsister': marriedSister,
        'unmarriedsister': unmarriedSister,
        'altContactName': altContactName,
        'alterCnctNum': alterCnctNum,
        'resAddress': resAddress,
        'numYraddrs': numYraddrs,
        'ownrent': ownrent,
        'marriedBfor': marriedBfor,
        /* 'divorceStatus': divorceStatus,
        'children': children,
        'childrenWith': childrenWith,*/
        'sameGothra': sameGothra,
        'matchGanna': matchGanna,
        'isManglik': isManglik,
        'marryManglik': marryManglik,
        'olderBy': olderBy,
        'youngerBy': youngerBy,
        'bridebudget': bridebudget,
        'groombudget': groombudget,
        'workAftrMarrige': workAftrMarrige,
        //'resaftrMarrige':  resaftrMarrige,
        'brief_father_profession': briefFatherProfession,
        /* 'fullPhoto': fullPhoto.isEmpty
            ? ''
            : await MultipartFile.fromFile(
                fullPhoto,
                filename: fullPhoto.split('/').last,
              ),
        'facePhoto': facePhoto.isEmpty
            ? ''
            : await MultipartFile.fromFile(
                facePhoto,
                filename: facePhoto.split('/').last,
              ),*/
      });
      print({
        'profession': profession,
        'compName': compName,
        'compType': compType,
        'incomeLakh': incomeLakh,
        'marriedbrother': marriedBrother,
        'unmarriedbrother': unmarriedBrother,
        'marriedsister': marriedSister,
        'unmarriedsister': unmarriedSister,
        'altContactName': altContactName,
        'alterCnctNum': alterCnctNum,
        'resAddress': resAddress,
        'numYraddrs': numYraddrs,
        'ownrent': ownrent,
        'marriedBfor': marriedBfor,
        'sameGothra': sameGothra,
        'matchGanna': matchGanna,
        'isManglik': isManglik,
        'marryManglik': marryManglik,
        'olderBy': olderBy,
        'youngerBy': youngerBy,
        'bridebudget': bridebudget,
        'groombudget': groombudget,
        'workAftrMarrige': workAftrMarrige,
        'brief_father_profession': briefFatherProfession,
      }.toString());
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      Response response = await api.dio.post(
        'update-profile',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;

        print('Response Type: ${data.runtimeType}, Data: ${data['data']}');
        print('Response Type: ${data.runtimeType}, Data: ${data}');
        return data["msg"].toString();
      } else {
        return "";
      }
    } catch (error) {
      print('Error: $error');
      return "";
    }
  }

  Future<String> editProfilePhoto({
    required String fullPhoto,
    required String facePhoto,
  }) async {
    try {
      getAuthorizationToken();
      var data = FormData.fromMap({
        'fullPhoto': fullPhoto.isEmpty
            ? ''
            : await MultipartFile.fromFile(
                fullPhoto,
                filename: fullPhoto.split('/').last,
              ),
        'facePhoto': facePhoto.isEmpty
            ? ''
            : await MultipartFile.fromFile(
                facePhoto,
                filename: facePhoto.split('/').last,
              ),
      });
      print({
        'fullPhoto': fullPhoto.isEmpty
            ? ''
            : await MultipartFile.fromFile(
                fullPhoto,
                filename: fullPhoto.split('/').last,
              ),
        'facePhoto': facePhoto.isEmpty
            ? ''
            : await MultipartFile.fromFile(
                facePhoto,
                filename: facePhoto.split('/').last,
              ),
      });
      print(data);
      print('update-profile-image');
      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      Response response = await api.dio.post(
        'update-profile-image',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        print('editProfilePhoto Response Data: ${data}');
        print(
            'editProfilePhoto Response Type: ${data.runtimeType}, Data: ${data['data']}');
        return data["msg"].toString();
      } else {
        return "";
      }
    } catch (error) {
      print('editProfilePhoto Error: $error');
      return "";
    }
  }

  Future<String> insertFeedback({
    required String profileId,
    required String description,
  }) async {
    try {
      getAuthorizationToken();
      print(jsonEncode({
        'to_profile_id': profileId,
        'description': description,
      }));
      var data = FormData.fromMap({
        'to_profile_id': profileId,
        'description': description,
      });

      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      Response response = await api.dio.post(
        'create-feedback',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        print('Success : ${response.data}');
        return data == null
            ? ''
            : data['msg'] == null
                ? ''
                : data['msg'].toString();
      } else {
        print('Success : ${response.statusMessage}');
        return '';
      }
    } catch (error) {
      print('error $error');
      return '';
    }
  }

  Future<String> insertComplainFeedback({
    required String profileId,
    required String description,
  }) async {
    try {
      getAuthorizationToken();
      print(jsonEncode({
        'to_profile_id': profileId,
        'description': description,
      }));
      var data = FormData.fromMap({
        'to_profile_id': profileId,
        'description': description,
      });

      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      Response response = await api.dio.post(
        'create-feedback',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        print('Success : ${response.data}');
        return data == null
            ? ''
            : data['msg'] == null
                ? ''
                : data['msg'].toString();
      } else {
        print('Success : ${response.statusMessage}');
        return '';
      }
    } catch (error) {
      print('error $error');
      return '';
    }
  }

  Future<List> getGotraDataListCommunityWise({
    required String comunityId,
  }) async {
    try {
      getAuthorizationToken();
      var data = FormData.fromMap({
        'community': comunityId,
      });
      Response response = await api.dio.post(
        'gotra',
        data: data,
      );
      print(response.data);
      if (response.statusCode == 200) {
        var data = response.data;
        return data == null ? [] : data['data'] ?? [];
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List<String>> getGotraDataList() async {
    try {
      getAuthorizationToken();
      var headers = {'Authorization': 'Bearer $authorizationToken'};
      Response response = await api.dio.post(
        'fetch-gotra-filter',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        List<String> dataList = [];
        if (data != null) {
          for (int i = 0; i < data["data"].length; i++) {
            dataList.add(data["data"][i]["gotra_name"]);
          }
        }
        return dataList;
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<List> getEducationDataList() async {
    try {
      getAuthorizationToken();
      // var data = FormData.fromMap({
      //   'school_id': schoolId,
      //   'current_std': currentStd,
      // });
      var headers = {'Authorization': 'Bearer $authorizationToken'};
      Response response = await api.dio.post(
        'education',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        return data == null ? [] : data['data'] ?? [];
      } else {
        return [];
      }
    } catch (error) {
      return [];
    }
  }

  Future<Map> newSignup({
    required String fname,
    required String gender,
    required String dobs,
    required String birthtime,
    required String placeofBirth,
    required String heightFeet,
    required String heightInch,
    required String email,
    required String eduqualification,
    required String eduqualification_other,
    required String profession,
    required String otherProfession,
    required String businessName,
    required String businessType,
    required String compName,
    required String compType,
    required String incomeLakh,
    required String profile_physical_disablity,
    required String fatherName,
    required String motherName,
    required String community,
    required String gotra,
    required String profile_marry_in_comunity,
    required String marriedbrother,
    required String unmarriedbrother,
    required String marriedsister,
    required String unmarriedsister,
    required String sameGothra,
    required String matchGanna,
    required String isManglik,
    required String marryManglik,
    required String mainContactName,
    required String mainContactNum,
    required String altContactName,
    required String alterCnctNum,
    required String resAddress,
    required String numYraddrs,
    required String ownrent,
    required String marriedBfor,
    required String divorceStatus,
    required String children,
    required String childrenWith,
    required String olderBy,
    required String youngerBy,
    required String resaftrMarrige,
    required String bridebudget,
    required String groombudget,
    required String workAftrMarrige,
    required String brief_father_profession,
    required String fullPhoto,
    required String facePhoto,
  }) async {
    try {
      getAuthorizationToken();
      var data = FormData.fromMap({
        'fname': fname,
        'gender': gender,
        'dobs': dobs,
        'birthtime': birthtime,
        'placeofBirth': placeofBirth,
        'heightFeet': heightFeet,
        'heightInch': heightInch,
        'email': email,
        'eduqualification': eduqualification,
        'eduqualification_other': eduqualification_other,
        'profession': profession,
        'otherProfession': otherProfession,
        'businessName': businessName,
        'businessType': businessType,
        'compName': compName,
        'compType': compType,
        'incomeLakh': incomeLakh,
        'profile_physical_disablity': profile_physical_disablity,
        'fatherName': fatherName,
        'motherName': motherName,
        'community': community,
        'gotra': gotra,
        'profile_marry_in_comunity': profile_marry_in_comunity,
        'marriedbrother': marriedbrother,
        'unmarriedbrother': unmarriedbrother,
        'marriedsister': marriedsister,
        'unmarriedsister': unmarriedsister,
        'sameGothra': sameGothra,
        'matchGanna': matchGanna,
        'isManglik': isManglik,
        'marryManglik': marryManglik,
        'mainContactName': mainContactName,
        'mainContactNum': mainContactNum,
        'altContactName': altContactName,
        'alterCnctNum': alterCnctNum,
        'resAddress': resAddress,
        'numYraddrs': numYraddrs,
        'ownrent': ownrent,
        'marriedBfor': marriedBfor,
        'divorceStatus': divorceStatus,
        'children': children,
        'childrenWith': childrenWith,
        'olderBy': olderBy,
        'youngerBy': youngerBy,
        'resaftrMarrige': resaftrMarrige,
        'bridebudget': bridebudget,
        'groombudget': groombudget,
        'workAftrMarrige': workAftrMarrige,
        'brief_father_profession': brief_father_profession,
        'fullPhoto': fullPhoto.isEmpty
            ? ''
            : await MultipartFile.fromFile(
                fullPhoto,
                filename: fullPhoto.split('/').isEmpty
                    ? null
                    : fullPhoto.split('/').last,
              ),
        'facePhoto': facePhoto.isEmpty
            ? ''
            : await MultipartFile.fromFile(
                facePhoto,
                filename: facePhoto.split('/').isEmpty
                    ? null
                    : facePhoto.split('/').last,
              ),
      });
      log(data.files.toString());
      log(data.fields.toString());
      Response response;
      /* Response response = await api.dio.post(
        'signup',
        data: data,
      );*/

      /*if (response.statusCode == 200) {
        var data = response.data;
        print('Success: ${response.data}');
        return data;
      } else {
        print('Error: ${response.statusCode} ${response.statusMessage}');
        return {};
      }*/
      return {};
    } catch (error) {
      print('Error: $error');
      return {};
    }
  }

  Future<Map> loginUser({
    required String profileId,
    required String password,
    required String deviceId,
  }) async {
    try {
      getAuthorizationToken();
      var data = FormData.fromMap({
        'profile_id': profileId,
        'password': password,
        'device_id': deviceId,
      });
      print('aDadadd 123123 ${data.fields}');
      Response response = await api.dio.post(
        'login',
        data: data,
      );
      print('aDadadd ${response.statusCode}');
      print('aDadadd ${response.data}');
      if (response.statusCode == 200) {
        var data = response.data;
        log('Success: ${response.data}');
        return data;
      } else {
        print('Error== ${response.statusMessage}');
        return {};
      }
    } catch (error) {
      print('Error--: $error');
      return {};
    }
  }

  Future<List<MembersDataModel>> getAllShortlistedDataList() async {
    getAuthorizationToken();

    var headers = {
      'Authorization': 'Bearer $authorizationToken',
    };

    Response response = await api.dio.post(
      'fetch-shortlist-profile',
      options: Options(
        headers: headers,
      ),
    );
    if (response.statusCode == 200) {
      var data = response.data;
      print('asdadasd ${data.runtimeType} ${data['data'].runtimeType}');
      return List.from(data == null
          ? []
          : data['data'] == null
              ? []
              : data['data'].map((e) => MembersDataModel.fromJson(e)).toList());
    } else {
      return [];
    }
  }

  Future<Map> setMyShortlistProfile({
    required String profileId,
  }) async {
    try {
      getAuthorizationToken();
      var data = FormData.fromMap({
        'shortlisted_profile_id': profileId,
      });

      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      print('aDadadd 123123 ${data.fields}');
      Response response = await api.dio.post(
        'update-set-shortlist-profile',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      print('aDadadd ${response.statusCode}');
      if (response.statusCode == 200) {
        var data = response.data;
        print('Success: ${response.data}');
        return data;
      } else {
        print('Error== ${response.statusMessage}');
        return {};
      }
    } catch (error) {
      print('Error--: $error');
      return {};
    }
  }

  Future<Map> unSetMyShortlistProfile({
    required String profileId,
  }) async {
    try {
      getAuthorizationToken();
      var data = FormData.fromMap({
        'shortlisted_profile_id': profileId,
      });

      var headers = {
        'Authorization': 'Bearer $authorizationToken',
      };

      print('aDadadd 123123 ${data.fields}');
      Response response = await api.dio.post(
        'update-un-shortlist-profile',
        data: data,
        options: Options(
          headers: headers,
        ),
      );
      print('aDadadd ${response.statusCode}');
      if (response.statusCode == 200) {
        var data = response.data;
        print('Success: ${response.data}');
        return data;
      } else {
        print('Error== ${response.statusMessage}');
        return {};
      }
    } catch (error) {
      print('Error--: $error');
      return {};
    }
  }
}
