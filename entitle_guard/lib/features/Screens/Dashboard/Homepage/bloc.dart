import 'package:entitle_guard/data/Models/apimodels.dart';
import 'package:entitle_guard/data/Services/api.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Bill_form/Result/Result.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class HomepageBloc extends ChangeNotifier {
  Logger logger = new Logger();
  final ImagePicker _picker = ImagePicker();
  String recognizedText = "";
  List<Bill> billDetailsList = [];

  DateTime parseDate(String dateStr) {
    List<String> parts = dateStr.split('/');
    if (parts.length == 3) {
      int month = int.tryParse(parts[0]) ?? 1;
      int day = int.tryParse(parts[1]) ?? 1;
      int year = int.tryParse(parts[2]) ?? 1970;
      return DateTime(year, month, day);
    } else {
      return DateTime.now();
    }
  }

  Future<void> fetchData(int userId) async {
    try {
      logger.i("Printing from");
      // Call the fetchBillDetails function with appropriate parameters
      Getbilldetails? billDetails =
          await fetchBillDetails(userId); // Pass userId as parameter
      logger.i("Printing here");
      if (billDetails != null) {
        // If billDetails is not null, assign it to billDetailsList
        billDetailsList = billDetails.bills!;
        logger.i(billDetailsList.length.toString());
        notifyListeners();
      } else {
        // Handle case where billDetails is null
        print('fetchBillDetails returned null');
      }
    } catch (error) {
      // Handle errors
      print(' fetching bill details: $error');
    }
  }
  // Future<void> fetchData() async {
  //   billDetailsList = getbilldetails.map((productString) {
  //     List<String> productValues = productString.split(',');
  //     return ProductData(
  //       productName: productValues[4],
  //       merchant: productValues[0],
  //       purchaseDate: parseDate(productValues[1]),
  //       totalAmount: double.tryParse(productValues[2]) ?? 0.0,
  //       productType: productValues[3],
  //       productBrand: productValues[5],
  //       productCost: double.tryParse(productValues[6]) ?? 0.0,
  //       expiryDate: parseDate(productValues[7]),
  //       extendedDate: parseDate(productValues[8]),
  //     );
  //   }).toList();
  //   notifyListeners();
  // }

  Future<void> getImageToText(
      final String imagePath, BuildContext context, Bill bill) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
    this.recognizedText = recognizedText.text.toString();
    notifyListeners();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Result(
          imagePath: imagePath,
          bill: bill,
        ),
      ),
    );
  }

  Future<void> navigateToResultScreen(BuildContext context, Bill bill) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await getImageToText(image.path, context, bill);
    }
  }
}
