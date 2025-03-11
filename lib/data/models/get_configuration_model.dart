// To parse this JSON data, do
//
//     final getCpnfigurationModel = getCpnfigurationModelFromJson(jsonString);

import 'dart:convert';

GetCpnfigurationModel getCpnfigurationModelFromJson(String str) => GetCpnfigurationModel.fromJson(json.decode(str));

String getCpnfigurationModelToJson(GetCpnfigurationModel data) => json.encode(data.toJson());

class GetCpnfigurationModel {
    int? company;
    DateTime? yearStart;
    DateTime? yearEnd;
    int? srno;
    bool? isDirectPrinting;
    num? serviceCharges;
    num? salesTax;
    dynamic logoImage;
    String? phoneNumber;
    String? address;
    String? companyName;
    num? gstNo;
    num? salesTaxCc;
    bool? canBillPrint;

    GetCpnfigurationModel({
        this.company,
        this.yearStart,
        this.yearEnd,
        this.srno,
        this.isDirectPrinting,
        this.serviceCharges,
        this.salesTax,
        this.logoImage,
        this.phoneNumber,
        this.address,
        this.companyName,
        this.gstNo,
        this.salesTaxCc,
        this.canBillPrint,
    });

    factory GetCpnfigurationModel.fromJson(Map<String, dynamic> json) => GetCpnfigurationModel(
        company: json["Company"],
        yearStart: json["YearStart"] == null ? null : DateTime.parse(json["YearStart"]),
        yearEnd: json["YearEnd"] == null ? null : DateTime.parse(json["YearEnd"]),
        srno: json["Srno"],
        isDirectPrinting: json["IsDirectPrinting"],
        serviceCharges: json["ServiceCharges"],
        salesTax: json["SalesTax"],
        logoImage: json["LogoImage"],
        phoneNumber: json["PhoneNumber"],
        address: json["Address"],
        companyName: json["CompanyName"],
        gstNo: json["GstNo"],
        salesTaxCc: json["SalesTaxCC"],
        canBillPrint: json["CanBillPrint"],
    );

    Map<String, dynamic> toJson() => {
        "Company": company,
        "YearStart": yearStart?.toIso8601String(),
        "YearEnd": yearEnd?.toIso8601String(),
        "Srno": srno,
        "IsDirectPrinting": isDirectPrinting,
        "ServiceCharges": serviceCharges,
        "SalesTax": salesTax,
        "LogoImage": logoImage,
        "PhoneNumber": phoneNumber,
        "Address": address,
        "CompanyName": companyName,
        "GstNo": gstNo,
        "SalesTaxCC": salesTaxCc,
        "CanBillPrint": canBillPrint,
    };
}
