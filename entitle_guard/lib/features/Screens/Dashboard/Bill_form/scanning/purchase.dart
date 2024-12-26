// ignore_for_file: use_build_context_synchronously

import 'package:entitle_guard/data/Models/apimodels.dart';

import 'package:entitle_guard/features/Screens/Dashboard/Dashboard.dart';

import 'package:flutter/material.dart';
import 'package:entitle_guard/data/Services/api.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Bill_form/manual/enter_items.dart';

import 'package:entitle_guard/Utils/theme.dart';

import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Components/additional_document.dart';
import 'verify/Verifyitems.dart';
import 'warrenty/warrenty.dart';
import 'package:intl/intl.dart';

class PurchaseDetailsScreen extends StatefulWidget {
  final Bill bill;
  const PurchaseDetailsScreen({super.key, required this.bill});

  @override
  State<PurchaseDetailsScreen> createState() => _PurchaseDetailsScreenState();
}

class _PurchaseDetailsScreenState extends State<PurchaseDetailsScreen> {
  List<DateTime> _expiryDates = [];
  List<DateTime> _extendedDates = [];
  List<DataRow> _dataRows = [];
  List<Bill> billDetailsList = []; // Define billDetailsList here
  List<ProductCard> _productCards = [];
  String merchant = '';
  DateTime purchaseDate = DateTime.now();
  double totalAmount = 0.0; // Initialize to a default value

  @override
  void initState() {
    super.initState();
    _fetchBillDetails();
    billDetailsList.add(widget.bill);
  }

  // final Bill bill;
  // TableWidget({Key? key, required this.bill}) : super(key: key);
  // List<Bill> billDetailsList = [];
  List<DataRow> dataRows = [
    DataRow(cells: [
      DataCell(Text('Banana')),
      DataCell(Text('28/06/2001')),
      DataCell(Text('2000')),
    ]),
    DataRow(cells: [
      DataCell(Text('Orange')),
      DataCell(Text('29/06/2001')),
      DataCell(Text('1500')),
    ]),
    DataRow(cells: [
      DataCell(Text('Mango')),
      DataCell(Text('30/06/2001')),
      DataCell(Text('1200')),
    ]),
    DataRow(cells: [
      DataCell(Text('Pineapple')),
      DataCell(Text('01/07/2001')),
      DataCell(Text('1800')),
    ]),
    DataRow(cells: [
      DataCell(Text('Pineapple')),
      DataCell(Text('01/07/2001')),
      DataCell(Text('1800')),
    ]),
    DataRow(cells: [
      DataCell(Text('Pineapple')),
      DataCell(Text('01/07/2001')),
      DataCell(Text('1800')),
    ]),
    // Add more DataRow as needed
  ];

  Future<void> _fetchBillDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId') ?? 0;
    if (userId != 0) {
      try {
        final response = await fetchBillDetails(userId);
        if (response != null) {
          setState(() {
            _dataRows = _buildDataRows(response.bills);
            // Set totalAmount based on the fetched bills
          });
        } else {
          // Handle case where response is null
        }
      } catch (error) {
        // Handle error
      }
    } else {
      // Handle case where userId is 0
    }
  }

  List<DataRow> _buildDataRows(List<Bill>? bills) {
    List<DataRow> rows = [];
    if (bills != null) {
      for (var bill in bills) {
        if (bill.merchantName == widget.bill.merchantName) {
          for (var item in bill.billItems) {
            rows.add(DataRow(
              cells: [
                DataCell(Text(item.product ?? '')),
                DataCell(Text(formatDate(item.warantyEndDate ?? DateTime.now().toString()))),
                DataCell(Text(item.cost.toString())),
              ],
            ));
          }
        }
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    // Check if _billDetailsList is null or empty before displaying data

    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    'Purchase Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Verifyitems(
                            bill: widget.bill,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text('Merchant'),
                  SizedBox(
                    width: 75,
                  ),
                  Text('${widget.bill.merchantName}'),
                ],
              ),
              Row(
                children: [
                  Text('Purchase Date'),
                  SizedBox(
                    width: 43,
                  ),
                  Text(formatDate(widget.bill.purchaseDate!)),
                ],
              ),
              Row(
                children: [
                  Text('Total Amount'),
                  SizedBox(
                    width: 43,
                  ),
                  Text('\$ ${widget.bill.totalAmount}'),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Items',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    width: 180,
                  ),
                  // Vertical three-dot menu button
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert), // Vertical dots icon
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Upload Warrenty',
                          child: Text('Upload Warrenty'),
                        ),
                        PopupMenuItem<String>(
                          value: 'Upload Docs',
                          child: Text('Upload Docs'),
                        ),
                      ];
                    },
                    onSelected: (String value) {
                      // Handle menu option selection
                      switch (value) {
                        case 'Upload Warrenty':
                          // Handle edit action
                          print('Edit selected');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Warranty(
                                      bill: widget.bill,
                                    )),
                          );
                          break;
                        case 'Upload Docs':
                          // Handle delete action
                          print('Delete selected');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdditionalDocumentsScreen(
                                      bill: widget.bill,
                                    )),
                          );
                          break;
                      }
                    },
                  ),
                ],
              ),
              Container(
                height: (dataRows.length <= 5)
                    ? null
                    : 250.0, // Adjust the height as needed
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Items')),
                        DataColumn(label: Text('Warranty End Date')),
                        DataColumn(label: Text('Cost')),
                      ],
                      // rows: dataRows,
                      rows: _dataRows,
                      // rows: billDetailsList.map<DataRow>((Bill billDetail) {
                      //   final List<BillItems> billItems = billDetail.billItems;
                      //   // Check if billItems is not null and contains at least one item
                      //   if (billItems != null && billItems.isNotEmpty) {
                      //     final BillItems firstItem = billItems[0];
                      //     // You can access the first item's properties like product, warantyEndDate, cost
                      //     return DataRow(cells: [
                      //       DataCell(Text(firstItem.product ?? '')),
                      //       DataCell(Text(firstItem.warantyEndDate ?? '')),
                      //       DataCell(Text(firstItem.cost.toString())),
                      //     ]);
                      //   } else {
                      //     // Handle case where billItems is null or empty
                      //     return DataRow(cells: [
                      //       DataCell(Text('')),
                      //       DataCell(Text('')),
                      //       DataCell(Text('')),
                      //     ]);
                      //   }
                      // }).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(120, 0, 0, 0),
                child: Row(
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text('${widget.bill.totalAmount}'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Attachments',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  IconButton(
                    color: Colors.cyan,
                    onPressed: () {},
                    icon: Icon(
                      Icons.upload_file,
                    ),
                  ),
                ],
              ),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showImageDialog(context, 'assets/images/Login.jpg');
                      },
                      child: Image.asset('assets/images/Login.jpg'),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showImageDialog(context, 'assets/images/calender.jpg');
                      },
                      child: Image.asset('assets/images/calender.jpg'),
                    ),
                    // Add more images as needed
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(),
                      ),
                    );
                  },
                  child: Text('Continue')),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  String formatDate (String datetimestring) {
    if (datetimestring != null) {
      DateTime date = DateTime.parse(datetimestring);
      return DateFormat('dd-MM-yyyy').format(date);
    } else {
      return '';
    }
  }
}
