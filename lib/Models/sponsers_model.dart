// To parse this JSON data, do
//
//     final sponseredModel = sponseredModelFromJson(jsonString);

import 'dart:convert';

SponseredModel sponseredModelFromJson(String str) =>
    SponseredModel.fromJson(json.decode(str));

String sponseredModelToJson(SponseredModel data) => json.encode(data.toJson());

class SponseredModel {
  int? code;
  List<SponItem>? data;

  SponseredModel({
    this.code,
    this.data,
  });

  SponseredModel copyWith({
    int? code,
    List<SponItem>? data,
  }) =>
      SponseredModel(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory SponseredModel.fromJson(Map<String, dynamic> json) => SponseredModel(
        code: json["code"],
        data: json["data"] == null
            ? []
            : List<SponItem>.from(
                json["data"]!.map((x) => SponItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SponItem {
  String? image;

  SponItem({
    this.image,
  });

  SponItem copyWith({
    String? image,
  }) =>
      SponItem(
        image: image ?? this.image,
      );

  factory SponItem.fromJson(Map<String, dynamic> json) => SponItem(
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
      };
}
