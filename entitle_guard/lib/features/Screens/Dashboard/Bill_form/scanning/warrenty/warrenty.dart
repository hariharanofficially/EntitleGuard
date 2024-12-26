import 'dart:convert';

import 'package:entitle_guard/Utils/fitness_app_theme.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Bill_form/scanning/purchase.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../../../../../data/Models/apimodels.dart';
import '../../../../../../data/Services/api.dart';

// class Warranty extends StatelessWidget {
//   final Bill bill;
//   const Warranty({Key? key, required this.bill}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: WarrantyPage(
//         bill: bill,
//       ),
//     );
//   }
// }

// class WarrantyPage extends StatefulWidget {
//   final Bill bill;
//   const WarrantyPage({Key? key, required this.bill}) : super(key: key);

//   @override
//   State<WarrantyPage> createState() => _WarrantyPageState();
// }

// class _WarrantyPageState extends State<WarrantyPage> {
//   Logger logger = new Logger();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _productNameController = TextEditingController();
//   DateTime? _startDate;
//   DateTime? _endDate;
//   List<bool> _hasExtendedWarranty = [];
//   List<DateTime> _warranyEndDate = [];
//   List<int> _extendedWarranyInMonths = [];
//   List<TextEditingController> productController = [];
//   List<TextEditingController> warranyEndDateController = [];
//   List<TextEditingController> extendedWarranyInMonthsController = [];
//   List<BillItems> items = [];

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//     items = widget.bill.billItems;

//     items.forEach((item) {
//       productController.add(createNewTextEditingController(item.product ?? ''));
//       warranyEndDateController.add(createNewTextEditingController(item.warantyEndDate ?? ''));
//       extendedWarranyInMonthsController.add(createNewTextEditingController(item.extendedWarrantyMonths.toString() ?? ''));
    
//       if (item.warantyEndDate != null) {
//         _warranyEndDate.add(DateTime.parse(item.warantyEndDate!));
//       } else {
//         _warranyEndDate.add(DateTime.parse(item.warantyStartDate!));
//       }
//       _hasExtendedWarranty.add(item.extendedWarranty!);
//     });
//     });

//   }

//   @override
//   void dispose() {
//     _productNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Warranty',
//           style: TextStyle(
//             fontFamily: FitnessAppTheme.fontName,
//             fontWeight: FontWeight.w700,
//             fontSize: 22,
//             letterSpacing: 1.2,
//             color: FitnessAppTheme.darkerText,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     ...items.asMap().entries.map((entry) {
//                       return buildItemRow(entry.key);
//                     }).toList(),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         buildSaveButton(),
//                         SizedBox(width: 20),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: Text(
//                             'Cancel',
//                             style: TextStyle(
//                               color: FitnessAppTheme.nearlyBlack,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 100),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ]
//       )

//     );
//   }

//   Widget buildItemRow(int index) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         children: [
//           buildField(
//             'Product',
//             productController[index],
//             'product',
//             readOnly: true,
//             initialValue: widget.bill.billItems.isNotEmpty
//                 ? widget.bill.billItems[index].product ?? ''
//                 : '',
//           ),
//           buildDateField1(context, 'Warranty End Date', warranyEndDateController[index],
//               'Select Date', index:index), //initialValue: formatDateToString(_warranyEndDate[index])),
//           ListTile(
//             title: Text(
//               'Purchased extended warranty',
//               style: TextStyle(
//                 color: Color(0xFF8B48DF),
//                 fontWeight: FontWeight.w700,
//                 fontSize: 13,
//               ),
//             ),
//             trailing: Switch(
//               value: _hasExtendedWarranty[index],
//               onChanged: (bool value) {
//                 setState(() {
//                   _hasExtendedWarranty[index] = value;
//                 });
//               },
//             ),
//           ),
//           if (_hasExtendedWarranty[index])
//             buildField(
//               'Entended Warrany In Months',
//               extendedWarranyInMonthsController[index],
//               'Entended Warrany In Months',
//               initialValue: widget.bill.billItems[index].extendedWarrantyMonths?.toString() ?? '0',
//               keyboardType: TextInputType.number,
//             ),
//           Divider()
//         ],
//       ),
//     );
//   }

//   ElevatedButton buildSaveButton() {
//     return ElevatedButton(
//       onPressed: () async {
//         Bill? addedBill = widget.bill;
//         SharedPreferences prefs =
//         await SharedPreferences.getInstance();
//         if (_formKey.currentState!.validate()) {
//           _formKey.currentState!.save();
//           int? userId = await prefs.getInt('userId');
//           int? billId = await prefs.getInt('billId');

