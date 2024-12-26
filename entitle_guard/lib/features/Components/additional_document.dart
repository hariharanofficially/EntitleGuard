import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Utils/fitness_app_theme.dart';
import '../../Utils/theme.dart';
import '../../data/Models/apimodels.dart';
import '../Screens/Dashboard/Bill_form/scanning/purchase.dart';

class AdditionalDocumentsScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  final Bill bill;
  AdditionalDocumentsScreen({
    Key? key,
    required this.bill,
  }) : super(key: key);
  Future<void> _pickDocument(BuildContext context) async {
    final XFile? document =
        await _picker.pickImage(source: ImageSource.gallery);
    if (document != null) {
      // Handle the uploaded document
      print('Document selected: ${document.path}');
    } else {
      print('No document selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Additional Documents',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            Icon(
              Icons.notifications,
              color: isDarkMode
                  ? FitnessAppTheme.deactivatedText
                  : FitnessAppTheme.grey,
              size: 30,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _pickDocument(context),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_upward, size: 50, color: Colors.black),
                    Text(
                      'Upload',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle Cancel action
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PurchaseDetailsScreen(
                          bill: bill,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
