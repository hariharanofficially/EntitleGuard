// ignore_for_file: must_be_immutable

import 'package:entitle_guard/data/Models/tabIcon_data.dart';
import 'package:entitle_guard/features/Components/bottom_bar_view.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Bill_form/manual/enter_items.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Homepage/Homepage.dart';
import 'package:entitle_guard/features/Screens/Dashboard/profile/profile.dart';
import 'package:entitle_guard/features/Screens/Dashboard/search/search_Screen.dart';
import 'package:flutter/material.dart';
import 'package:entitle_guard/data/Models/apimodels.dart';
import 'package:entitle_guard/data/Services/api.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Bill_form/manual/purchase_list.dart';
import 'package:entitle_guard/Utils/colors.dart';
import 'package:entitle_guard/Utils/fitness_app_theme.dart';
import 'package:entitle_guard/Utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarrantyForm extends StatefulWidget {
  // Declare variables to receive data passed from the VerifyItemsForm
  final List<DateTime> expiryDates;
  final List<DateTime> extendedDates;
  final String merchant;
  final DateTime purchaseDate;
  final double totalAmount;
  final String productType;
  final String productBrand;
  final String productCode;
  final int? productQty;
  final double productCost;
  final String productName;
  final List<ProductCard> productCards; // List of product cards
  // final List<String>
  //     productNames; // Assuming this is the list of product names needed in the WarrantyForm

  // Constructor to receive data
  WarrantyForm({
    required this.expiryDates,
    required this.extendedDates,
    required this.merchant,
    required this.purchaseDate,
    required this.totalAmount,
    required this.productType,
    required this.productBrand,
    required this.productCode,
    required this.productQty,
    required this.productCost,
    required this.productName,
    required this.productCards,
    // required this.productNames,
  });

  @override
  _WarrantyFormState createState() => _WarrantyFormState();
}

class _WarrantyFormState extends State<WarrantyForm> {
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool switchValue = false;
  DateTime _expiryDateController = DateTime.now();
  DateTime _extendedDateController = DateTime.now();
  TextEditingController expiryDateTextController = TextEditingController();
  TextEditingController extendedDateTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    expiryDateTextController.text = _formatDate(_expiryDateController);
    extendedDateTextController.text = _formatDate(_extendedDateController);
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  @override
  void dispose() {
    expiryDateTextController.dispose();
    extendedDateTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          'Warranty Form',
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: isDarkMode ? Secondary : FitnessAppTheme.darkerText,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              for (var productCard in widget
                  .productCards) // Dynamically generate UI elements
                // for (int i = 0; i < widget.productName.length; i++)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Product Name',
                            style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            initialValue: productCard.productName,
                            // initialValue: widget.productName[i],
                            // initialValue: widget.productNames.isNotEmpty
                            //     ? widget.productNames.join(', ')
                            //     : '',
                            style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Select Warranty Expiry Date:    ',
                            style: TextStyle(
                                fontSize: 16,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: 'Expiry Date',
                              labelStyle: TextStyle(
                                color:
                                    isDarkMode ? Colors.blue : Colors.black,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14.0,
                                horizontal: 16.0,
                              ),
                            ),
                            style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white : Colors.black,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Expiry Date';
                              }
                              return null;
                            },
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _expiryDateController,
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null &&
                                  picked != _expiryDateController) {
                                setState(() {
                                  _expiryDateController = picked;
                                  expiryDateTextController.text =
                                      _formatDate(picked);
                                });
                              }
                            },
                            readOnly: true,
                            controller: expiryDateTextController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ListTile(
                        title: Text(
                          ' Purchased extended warranty',
                          style: TextStyle(
                            color: Color(0xFF8B48DF),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        trailing: Switch(
                          value: switchValue,
                          onChanged: (value) {
                            setState(() {
                              switchValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: switchValue,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Select Warranty Extended Date:',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'Extended Date',
                                labelStyle: TextStyle(
                                  color: isDarkMode
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 16.0,
                                ),
                              ),
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Extended Date';
                                }
                                return null;
                              },
                              onTap: () async {
                                final DateTime? picked =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: _extendedDateController,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101),
                                );
                                if (picked != null &&
                                    picked != _extendedDateController) {
                                  setState(() {
                                    _extendedDateController = picked;
                                    extendedDateTextController.text =
                                        _formatDate(picked);
                                  });
                                }
                              },
                              readOnly: true,
                              controller: extendedDateTextController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ElevatedButton(
                onPressed: () async {
                  print('enter');
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    print('enter1');
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final userId = prefs.getInt('userId');
                    final billId = prefs.getInt('billId');
                    final billItemId = prefs.getInt('billItemId');
        
                    Bill bill = Bill(
                      id: billId,
                      merchantName: widget.merchant,
                      purchaseDate: widget.purchaseDate.toIso8601String(),
                      totalAmount: widget.totalAmount.toDouble(),
                      userId: userId,
                      billItems: [
                        BillItems(
                          id: billItemId,
                          brand: widget.productBrand,
                          cost: widget.productCost,
                          product: widget.productName,
                          productCode: widget.productCode,
                          quantity: widget.productQty,
                          type: widget.productType,
                          warantyStartDate:
                              widget.purchaseDate.toIso8601String(),
                          warantyEndDate:
                              _expiryDateController.toIso8601String(),
                        )
                      ],
                    );
        
                    if (switchValue) {
                      String extendedDate =
                          _extendedDateController.toIso8601String();
                      if (_expiryDateController != null) {
                        extendedDate += ", " +
                            _extendedDateController.toIso8601String();
                      }
                      bill.billItems[0].warantyEndDate = extendedDate;
                    }
        
                    // Call the API function to add or update the bill details
                    Bill? addedBill =
                        await addOrUpdateBillDetails(bill, context);
        
                    // if (userId == null || billId == null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text(
                    //           'User ID, Bill ID, or Bill Item ID is missing'),
                    //     ),
                    //   );
                    //   return;
                    // }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TableWidget(
                          bill: bill,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
