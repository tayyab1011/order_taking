// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    int? userNo;
    String? userName;
    String? password;
    bool? isAdministrator;
    bool? isActive;
    bool? isSupervisor;
    int? counterId;
    dynamic signature;
    dynamic allUsers;
    int? branchId;
    bool? isCashCounter;
    dynamic userid;
    dynamic issaletax;
    String? dayDates;
    List<dynamic>? userrights;

    LoginModel({
        this.userNo,
        this.userName,
        this.password,
        this.isAdministrator,
        this.isActive,
        this.isSupervisor,
        this.counterId,
        this.signature,
        this.allUsers,
        this.branchId,
        this.isCashCounter,
        this.userid,
        this.issaletax,
        this.dayDates,
        this.userrights,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        userNo: json["UserNo"],
        userName: json["UserName"],
        password: json["Password"],
        isAdministrator: json["IsAdministrator"],
        isActive: json["IsActive"],
        isSupervisor: json["IsSupervisor"],
        counterId: json["CounterID"],
        signature: json["Signature"],
        allUsers: json["AllUsers"],
        branchId: json["BranchID"],
        isCashCounter: json["IsCashCounter"],
        userid: json["userid"],
        issaletax: json["issaletax"],
        dayDates: json["DayDates"],
        userrights: json["userrights"] == null ? [] : List<dynamic>.from(json["userrights"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "UserNo": userNo,
        "UserName": userName,
        "Password": password,
        "IsAdministrator": isAdministrator,
        "IsActive": isActive,
        "IsSupervisor": isSupervisor,
        "CounterID": counterId,
        "Signature": signature,
        "AllUsers": allUsers,
        "BranchID": branchId,
        "IsCashCounter": isCashCounter,
        "userid": userid,
        "issaletax": issaletax,
        "DayDates": dayDates,
        "userrights": userrights == null ? [] : List<dynamic>.from(userrights!.map((x) => x)),
    };
}
