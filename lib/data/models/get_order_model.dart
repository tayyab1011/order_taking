// To parse this JSON data, do
//
//     final getOrderModel = getOrderModelFromJson(jsonString);

import 'dart:convert';

GetOrderModel getOrderModelFromJson(String str) => GetOrderModel.fromJson(json.decode(str));

String getOrderModelToJson(GetOrderModel data) => json.encode(data.toJson());

class GetOrderModel {
    int? orderId;
    DateTime? orderDate;
    dynamic sessionId;
    dynamic orderMode;
    int? tableNo;
    int? covers;
    dynamic waiterNo;
    dynamic waiterName;
    dynamic riderNo;
    dynamic riderName;
    dynamic bankAccountNo;
    dynamic cardNo;
    dynamic cnic;
    dynamic customerId;
    String? customerName;
    String? customerCellNo;
    dynamic customerAddress;
    dynamic note;
    dynamic paymentMode;
    dynamic grossAmt;
    dynamic serviceCharges;
    dynamic salesTax;
    dynamic otherCharges;
    dynamic deliveryCharges;
    dynamic dicountAmt;
    dynamic totalAmt;
    dynamic paidAmt;
    dynamic cashAmt;
    dynamic crCAmt;
    dynamic oStartBy;
    DateTime? orderStart;
    dynamic oEndBy;
    dynamic orderEnd;
    int? branchId;
    bool? isClosed;
    dynamic tablename;
    bool? isNew;
    List<BodyList>? bodyList;

    GetOrderModel({
        this.orderId,
        this.orderDate,
        this.sessionId,
        this.orderMode,
        this.tableNo,
        this.covers,
        this.waiterNo,
        this.waiterName,
        this.riderNo,
        this.riderName,
        this.bankAccountNo,
        this.cardNo,
        this.cnic,
        this.customerId,
        this.customerName,
        this.customerCellNo,
        this.customerAddress,
        this.note,
        this.paymentMode,
        this.grossAmt,
        this.serviceCharges,
        this.salesTax,
        this.otherCharges,
        this.deliveryCharges,
        this.dicountAmt,
        this.totalAmt,
        this.paidAmt,
        this.cashAmt,
        this.crCAmt,
        this.oStartBy,
        this.orderStart,
        this.oEndBy,
        this.orderEnd,
        this.branchId,
        this.isClosed,
        this.tablename,
        this.isNew,
        this.bodyList,
    });

