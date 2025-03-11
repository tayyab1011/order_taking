import 'dart:convert';

List<MenuModel> menuModelFromJson(String str) => 
    List<MenuModel>.from(json.decode(str).map((x) => MenuModel.fromJson(x)));

String menuModelToJson(List<MenuModel> data) => 
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MenuModel {
    int? menuId;
    int? cid;
    String? name;
    double? rate;
    bool? isHalfDone;

    MenuModel({
        this.menuId,
        this.cid,
        this.name,
        this.rate,
        this.isHalfDone,
    });

    factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        menuId: json["MenuID"],
        cid: json["Cid"],
        name: json["Name"],
        rate: json["Rate"]?.toDouble(),  // ✅ Convert int to double
        isHalfDone: json["IsHalfDone"],
    );

    Map<String, dynamic> toJson() => {
        "MenuID": menuId,
        "Cid": cid,
        "Name": name,
        "Rate": rate,
        "IsHalfDone": isHalfDone,
    };
}
