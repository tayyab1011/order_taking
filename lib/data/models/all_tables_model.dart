// To parse this JSON data, do
//
//     final allTablesModel = allTablesModelFromJson(jsonString);

import 'dart:convert';

List<AllTablesModel> allTablesModelFromJson(String str) => List<AllTablesModel>.from(json.decode(str).map((x) => AllTablesModel.fromJson(x)));

String allTablesModelToJson(List<AllTablesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllTablesModel {
    int? tableId;
    int? locationId;
    String? tableName;

    AllTablesModel({
        this.tableId,
        this.locationId,
        this.tableName,
    });

    factory AllTablesModel.fromJson(Map<String, dynamic> json) => AllTablesModel(
        tableId: json["TableID"],
        locationId: json["LocationID"],
        tableName: json["TableName"],
    );

    Map<String, dynamic> toJson() => {
        "TableID": tableId,
        "LocationID": locationId,
        "TableName": tableName,
    };
}