    factory GetOrderModel.fromJson(Map<String, dynamic> json) => GetOrderModel(
        orderId: json["OrderID"] is int ? json["OrderID"] : (json["OrderID"] as double?)?.toInt(),
        orderDate: json["OrderDate"] == null ? null : DateTime.parse(json["OrderDate"]),
        sessionId: json["SessionID"],
        orderMode: json["OrderMode"],
         tableNo: json["TableNo"] is int ? json["TableNo"] : (json["TableNo"] as double?)?.toInt(),
        covers: json["Covers"],
        waiterNo: json["WaiterNo"],
        waiterName: json["WaiterName"],
        riderNo: json["RiderNo"],
        riderName: json["RiderName"],
        bankAccountNo: json["BankAccountNo"],
        cardNo: json["CardNo"],
        cnic: json["CNIC"],
        customerId: json["CustomerID"],
        customerName: json["CustomerName"],
        customerCellNo: json["CustomerCellNo"],
        customerAddress: json["CustomerAddress"],
        note: json["Note"],
        paymentMode: json["PaymentMode"],
        grossAmt: json["GrossAmt"],
        serviceCharges: json["ServiceCharges"],
        salesTax: json["SalesTax"],
        otherCharges: json["OtherCharges"],
        deliveryCharges: json["DeliveryCharges"],
        dicountAmt: json["DicountAmt"],
        totalAmt: json["TotalAmt"],
        paidAmt: json["PaidAmt"],
        cashAmt: json["CashAmt"],
        crCAmt: json["CrCAmt"],
        oStartBy: json["OStartBy"],
        orderStart: json["OrderStart"] == null ? null : DateTime.parse(json["OrderStart"]),
        oEndBy: json["OEndBy"],
        orderEnd: json["OrderEnd"],
        branchId: json["BranchID"],
        isClosed: json["IsClosed"],
        tablename: json["Tablename"],
        isNew: json["IsNew"],
        bodyList: json["BodyList"] == null ? [] : List<BodyList>.from(json["BodyList"]!.map((x) => BodyList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "OrderDate": orderDate?.toIso8601String(),
        "SessionID": sessionId,
        "OrderMode": orderMode,
        "TableNo": tableNo,
        "Covers": covers,
        "WaiterNo": waiterNo,
        "WaiterName": waiterName,
        "RiderNo": riderNo,
        "RiderName": riderName,
        "BankAccountNo": bankAccountNo,
        "CardNo": cardNo,
        "CNIC": cnic,
        "CustomerID": customerId,
        "CustomerName": customerName,
        "CustomerCellNo": customerCellNo,
        "CustomerAddress": customerAddress,
        "Note": note,
        "PaymentMode": paymentMode,
        "GrossAmt": grossAmt,
        "ServiceCharges": serviceCharges,
        "SalesTax": salesTax,
        "OtherCharges": otherCharges,
        "DeliveryCharges": deliveryCharges,
        "DicountAmt": dicountAmt,
        "TotalAmt": totalAmt,
        "PaidAmt": paidAmt,
        "CashAmt": cashAmt,
        "CrCAmt": crCAmt,
        "OStartBy": oStartBy,
        "OrderStart": orderStart?.toIso8601String(),
        "OEndBy": oEndBy,
        "OrderEnd": orderEnd,
        "BranchID": branchId,
        "IsClosed": isClosed,
        "Tablename": tablename,
        "IsNew": isNew,
        "BodyList": bodyList == null ? [] : List<dynamic>.from(bodyList!.map((x) => x.toJson())),
    };
}

class BodyList {
    int? orderId;
    dynamic orderDate;
    int? menuId;
    String? menuName;
    double? quantity;
    double? rate;
    dynamic isAutoPrint;
    dynamic instructions;
    dynamic entryBy;
    DateTime? entryDateTime;
    dynamic isExecuted;
    dynamic executedDateTime;
    dynamic executedBy;
    dynamic branchId;
    int? ordersBodyId;
    bool? isNew;
    dynamic chefName;
    int? chefId;
    String? menuType;

    BodyList({
        this.orderId,
        this.orderDate,
        this.menuId,
        this.menuName,
        this.quantity,
        this.rate,
        this.isAutoPrint,
        this.instructions,
        this.entryBy,
        this.entryDateTime,
        this.isExecuted,
        this.executedDateTime,
        this.executedBy,
        this.branchId,
        this.ordersBodyId,
        this.isNew,
        this.chefName,
        this.chefId,
        this.menuType,
    });

    factory BodyList.fromJson(Map<String, dynamic> json) => BodyList(
        orderId: json["OrderID"] is int ? json["OrderID"] : (json["OrderID"] as double?)?.toInt(),
        orderDate: json["OrderDate"],
        menuId: json["MenuID"],
        menuName: json["MenuName"],
        quantity: json["Quantity"],
        rate: json["Rate"],
        isAutoPrint: json["IsAutoPrint"],
        instructions: json["Instructions"],
        entryBy: json["EntryBy"],
        entryDateTime: json["EntryDateTime"] == null ? null : DateTime.parse(json["EntryDateTime"]),
        isExecuted: json["IsExecuted"],
        executedDateTime: json["ExecutedDateTime"],
        executedBy: json["ExecutedBy"],
        branchId: json["BranchID"],
        ordersBodyId: json["OrdersBodyID"],
        isNew: json["IsNew"],
        chefName: json["ChefName"],
        chefId: json["ChefID"],
        menuType: json["MenuType"],
    );

    Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "OrderDate": orderDate,
        "MenuID": menuId,
        "MenuName": menuName,
        "Quantity": quantity,
        "Rate": rate,
        "IsAutoPrint": isAutoPrint,
        "Instructions": instructions,
        "EntryBy": entryBy,
        "EntryDateTime": entryDateTime?.toIso8601String(),
        "IsExecuted": isExecuted,
        "ExecutedDateTime": executedDateTime,
        "ExecutedBy": executedBy,
        "BranchID": branchId,
        "OrdersBodyID": ordersBodyId,
        "IsNew": isNew,
        "ChefName": chefName,
        "ChefID": chefId,
        "MenuType": menuType,
    };
}
