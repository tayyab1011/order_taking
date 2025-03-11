class CartItem {
  String? productName;
  String? cusName;
  String? tableId;
  String? tableName;
  int? covers;
  double? rate;
  String? quantity;
  String? menuType;
  String? chief;
  String? instructions;
  String? orderType;
  String? menuId;
  String? mobileNo;
  String? address;
  String? orderMode;

  CartItem({
    this.mobileNo,this.address,
    this.productName,
    this.orderMode,
    this.cusName,
    this.tableId,
    this.tableName,
    this.covers,
    this.rate,
    this.quantity,
    this.orderType,
    this.menuType,
    this.chief,
    this.menuId,
    this.instructions,
  });

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'cusName': cusName,
      'tableId': tableId,
      'tableName': tableName,
      'covers': covers,
      'rate': rate,
      'quantity': quantity,
      'menuType': menuType,
      'chief': chief,
      'instructions': instructions,
      'orderType':orderType,
      'menuId':menuId,
      'address':address,
      'mobileNo':mobileNo,
      'orderMode':orderMode
    };
  }

  // Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productName: json['productName'],
      cusName: json['cusName'],
      tableId: json['tableId'],
      tableName: json['tableName'],
      covers: json['covers'],
      rate: (json['rate'] as num?)?.toDouble(),
      quantity: json['quantity'],
      menuType: json['menuType'],
      chief: json['chief'],
      instructions: json['instructions'],
      orderType: json['orderType'],
      menuId: json['menuId'],
      address: json['address'],
      mobileNo: json['mobileNo'],
      orderMode: json['orderMode'],
    );
  }
}
