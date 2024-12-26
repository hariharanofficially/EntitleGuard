// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:entitle_guard/data/Models/apimodels.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart'; // Required for getting file basename

//  var urlBase = "https://entitleguard.furtimtechnologies.com";
var urlBase = "https://app.entitleguard.com";
//var urlBase = "http://192.168.1.8:8080";

Future<Login?> login_POST(String email) async {
  try {
    var url = "${urlBase}/unsecure/basiclogin";
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{"email": email}));

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      dynamic resp = json.decode(response.body);
      if (resp["success"] == true) {
        print(response.body);
        print('Login successfull');
        return usersLoginJson(response.body);
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (error) {
    print('An error occurred:$error');
    print('Login failed');
  }
  return null;
}

Future<Login?> signup_POST(String email, String firstName) async {
  try {
    var url = "${urlBase}/unsecure/signup";
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            <String, String>{"email": email, "firstName": firstName}));

    if (response.statusCode == 200) {
      dynamic resp = json.decode(response.body);
      if (resp["success"] == true) {
        print(response.body);
        print('Signup successful');
        return usersLoginJson(response.body);
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (error) {
    print('An error occurred:$error');
    print('Login failed');
  }
  return null;
}

Future<otpverify?> OTP_POST(
    String email, String otp, BuildContext context) async {
  try {
    var Url = "${urlBase}/unsecure/user/otpverify";

    var response = await http.post(Uri.parse(Url),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          "email": email,
          "otp": otp,
        }));

    String responseString = response.body;
    if (response.statusCode == 200) {
      print('OTP succesfull send');
      print(response.body);
      // showDialog(
      //   context: context,
      //   barrierDismissible: true,
      //   builder: (BuildContext dialogContext) {
      //     return MyAlertDialog(
      //       title: 'OTP Send success',
      //     );
      //   },
      // );
      return null;
    }
  } catch (error) {
    // Handle the error
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return MyAlertDialog(
          title: 'Error',
        );
      },
    );

    // Return null or throw the error based on your requirement
    return null;
    // throw error;
  }
  return null;
}

Future<Bill?> addOrUpdateBillDetails(Bill data, BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    print('Bearer token: $token');
    if (token == null) {
      // Handle case where token is not available (user not authenticated)
      print('JWT token is null. User not authenticated.');
      return null;
    }

//    print(billToJson(data));
    var url = "${urlBase}/secure/billdetails/addorupdate";
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: billToJson(data));

    print('response');
    print(response.body);
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');

      var responseBody = json.decode(response.body);
      var body = responseBody['data'];
      // var responseBody = json.decode(response.body);
      // var body = responseBody['data'];
      // // Store the id from the response body
      // int? billId = body['id'];

      // prefs.setInt('billId', billId!);

      // print('billId');
      // print(billId);

      // Store the id of each BillItem
      for (var billItem in data.billItems) {
        prefs.setInt('billItemId${billItem.id}', billItem.id!);
      }

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
            title: 'Added/Updated Successfully',
          );
        },
      );
      return Bill.fromJson(body);
    } else {
      print(
          'Failed to add/update bill details. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      // Handle other status codes
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
            title: 'Failed to Add/Update Bill Details',
          );
        },
      );
    }
  } catch (error) {
    // print('Error occurred during API call: $error');
    // // Handle errors
    // showDialog(
    //   context: context,
    //   barrierDismissible: true,
    //   builder: (BuildContext dialogContext) {
    //     return MyAlertDialog(
    //       title: 'API Error',
    //     );
    //   },
    // );
  }
  return null;
}

Future<void> updatewarrenty(
    String data, BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    print('Bearer token: $token');
    if (token == null) {
      // Handle case where token is not available (user not authenticated)
      print('JWT token is null. User not authenticated.');
      return null;
    }

//    print(billToJson(data));
    var url = "${urlBase}/secure/billdetails/updatewarranty";
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        //body: updatewarrentyToJson(data));
        // body: List<Updatewarrenty>.from(
        //     data.map((item) => updatewarrentyToJson(item))));
        body: data);

    print('response');
    print(response.body);
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
            title: 'Added/Updated Successfully',
          );
        },
      );
    } else {
      print(
          'Failed to add/update bill details. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      // Handle other status codes
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
            title: 'Failed to Add/Update Bill Details',
          );
        },
      );
    }
  } catch (error) {}
  return null;
}
Future<Bill?> fetchBillById(int billId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    if (token == null) {
      // Handle case where token is not available (user not authenticated)
      return null;
    }
    var url =
    Uri.parse("${urlBase}/secure/getbilldetails/byid?billId=$billId");
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Include JWT token in headers
    };

    var response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print(response.body);
      var responseBody = json.decode(response.body);
      var body = responseBody['data'];
      // Store the id from the response body
      //int? billId = body['id'];

      //prefs.setInt('billId', billId!);
      return Bill.fromJson(body);
    } else {
      // Handle other status codes
      throw Exception('Failed to fetch bill details: ${response.statusCode}');
    }
  } catch (error) {
    // Handle errors
    throw Exception('An error occurred: $error');
  }
}

Future<Getbilldetails?> fetchBillDetails(int userId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    if (token == null) {
      // Handle case where token is not available (user not authenticated)
      return null;
    }
    var url =
        Uri.parse("${urlBase}/secure/getbilldetails/byuser?userId=$userId");
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Include JWT token in headers
    };

    var response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print(response.body);
      var responseBody = json.decode(response.body);
      var body = responseBody['data'];
      // Store the id from the response body
      //int? billId = body['id'];

      //prefs.setInt('billId', billId!);
      return Getbilldetails.fromJson(jsonDecode(response.body));
    } else {
      // Handle other status codes
      throw Exception('Failed to fetch bill details: ${response.statusCode}');
    }
  } catch (error) {
    // Handle errors
    throw Exception('An error occurred: $error');
  }
}

// Send data to API
Future<Map<String, dynamic>> uploadFile(File file) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    // Prepare the request URL
    final uri =
        Uri.parse('https://app.entitleguard.com/secure/billdetails/scan');

    // Create a multipart request
    var request = http.MultipartRequest('POST', uri);

    // Add authorization header (if needed)
    request.headers['Authorization'] = 'Bearer $token';
    // Add the image file
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    // Send the request
    var response = await request.send();

    // Parse the response
    var responseData = await http.Response.fromStream(response);
    var result = jsonDecode(responseData.body);

    if (response.statusCode == 200) {
      // Handle success
      if (result['success'] == true) {
        return {
          'success': true,
          'message': result['message'],
          'data': result['data'],
        };
      } else {
        // Handle API-level failure
        return {
          'success': false,
          'message': result['message'] ?? 'Unknown error occurred'
        };
      }
    } else {
      // Handle HTTP-level failure
      return {
        'success': false,
        'message': 'Failed to upload file. Status code: ${response.statusCode}'
      };
    }
  } catch (e) {
    // Handle any unexpected errors during the process
    return {'success': false, 'message': 'Error: $e'};
  }
}

class MyAlertDialog extends StatelessWidget {
  final String title;

  // final String content;
  // final List<Widget> actions;

  MyAlertDialog({
    required this.title,
    // required this.content,
    // this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      // actions: this.actions,
      // content: Text(
      //   this.content,
      //   style: Theme.of(context).textTheme.bodyText2,
      // ),
    );
  }
}

// After successful authentication, store the JWT token
Future<void> storeToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwt_token', token);
}