//           print("user id ======== $userId");
//           // Construct the Bill object to send to the backend
//           List<Updatewarrenty> bills = [];

//           setState(() {
//             int i = 0;
//             _warranyEndDate.forEach((endDate) {
//               this.items[i].warantyEndDate = endDate!.toIso8601String();
//               i++;
//             });
//             i = 0;
//             _hasExtendedWarranty.forEach((warranty) {
//               this.items[i].extendedWarranty = warranty;
//               i++;
//             });
//             i = 0;
//             extendedWarranyInMonthsController.forEach((warrantyMonths) {
//               this.items[i].extendedWarrantyMonths = int.parse(warrantyMonths.text);
//               i++;
//             });


//             this.items
//                 .forEach((item) {
//               bills.add(Updatewarrenty(
//                   id: item.id,
//                   extendedWarranty: item.extendedWarranty,
//                   extendedWarrantyMonths: item.extendedWarrantyMonths
//                       .toString(),
//                   warrantyEndDate: item.warantyEndDate
//               ));
//             });
//           });

//           // Call the API function to add or update the bill details
//           List<Map<String, dynamic>> jsonList = bills.map((bill) => bill.toJson()).toList();
//           String jsonString = jsonEncode(jsonList);
//           print(jsonString);
//           await updatewarrenty(jsonString, context);

//           addedBill = await fetchBillById(widget.bill.id!);

