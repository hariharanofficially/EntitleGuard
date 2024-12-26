// ignore_for_file: unnecessary_null_comparison, unused_field

import 'package:entitle_guard/data/Models/apimodels.dart';
import 'package:entitle_guard/data/Services/api.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Bill_form/manual/warrenty.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Dashboard.dart';
import 'package:entitle_guard/Utils/colors.dart';
import 'package:entitle_guard/Utils/fitness_app_theme.dart';
import 'package:entitle_guard/Utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyItemsForm extends StatefulWidget {
  final Bill bill;
  VerifyItemsForm({required this.bill});
  @override
  _VerifyItemsFormState createState() => _VerifyItemsFormState();
}

class _VerifyItemsFormState extends State<VerifyItemsForm> {
  SharedPreferences? prefs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _merchant = '';
  DateTime _purchaseDate = DateTime.now();
  double _totalAmount = 0.0;
  List<ProductCard> _productCards = [];
  bool _canAddNew = true; // Track whether a new product card can be added
  List<DateTime> _expiryDates = [];
  List<DateTime> _extendedDates = [];
  int? userId = 0;

  @override
  void initState() {
    super.initState();
    // Add initial product card
    // _addProductCard();
  }

  void _addProductCard(
      String merchant, DateTime purchaseDate, double totalAmount) {
    setState(() {
      _productCards.add(
        ProductCard(
          merchant,
          purchaseDate,
          totalAmount,
          index: _productCards.length,
          onRemove: (index) => _removeProductCard(index),
        ),
      );
      _canAddNew = true; // Disable adding new cards after one is added
      // Add a corresponding expiry date and extended date for the new card
      _expiryDates.add(DateTime.now());
      _extendedDates.add(DateTime.now());
    });
  }

