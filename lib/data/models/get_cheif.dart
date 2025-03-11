// To parse this JSON data, do
//
//     final getCheifModel = getCheifModelFromJson(jsonString);

import 'dart:convert';

List<GetCheifModel> getCheifModelFromJson(String str) => List<GetCheifModel>.from(json.decode(str).map((x) => GetCheifModel.fromJson(x)));

String getCheifModelToJson(List<GetCheifModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCheifModel {
    int? id;
    String? chefName;

    GetCheifModel({
        this.id,
        this.chefName,
    });

    factory GetCheifModel.fromJson(Map<String, dynamic> json) => GetCheifModel(
        id: json["ID"],
        chefName: json["ChefName"],
    );

    Map<String, dynamic> toJson() => {
        "ID": id,
        "ChefName": chefName,
    };
}
