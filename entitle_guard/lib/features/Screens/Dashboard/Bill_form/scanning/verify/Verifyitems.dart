import 'package:entitle_guard/features/Screens/Dashboard/Dashboard.dart';
import 'package:entitle_guard/Utils/fitness_app_theme.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Bill_form/scanning/warrenty/warrenty.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../../../../../Utils/theme.dart';
import '../../../../../../data/Models/apimodels.dart';
import '../../../../../../data/Services/api.dart';
import '../../manual/enter_items.dart';

class Verifyitems extends StatefulWidget {
  final Bill bill;
  const Verifyitems({Key? key, required this.bill}) : super(key: key);

  @override
  State<Verifyitems> createState() => _VerifyitemsState();
}

class _VerifyitemsState extends State<Verifyitems> {
  Logger logger  = new Logger();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  late TextEditingController merchantController;
  late TextEditingController purchaseDateController;
  List<ProductCard> _productCards = [];
  late TextEditingController totalAmountController;
  String? selectedValue;
  List<BillItems> items = [];
  int rowNumber = 1;
  late List<TextEditingController> productController = [];
  late List<TextEditingController> brandController = [];
  late List<TextEditingController> costController = [];

  @override
  void initState() {
    super.initState();
    merchantController = TextEditingController();
    purchaseDateController = TextEditingController();
    if (widget.bill.purchaseDate != null) {
      selectedDate = DateTime.parse(widget.bill.purchaseDate!);
    }
    // purchaseDateController.addListener(() {
    //   setState(() {});  // Trigger a UI rebuild on text change if needed
    // });
    totalAmountController = TextEditingController();

    selectedValue = widget.bill.billItems.isNotEmpty
        ? widget.bill.billItems[0].type ?? 'Option 1'
        : 'Option 1';
    // Initialize items list with existing bill items
    // items = widget.bill.billItems.map((item) {
    //   return {
    //     'id':
    //     'type': item.type,
    //     'product': item.product,
    //     'brand': item.brand,
    //     'cost': item.cost,
    //   };
    // }).toList();

    items = widget.bill.billItems;

    items.forEach((item) {
      productController.add(createNewTextEditingController(item.product ?? ''));
      setState(() {});
      brandController.add(createNewTextEditingController(item.brand ?? ''));
      setState(() {});
      costController.add(
          createNewTextEditingController(item.cost == null ? "0.0" : item.cost.toString()));
      setState(() {});
      logger.i("productcontroller size ${productController.length}");
    });
  }

  @override
  void dispose() {
    merchantController.dispose();
    purchaseDateController.dispose();
    totalAmountController.dispose();
    // productController;
    // brandController.dispose();
    // costController.dispose();
    super.dispose();
  }

  void addItem() {
    setState(() {
      items.add(BillItems());
      productController.add(createNewTextEditingController(''));
      brandController.add(createNewTextEditingController(''));
      costController.add(
          createNewTextEditingController("0.0"));
    });
  }