  void _removeProductCard(int index) {
    setState(() {
      _productCards.removeAt(index);
      _canAddNew = false; // Enable adding new cards after one is removed
      // Remove the corresponding expiry date and extended date for the removed card
      _expiryDates.removeAt(index);
      _extendedDates.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(
          'Manual Adding Bill',
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: isDarkMode ? Secondary : FitnessAppTheme.darkerText,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: isDarkMode ? Colors.white : Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addProductCard(_merchant, _purchaseDate, _totalAmount);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '  Merchant               ',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Merchant',
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.blue : Colors.black,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter merchant';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _merchant = value!;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '  Purchase Date       ',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Purchase Date',
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.blue : Colors.black,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter purchase date';
                        }
                        return null;
                      },
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _purchaseDate,
                          firstDate: DateTime(2015, 8),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != _purchaseDate) {
                          setState(() {
                            _purchaseDate = picked;
                          });
                        }
                      },
                      readOnly: true,
                      controller: TextEditingController(
                        text: _purchaseDate != null
                            ? '${_purchaseDate.month}/${_purchaseDate.day}/${_purchaseDate.year}'
                            : '',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '  Amount               ',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Amount',
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.blue : Colors.black,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14.0,
                          horizontal: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Amount';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _totalAmount = double.parse(value!);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Process the form data here
                        // For example, send it to an API or perform other actions
                        print('Form submitted!');
                        print('Merchant: $_merchant');
                        print('Purchase Date: $_purchaseDate');
                        _productCards.forEach((productCard) {
                          print('Product Type: ${productCard.productType}');
                          print('Product Name: ${productCard.productName}');
                          print('Product Brand: ${productCard.productBrand}');
                          print('Product Code: ${productCard.productCode}');
                          print('Product Qty: ${productCard.productQty}');
                          print('Product Cost: ${productCard.productCost}');
                        });
                        int? userId = await prefs.getInt('userId');
                        print("user id ======== $userId");
                        // Construct the Bill object to send to the backend
                        Bill bill = Bill(
                          merchantName: _merchant,
                          purchaseDate: _purchaseDate
                              .toIso8601String(), // Convert DateTime to string
                          totalAmount:
                              _totalAmount.toDouble(), // Convert double to int
                          userId: userId,
                          billItems: _productCards
                              .map((productCard) => BillItems(
                                    brand: productCard.productBrand,
                                    cost: productCard.productCost,
                                    product: productCard.productName,
                                    productCode: productCard.productCode,
                                    quantity: productCard.productQty,
                                    type: productCard.productType,
                                    warantyEndDate: '', // Add warranty end date
                                    warantyStartDate: _purchaseDate
                                        .toIso8601String(), // Add warranty start date
                                  ))
                              .toList(),
                        );

                        // Call the API function to add or update the bill details
                        Bill? addedBill =
                            await addOrUpdateBillDetails(bill, context);

                        if (addedBill != null) {
                          // Handle success
                          print('Bill details added/updated successfully.');
                        } else {
                          // Handle failure
                        }
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              ..._productCards.map((productCard) =>
                  productCard.buildCard(context, _productCards)),
              if(_productCards.length > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WarrantyForm(
                          // Pass necessary data to the WarrantyForm constructor
                          expiryDates: _expiryDates,
                          extendedDates: _extendedDates,
                          // productNames: [],
                          merchant: _merchant, // Pass the necessary data
                          purchaseDate:
                              _purchaseDate, // Pass the necessary data
                          totalAmount: _totalAmount, // Pass the necessary data
                          productType: _productCards.last
                              .productType, // Access productType from _productCards
                          productName: _productCards.last
                              .productName, // Access productName from _productCards
                          productBrand: _productCards.last
                              .productBrand, // Access productBrand from _productCards
                          productCode: _productCards.last
                              .productCode, // Access productCode from _productCards
                          productQty: _productCards.last
                              .productQty, // Access productQty from _productCards
                          productCost: _productCards.last.productCost,
                          productCards: _productCards,
                          // productNames: [], // Access productCost from _productCards
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard {
  String productType = 'Option 1';
  String productName = '';
  String productBrand = '';
  String productCode = '';
  int? productQty;
  double productCost = 0.0;
  Function(int)? onRemove; // Function to call when the card needs to be removed
  int index; // Index of this card in the list
  final String _merchant;
  final DateTime _purchaseDate;
  final double _totalAmount;
  ProductCard(
    this._merchant,
    this._purchaseDate,
    this._totalAmount, {
    required this.index,
    this.onRemove,
  });

  void saveDetailsToBackend(
      BuildContext context, List<ProductCard> productCards) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = await prefs.getInt('userId');
    final billId = await prefs.getInt('billId');
    final billItemId = await prefs.getInt('billItemId');
    List<BillItems> billItemsList = productCards
        .map((productCard) => BillItems(
              id: billItemId,
              brand: productCard.productBrand,
              cost: productCard.productCost,
              product: productCard.productName,
              productCode: productCard.productCode,
              quantity: productCard.productQty,
              type: productCard.productType,
            ))
        .toList();
    Bill bill = Bill(
      merchantName: _merchant,
      purchaseDate:
          _purchaseDate.toIso8601String(), // Convert DateTime to string
      totalAmount: _totalAmount.toDouble(), // Convert double to int
      userId: userId,
      billItems: billItemsList,
      id: billId,
    );
    Bill? addedBill = await addOrUpdateBillDetails(bill, context);
    // Now you can proceed with sending the bill details to the backend...
    if (addedBill != null) {
      // Handle success
      print('Bill details added/updated successfully.');
    } else {}
  }

  Widget buildCard(BuildContext context, List<ProductCard> _productCards) {
    int orderNumber = index + 1;
    return Card(
      color: Colors.white,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$orderNumber',
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: onRemove != null ? () => onRemove!(index) : null,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: productType,
                  onChanged: (String? newValue) {
                    productType = newValue!;
                  },
                  items: <String>[
                    'Option 1',
                    'Option 2',
                    'Option 3',
                    'Option 4'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Product Type',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Product Name',
                  ),
                  onChanged: (value) {
                    productName = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Product Brand',
                  ),
                  onChanged: (value) {
                    productBrand = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Product Code',
                  ),
                  onChanged: (value) {
                    productCode = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Product Qty',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    productQty = int.tryParse(value) ?? 0;
                    ;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Product Cost',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    productCost = double.parse(value);
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    saveDetailsToBackend(context, _productCards);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
