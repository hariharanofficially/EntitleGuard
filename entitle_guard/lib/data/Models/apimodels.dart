import 'dart:convert';

otpverify otpverifyJson(String str) => otpverify.fromJson(json.decode(str));
String otpverifyToJson(otpverify data) => json.encode(data.toJson());

class otpverify {
  String email;
  String otp;

  otpverify({
    required this.email,
    required this.otp,
  });

  factory otpverify.fromJson(Map<String, dynamic> json) => otpverify(
        email: json["email"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
      };

  String get emails => email;
  String get otps => otp;
}

signup signupJson(String str) => signup.fromJson(json.decode(str));
String signupToJson(signup data) => json.encode(data.toJson());

class signup {
  String email;
  String firstName;
  String lastName;

  signup(
      {required this.email, required this.firstName, required this.lastName});

  factory signup.fromJson(Map<String, dynamic> json) => signup(
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
      };

  String get emails => email;
  String get firstNames => firstName;
  String get lastNames => lastName;
}

Login usersLoginJson(String str) => Login.fromJson(json.decode(str));
String usersLoginToJson(Login data) => json.encode(data.toJson());

class Login {
  String email;
  String jwt;
  int userId;

  Login({required this.email, required this.jwt, required this.userId});

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        email: json["data"]["userInfo"]["email"],
        userId: json["data"]["userInfo"]["id"],
        jwt: json["data"]["jwt"],
      );

  Map<String, dynamic> toJson() =>
      {"email": email, "jwt": jwt, "userId": userId};

  String get emails => email;
}

Bill billfromJson(String str) => Bill.fromJson(json.decode(str));
String billToJson(Bill data) => json.encode(data.toJson());

class Bill {
  List<BillItems> billItems;
  int? id;
  String? merchantName;
  String? purchaseDate;
  double? totalAmount;
  int? userId;

  Bill(
      {required this.billItems,
      this.id,
      this.merchantName,
      this.purchaseDate,
      this.totalAmount,
      this.userId});

  factory Bill.fromJson(Map<String, dynamic> json) {

    List<BillItems> items = [];
    BillItems item = new BillItems();
    items.add(item);

    return Bill(
      id: json['id'],
      merchantName: json["merchantName"],
      purchaseDate: json["purchaseDate"],
      totalAmount: json["totalAmount"],

      billItems: (json["billItems"] != null)
          ? List<BillItems>.from(
              json["billItems"].map((item) => BillItems.fromJson(item)))
          : [],

      //billItems: items
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "merchantName": merchantName,
        "purchaseDate": purchaseDate,
        "totalAmount": totalAmount,
        "billItemsDtos": billItems,
      };
}

BillItems BillItemsFromJson(String str) => BillItems.fromJson(json.decode(str));
String BillItemsToJson(BillItems data) => json.encode(data.toJson());

class BillItems {
  String? brand;
  double? cost;
  int? id;
  String? product;
  String? productCode;
  int? quantity;
  String? type;
  String? warantyEndDate;
  String? warantyStartDate;
  bool? extendedWarranty;
  int? extendedWarrantyMonths;

  BillItems(
      {this.brand,
      this.cost,
      this.id,
      this.product,
      this.productCode,
      this.quantity,
      this.type,
      this.warantyEndDate,
      this.warantyStartDate,
      this.extendedWarranty,
      this.extendedWarrantyMonths});
  factory BillItems.fromJson(Map<String, dynamic> json) => BillItems(
        id: json['id'],
        brand: json["brand"],
        cost: json["cost"],
        product: json["product"],
        productCode: json["productCode"],
        quantity: json["quantity"],
        type: json["type"],
        warantyEndDate: json["warantyEndDate"],
        warantyStartDate: json["warantyStartDate"],
        extendedWarranty: json["extendedWarranty"],
       extendedWarrantyMonths: json["extendedWarrantyMonths"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "brand": brand,
        "cost": cost,
        "product": product,
        "productCode": productCode,
        "quantity": quantity,
        "type": type,
        "warantyEndDate": warantyEndDate,
        "warantyStartDate": warantyStartDate,
        "extendedWarranty" : extendedWarranty,
        "extendedWarrantyMonths" : extendedWarrantyMonths
      };
}

Updatewarrenty updatewarrentyFromJson(String str) =>
    Updatewarrenty.fromJson(json.decode(str));
String updatewarrentyToJson(Updatewarrenty data) => json.encode(data.toJson());

class Updatewarrenty {
  int? id;
  bool? extendedWarranty;
  String? warrantyEndDate;
  String? extendedWarrantyMonths;

  Updatewarrenty(
      {this.id,
      this.extendedWarranty,
      this.warrantyEndDate,
      this.extendedWarrantyMonths});
  factory Updatewarrenty.fromJson(Map<String, dynamic> json) => Updatewarrenty(
        id: json['billItemId'],
        extendedWarranty: json["extendedWarranty"],
        warrantyEndDate: json["warrantyEndDate"],
        extendedWarrantyMonths: json["extendedWarrantyMonths"],
      );

  Map<String, dynamic> toJson() => {
        "billItemId": id,
        "extendedWarranty": extendedWarranty,
        "warrantyEndDate": warrantyEndDate,
        "extendedWarrantyMonths": extendedWarrantyMonths,
      };
}

class Getbilldetails {
  List<Bill>? bills;

  Getbilldetails({this.bills});

  factory Getbilldetails.fromJson(Map<String, dynamic> json) {
    return Getbilldetails(
      bills: (json["data"] != null)
          ? List<Bill>.from(json["data"].map((item) => Bill.fromJson(item)))
          : [],
    );
  }
}
