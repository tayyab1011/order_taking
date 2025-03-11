// To parse this JSON data, do
//
//     final catagoriesModel = catagoriesModelFromJson(jsonString);

import 'dart:convert';

List<CatagoriesModel> catagoriesModelFromJson(String str) => List<CatagoriesModel>.from(json.decode(str).map((x) => CatagoriesModel.fromJson(x)));

String catagoriesModelToJson(List<CatagoriesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CatagoriesModel {
    int? catId;
    String? name;

    CatagoriesModel({
        this.catId,
        this.name,
    });

    factory CatagoriesModel.fromJson(Map<String, dynamic> json) => CatagoriesModel(
        catId: json["CatID"],
        name: json["Name"],
    );

    Map<String, dynamic> toJson() => {
        "CatID": catId,
        "Name": name,
    };
}