  void removeItem() {
    if (items.isNotEmpty) {
      setState(() {
        items.removeLast();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    logger.i("Logger $picked");
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify items'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
        ),
      ),
      body: Container (
        width: double.infinity,
        height: 2000,
        child: SingleChildScrollView(
          child: Container (
            width: double.infinity,
            height: 2000,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildField('Merchant', merchantController, 'Enter merchant name',
                      initialValue: widget.bill.merchantName),
                  //SizedBox(height: 10),
                  buildDateField1(context, 'Purchase Date', purchaseDateController,
                      'Select Date', initialValue: formatDate(widget.bill.purchaseDate!)),
                  //SizedBox(height: 10),
                  buildAmountField('Amount', totalAmountController, 'Enter Amount',
                      initialValue: widget.bill.totalAmount?.toString()),

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Items'),
                      TextButton(
                        onPressed: addItem,
                        child: Text('+Add New'),
                      ),
                    ],
                  ),
                  ),
                  ...items.asMap().entries.map((entry) {
                    return buildItemRow(entry.key);
                  }).toList(),
                  SizedBox(height: 30),
                  buildSaveButton(),
                  SizedBox(height: 6),
                  buildCancelButton(),
                ],
              ),
            ),
          )


        ),
      )

    );
  }

  Padding buildField(
      String label, TextEditingController controller, String hint,
      {String? initialValue, TextInputType keyboardType = TextInputType.text}) {
    // Set initial value if provided
    controller.text = initialValue ?? controller.text;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: label, // Use label instead of an empty string
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildAmountField(
      String label, TextEditingController controller, String hint,
      {String? initialValue, TextInputType keyboardType = TextInputType.text}) {
    // Set initial value if provided
    controller.text = initialValue ?? controller.text;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                prefixText: '\$',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: label, // Use label instead of an empty string
                hintText: hint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildDateField1(BuildContext context, String label, TextEditingController controller, String hint,
  {String? initialValue, TextInputType keyboardType = TextInputType.text}) {

    controller.text = initialValue ?? controller.text;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onTap: () => _selectDate(context),
              readOnly: true,
              controller: TextEditingController(
                text: selectedDate != null
                  ? formatDateToString(selectedDate!)
                      : '',
                  ),
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: label, // Use label instead of an empty string
                hintText: hint,
              ),
            ),

          ),
        ],
      ),
    );
  }

  Padding buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Text('Purchase Date '),
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  selectedDate != null
                      ? '${selectedDate!.toLocal()}'.split(' ')[0]
                      : 'Choose Date',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItemRow(int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          //SizedBox(height: 30),
          Container(
            color: FitnessAppTheme.background,
            width: double.infinity,
            height: 30,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('# ${index + 1}'),
                  IconButton(
                    onPressed: removeItem,
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ),
          //SizedBox(height: 30),
          //buildDropdownRow(),
          buildField(
            'Product',
            productController[index],
            'product',
            initialValue: widget.bill.billItems.isNotEmpty
                ? widget.bill.billItems[index].product ?? ''
                : '',
          ),
          buildField(
            'Product Code',
            brandController[index],
            'Product Code',
            initialValue: widget.bill.billItems.isNotEmpty
                ? widget.bill.billItems[index].productCode ?? ''
                : '',
          ),
          buildAmountField(
            'Cost',
            costController[index],
            'total amount',
            initialValue: widget.bill.billItems[index].cost?.toString() ?? '0',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Padding buildDropdownRow() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Text('Type'),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedValue,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
              items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        Bill? addedBill = widget.bill;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          int? userId = await prefs.getInt('userId');
          int? billId = await prefs.getInt('billId');

          setState(() {
            int i = 0;
            productController.forEach((product) {
              items[i].product = product.text;
              i++;
            });
            i = 0;
            brandController.forEach((brand) {
              items[i].productCode = brand.text;
              i++;
            });
            i = 0;
            costController.forEach((cost) {
              items[i].cost = double.parse(cost.text);
              i++;
            });
          });

          print("user id ======== $userId");
          // Construct the Bill object to send to the backend
          Bill bill = Bill(
            id: widget.bill.id,
            merchantName: merchantController.text,
            purchaseDate:
                selectedDate!.toIso8601String(), // Convert DateTime to string
            totalAmount: double.parse(totalAmountController.text),
            billItems: items
                .map((item) => BillItems(
                      id: item.id,
                      brand: item.brand,
                      cost: item.cost,
                      product: item.product,
                      productCode: item.productCode,
                      quantity: item.quantity,
                      type: item.type,
                      warantyEndDate: item.warantyEndDate, // Add warranty end date
                      warantyStartDate: selectedDate!
                          .toIso8601String(), // Add warranty start date
                extendedWarranty: item.extendedWarranty,
                extendedWarrantyMonths: item.extendedWarrantyMonths
                    ))
                .toList(),
            userId: userId,
          );

          // Call the API function to add or update the bill details
          addedBill = await addOrUpdateBillDetails(bill, context);

          if (addedBill != null) {
            // Handle success
            print('Bill details added/updated successfully.');
          } else {
            // Handle failure
          }
        }
        logger.i("bill value : ${addedBill?.id} ${addedBill?.merchantName}");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Warranty(
                    bill: addedBill!,
                  )),
        );
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

  TextButton buildCancelButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      },
      child: Text(
        'Cancel',
        style: TextStyle(
          color: FitnessAppTheme.nearlyBlack,
        ),
      ),
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

  String formatDateToString (DateTime datetime) {
    if (datetime != null) {
      return DateFormat('dd-MM-yyyy').format(datetime);
    } else {
      return '';
    }
  }

  TextEditingController createNewTextEditingController(String text) {
    TextEditingController controller = TextEditingController();
    if (text != null) {
      controller.text = text;
    }
    return controller;
  }
}