//           // if (addedBill != null) {
//           //   // Handle success
//           //   print('Bill details added/updated successfully.');
//           // } else {
//           //   // Handle failure
//           // }
//         }
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => PurchaseDetailsScreen(
//                 bill: addedBill!,
//               )),
//         );
//       },
//       style: ElevatedButton.styleFrom(
//         padding:
//         EdgeInsets.symmetric(horizontal: 50, vertical: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       child: Text(
//         'Save',
//         style: TextStyle(
//           color: FitnessAppTheme.darkText,
//         ),
//       ),
//     );
//   }
//   Future<void> _selectDate(BuildContext context, bool isStartDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2015, 8),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStartDate) {
//           _startDate = picked;
//         } else {
//           _endDate = picked;
//         }
//       });
//     }
//   }

//   Padding buildField(
//       String label, TextEditingController controller, String hint,
//       {String? initialValue, TextInputType keyboardType = TextInputType.text, bool readOnly = false}) {
//     // Set initial value if provided
//     controller.text = initialValue ?? controller.text;

//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               controller: controller,
//               keyboardType: keyboardType,
//               readOnly: readOnly,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 labelText: label, // Use label instead of an empty string
//                 hintText: hint,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Padding buildAmountField(
//       String label, TextEditingController controller, String hint,
//       {String? initialValue, TextInputType keyboardType = TextInputType.text}) {
//     // Set initial value if provided
//     controller.text = initialValue ?? controller.text;

//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               controller: controller,
//               keyboardType: keyboardType,
//               decoration: InputDecoration(
//                 prefixText: '\$',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 labelText: label, // Use label instead of an empty string
//                 hintText: hint,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Padding buildDateField1(BuildContext context, String label, TextEditingController controller, String hint,
//       {int? index, TextInputType keyboardType = TextInputType.text}) {

//     controller.text = formatDateToString(_warranyEndDate[index!]);
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               onTap: () => _selectDate1(context, index),
//               readOnly: true,
//               controller: TextEditingController(
//                 text: _warranyEndDate[index] != null
//                     ? formatDateToString(_warranyEndDate[index!])
//                     : '',
//               ),
//               keyboardType: keyboardType,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 labelText: label, // Use label instead of an empty string
//                 hintText: hint,
//               ),
//             ),

//           ),
//         ],
//       ),
//     );
//   }

//   String formatDate (String datetimestring) {
//     if (datetimestring != null) {
//       DateTime date = DateTime.parse(datetimestring);
//       return DateFormat('dd-MM-yyyy').format(date);
//     } else {
//       return '';
//     }
//   }
//   Future<void> _selectDate1(BuildContext context, int? index) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     logger.i("Logger $picked");
//     if (picked != null) {
//       setState(() {
//         //selectedDate = picked;
//         _warranyEndDate[index!] = picked;
//       });
//       //logger.i("purchasedate '${picked!.toIso8601String()}'");
//     }
//   }
//   String formatDateToString (DateTime datetime) {
//     if (datetime != null) {
//       return DateFormat('dd-MM-yyyy').format(datetime);
//     } else {
//       return '';
//     }
//   }

//   TextEditingController createNewTextEditingController(String text) {
//     TextEditingController controller = TextEditingController();
//     if (text != null) {
//       controller.text = text;
//     }
//     return controller;
//   }
// }

class Warranty extends StatelessWidget {
  final Bill bill;
  const Warranty({Key? key, required this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WarrantyPage(
        bill: bill,
      ),
    );
  }
}

class WarrantyPage extends StatefulWidget {
  final Bill bill;
  const WarrantyPage({Key? key, required this.bill}) : super(key: key);

  @override
  State<WarrantyPage> createState() => _WarrantyPageState();
}

class _WarrantyPageState extends State<WarrantyPage> {
  Logger logger = Logger();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<DateTime?> _warrantyEndDates = [];
  List<bool> _hasExtendedWarranty = [];
  List<TextEditingController> productControllers = [];
  List<TextEditingController> warrantyEndDateControllers = [];
  List<TextEditingController> extendedWarrantyMonthsControllers = [];
  List<BillItems> items = [];

  @override
  void initState() {
    super.initState();
    items = widget.bill.billItems;

    for (var item in items) {
      productControllers.add(TextEditingController(text: item.product ?? ''));
      warrantyEndDateControllers.add(TextEditingController(text: item.warantyEndDate ?? ''));
      extendedWarrantyMonthsControllers.add(TextEditingController(text: item.extendedWarrantyMonths?.toString() ?? ''));
      
      _warrantyEndDates.add(item.warantyEndDate != null ? DateTime.parse(item.warantyEndDate!) : DateTime.now());
      _hasExtendedWarranty.add(item.extendedWarranty ?? false);
    }
  }

  @override
  void dispose() {
    for (var controller in productControllers) {
      controller.dispose();
    }
    for (var controller in warrantyEndDateControllers) {
      controller.dispose();
    }
    for (var controller in extendedWarrantyMonthsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Warranty',
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 1.2,
            color: FitnessAppTheme.darkerText,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ...items.asMap().entries.map((entry) {
                      return buildItemRow(entry.key);
                    }).toList(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSaveButton(),
                        SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: FitnessAppTheme.nearlyBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          )
        ]
      )
    );
  }

  Widget buildItemRow(int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          buildField(
            'Product',
            productControllers[index],
            'product',
            readOnly: true,
          ),
          buildDateField1(context, 'Warranty End Date', warrantyEndDateControllers[index], 'Select Date', index: index),
          ListTile(
            title: Text(
              'Purchased extended warranty',
              style: TextStyle(
                color: Color(0xFF8B48DF),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            trailing: Switch(
              value: _hasExtendedWarranty[index],
              onChanged: (bool value) {
                setState(() {
                  _hasExtendedWarranty[index] = value;
                });
              },
            ),
          ),
          if (_hasExtendedWarranty[index])
            buildField(
              'Extended Warranty In Months',
              extendedWarrantyMonthsControllers[index],
              'Extended Warranty In Months',
              keyboardType: TextInputType.number,
            ),
          Divider()
        ],
      ),
    );
  }

  ElevatedButton buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          List<Updatewarrenty> bills = [];
          for (int i = 0; i < items.length; i++) {
            items[i].warantyEndDate = _warrantyEndDates[i]?.toIso8601String();
            items[i].extendedWarranty = _hasExtendedWarranty[i];
            items[i].extendedWarrantyMonths = int.tryParse(extendedWarrantyMonthsControllers[i].text) ?? 0;
            bills.add(Updatewarrenty(
              id: items[i].id,
              extendedWarranty: items[i].extendedWarranty,
              extendedWarrantyMonths: items[i].extendedWarrantyMonths.toString(),
              warrantyEndDate: items[i].warantyEndDate,
            ));
          }

          String jsonString = jsonEncode(bills.map((bill) => bill.toJson()).toList());
          await updatewarrenty(jsonString, context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PurchaseDetailsScreen(bill: widget.bill),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Save',
        style: TextStyle(
          color: FitnessAppTheme.darkText,
        ),
      ),
    );
  }

  Padding buildField(
    String label, TextEditingController controller, String hint,
    {TextInputType keyboardType = TextInputType.text, bool readOnly = false}) {
    
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              readOnly: readOnly,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: label,
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildDateField1(BuildContext context, String label, TextEditingController controller, String hint,
      {int? index, TextInputType keyboardType = TextInputType.text}) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onTap: () => _selectDate(context, index),
              readOnly: true,
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: label,
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, int? index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _warrantyEndDates[index!] ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _warrantyEndDates[index!] = picked;
        warrantyEndDateControllers[index].text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }
}