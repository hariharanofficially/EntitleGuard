// import 'package:entitle_guard/Screens/Dashboard/Dashboard.dart';
// import 'package:entitle_guard/Utils/colors.dart';
// import 'package:entitle_guard/Utils/fitness_app_theme.dart';
// import 'package:entitle_guard/Utils/theme.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     title: 'Verify Items Form',
//     home: NextPage(
//         // productDataList: [],
//         ),
//   ));
// }


// class NextPage extends StatefulWidget {
//   @override
//   _NextPageState createState() => _NextPageState();
// }

// class _NextPageState extends State<NextPage> {
//   late List<ProductData> productDataList;
//   DateTime parseDate(String dateStr) {
//     List<String> parts = dateStr.split('/');
//     if (parts.length == 3) {
//       int month = int.tryParse(parts[0]) ?? 1;
//       int day = int.tryParse(parts[1]) ?? 1;
//       int year = int.tryParse(parts[2]) ?? 1970;
//       return DateTime(year, month, day);
//     } else {
//       // Return a default date if parsing fails
//       return DateTime.now();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchData(); // Fetch data when the page is initialized
//   }

//   Future<void> fetchData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> productList = prefs.getStringList('productList') ?? [];
//     setState(() {
//       productDataList = productList.map((productString) {
//         List<String> productValues = productString.split(',');
//         return ProductData(
//           productName: productValues[4],
//           merchant: productValues[0],
//           purchaseDate: parseDate(productValues[1]),
//           totalAmount: double.tryParse(productValues[2]) ?? 0.0,
//           productType: productValues[3],
//           productBrand: productValues[5],
//           productCost: double.tryParse(productValues[6]) ?? 0.0,
//           expiryDate: parseDate(productValues[7]),
//           extendedDate: parseDate(productValues[8]),
//         );
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Next Page'),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => VerifyItemsForm(),
//                 ),
//               );
//             },
//             child: Text('Fill Form'),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: productDataList != null
//             ? ListView.builder(
//                 itemCount: productDataList.length,
//                 itemBuilder: (context, index) {
//                   final productData = productDataList[index];
//                   return CardWidget(
//                     productName: productData.productName,
//                     merchant: productData.merchant,
//                     purchaseDate: productData.purchaseDate,
//                     totalAmount: productData.totalAmount,
//                     productType: productData.productType,
//                     productBrand: productData.productBrand,
//                     productCost: productData.productCost,
//                     expiryDate: productData.expiryDate,
//                     extendedDate: productData.extendedDate,
//                   );
//                 },
//               )
//             : Center(child: Text('No data available')),
//       ),
//     );
//   }
// }


// class CardWidget extends StatelessWidget {
//   final String productName;
//   final String merchant;
//   final DateTime purchaseDate;
//   final double totalAmount;
//   final String productType;
//   final String productBrand;
//   final double productCost;
//   final DateTime expiryDate;
//   final DateTime extendedDate;

//   const CardWidget({
//     Key? key,
//     required this.productName,
//     required this.merchant,
//     required this.purchaseDate,
//     required this.totalAmount,
//     required this.productType,
//     required this.productBrand,
//     required this.productCost,
//     required this.expiryDate,
//     required this.extendedDate,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Merchant Name: $merchant'),
//             Text(
//                 'Purchase Date: ${purchaseDate.month}/${purchaseDate.day}/${purchaseDate.year}'),
//             Text('Total Amount: $totalAmount'),
//             Text('Product Name: $productName'),
//             Text('Product Type: $productType'),
//             Text('Product Brand: $productBrand'),
//             Text('Product Cost: $productCost'),
//             Text(
//                 'Warranty Expiry Date: ${expiryDate != null ? '${expiryDate.month}/${expiryDate.day}/${expiryDate.year}' : 'Not selected'}'),
//             Text(
//                 'Warranty Extended Date: ${extendedDate != null ? '${extendedDate.month}/${extendedDate.day}/${extendedDate.year}' : 'Not selected'}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => VerifyItemsForm(),
//               ),
//             );
//           },
//           child: Text('Fill Form'),
//         ),
//       ),
//     );
//   }
// }
