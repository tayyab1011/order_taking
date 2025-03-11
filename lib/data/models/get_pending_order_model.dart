// To parse this JSON data, do
//
//     final getPendingOrders = getPendingOrdersFromJson(jsonString);

import 'dart:convert';

List<GetPendingOrders> getPendingOrdersFromJson(String str) => List<GetPendingOrders>.from(json.decode(str).map((x) => GetPendingOrders.fromJson(x)));

String getPendingOrdersToJson(List<GetPendingOrders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetPendingOrders {
    String? orderId;
    String? tablename;
    String? totalAmt;
    String? orderType;
    String? customerName;
    String? customerAddress;
    String? customerCellNo;
    String? waiterName;
    String? riderName;
    bool? isTransfered;

    GetPendingOrders({
        this.orderId,
        this.tablename,
        this.totalAmt,
        this.orderType,
        this.customerName,
        this.customerAddress,
        this.customerCellNo,
        this.waiterName,
        this.riderName,
        this.isTransfered,
    });

    factory GetPendingOrders.fromJson(Map<String, dynamic> json) => GetPendingOrders(
        orderId: json["OrderId"],
        tablename: json["Tablename"],
        totalAmt: json["TotalAmt"],
        orderType: json["OrderType"],
        customerName: json["CustomerName"],
        customerAddress: json["CustomerAddress"],
        customerCellNo: json["CustomerCellNo"],
        waiterName: json["WaiterName"],
        riderName: json["RiderName"],
        isTransfered: json["IsTransfered"],
    );

    Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "Tablename": tablename,
        "TotalAmt": totalAmt,
        "OrderType": orderType,
        "CustomerName": customerName,
        "CustomerAddress": customerAddress,
        "CustomerCellNo": customerCellNo,
        "WaiterName": waiterName,
        "RiderName": riderName,
        "IsTransfered": isTransfered,
    };
}
