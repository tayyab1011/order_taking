import 'dart:convert';

class InvoiceModel {
  final int? orderId;
  final DateTime orderDate;
  final int? branchId;
  final String? orderMode;
  final double? totalAmt;
  final double? tipValue;
  final String? tipType;
  final dynamic discountPer;
  final double? discountAmt;
  final String? companyName;
  final String? address;
  final String? phoneNumber;
  final String? gstNo;
  final String? waiterName;
  final String? trn;
  final String? clientCompanyName;
  final String? clientAddress;
  final String? tableName;
  final String? paymentMode;
  final double? invoiceTax;
  final List<OrderBodyList> orderBodyList;

  InvoiceModel({
    required this.orderId,
    required this.orderDate,
    required this.branchId,
    required this.orderMode,
    required this.totalAmt,
    required this.tipValue,
    required this.tipType,
    required this.discountPer,
    required this.discountAmt,
    required this.companyName,
    required this.address,
    required this.phoneNumber,
    required this.gstNo,
    required this.waiterName,
    required this.trn,
    required this.clientCompanyName,
    required this.clientAddress,
    required this.tableName,
    required this.paymentMode,
    required this.invoiceTax,
    required this.orderBodyList,
  });

  factory InvoiceModel.fromRawJson(String str) =>
      InvoiceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        orderId: json["OrderID"],
        orderDate: DateTime.parse(json["OrderDate"]),
        branchId: json["BranchID"],
        orderMode: json["OrderMode"],
        totalAmt: json["TotalAmt"],
        tipValue: json["TipValue"],
        tipType: json["TipType"],
        discountPer: json["DiscountPer"],
        discountAmt: json["DiscountAmt"],
        companyName: json["CompanyName"],
        address: json["Address"],
        phoneNumber: json["PhoneNumber"],
        gstNo: json["GstNo"],
        waiterName: json["WaiterName"],
        trn: json["TRN"],
        clientCompanyName: json["ClientCompanyName"],
        clientAddress: json["ClientAddress"],
        tableName: json["TableName"],
        paymentMode: json["PaymentMode"],
        invoiceTax: json["InvoiceTax"]?.toDouble(),
        orderBodyList: List<OrderBodyList>.from(
            json["orderBodyList"].map((x) => OrderBodyList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "OrderDate": orderDate.toIso8601String(),
        "BranchID": branchId,
        "OrderMode": orderMode,
        "TotalAmt": totalAmt,
        "TipValue": tipValue,
        "TipType": tipType,
        "DiscountPer": discountPer,
        "DiscountAmt": discountAmt,
        "CompanyName": companyName,
        "Address": address,
        "PhoneNumber": phoneNumber,
        "GstNo": gstNo,
        "WaiterName": waiterName,
        "TRN": trn,
        "ClientCompanyName": clientCompanyName,
        "ClientAddress": clientAddress,
        "TableName": tableName,
        "PaymentMode": paymentMode,
        "InvoiceTax": invoiceTax,
        "orderBodyList":
            List<dynamic>.from(orderBodyList.map((x) => x.toJson())),
      };
}

class OrderBodyList {
  final int menuId;
  final String menuName;
  final double quantity;
  final double rate;
  final dynamic submodifiername;
  final double menuTax;
  final double menuRate;
  final double itemTotal;

  OrderBodyList({
    required this.menuId,
    required this.menuName,
    required this.quantity,
    required this.rate,
    required this.submodifiername,
    required this.menuTax,
    required this.menuRate,
    required this.itemTotal,
  });

  factory OrderBodyList.fromRawJson(String str) =>
      OrderBodyList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderBodyList.fromJson(Map<String, dynamic> json) => OrderBodyList(
        menuId: json["MenuID"],
        menuName: json["MenuName"],
        quantity: json["Quantity"],
        rate: json["Rate"],
        submodifiername: json["submodifiername"],
        menuTax: json["MenuTax"]?.toDouble(),
        menuRate: json["MenuRate"]?.toDouble(),
        itemTotal: json["ItemTotal"],
      );

  Map<String, dynamic> toJson() => {
        "MenuID": menuId,
        "MenuName": menuName,
        "Quantity": quantity,
        "Rate": rate,
        "submodifiername": submodifiername,
        "MenuTax": menuTax,
        "MenuRate": menuRate,
        "ItemTotal": itemTotal,
      };
}
