import 'package:entitle_guard/Utils/colors.dart';
import 'package:entitle_guard/Utils/theme.dart';
import 'package:entitle_guard/data/Models/apimodels.dart';
import 'package:entitle_guard/data/Services/api.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Bill_form/manual/purchase_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Utils/fitness_app_theme.dart';
import '../Screens/Dashboard/Bill_form/scanning/purchase.dart';
import 'package:intl/intl.dart';

class Latestpurchase extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  //final int userId; // Add userId as a property
  final Bill bill;

  const Latestpurchase({
    Key? key,
    required this.bill,
    this.animationController,
    this.animation,
  }) : super(key: key);
  String getFormattedDate(String dateTimeString) {
    if (dateTimeString != null && dateTimeString.isNotEmpty) {
      try {
        List<String> parts = dateTimeString.split("T");

        // Separate date and time
        String datePart = parts[0]; // Expected format: "2023-10-22"
        DateTime date = DateTime.parse(datePart);
        String formattedDate = DateFormat('MM-dd-yyyy').format(date);
        return formattedDate;
      } catch (e) {
        print("Error parsing date: $e");
        return "";
      }
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bill == null) {
      // Display loading indicator if data is being fetched
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      // Display Latestpurchase widget with fetched bill details
      return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PurchaseDetailsScreen(
                  bill: bill,
                ),
              ),
            );
          },
          child: _buildLatestPurchaseWidget(context));
    }
  }

  Widget _buildLatestPurchaseWidget(BuildContext context) {
    // Extract bill details from _billDetails object
    //final addorupdate? data = _billDetails.data;

    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? outline : FitnessAppTheme.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(68.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: FitnessAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8, top: 16),
                      child: Text(
                        ' ${bill?.merchantName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: -0.1,
                          color: FitnessAppTheme.darkText,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 8, bottom: 8),
                              child: Text(
                                '\$',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  letterSpacing: -0.2,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 3),
                              child: Text(
                                '${bill?.totalAmount}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  color: FitnessAppTheme.grey.withOpacity(0.5),
                                  size: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    //"test",
                                    getFormattedDate(bill?.purchaseDate ?? ''),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 4, bottom: 14),
                              child: Text(
                                'Purchase Date',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  letterSpacing: 0.0,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
              //   child: Container(
              //     height: 2,
              //     decoration: const BoxDecoration(
              //       color: FitnessAppTheme.background,
              //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(
              //       left: 24, right: 24, top: 8, bottom: 16),
              //   child: Row(
              //     children: <Widget>[
              //       Expanded(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: <Widget>[
              //             const Text(
              //               'Items',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                 fontFamily: FitnessAppTheme.fontName,
              //                 fontWeight: FontWeight.w500,
              //                 fontSize: 16,
              //                 letterSpacing: -0.2,
              //                 color: FitnessAppTheme.darkText,
              //               ),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.only(top: 6),
              //               child: Text(
              //                 // data!.billItemsDtos.isNotEmpty
              //                 //     ? data.billItemsDtos[0].product ?? '-'
              //                 //     : '-',
              //                 '${bill != null && bill!.billItems.isNotEmpty ? bill.billItems.map((item) => item.product!).join(", ") : "No items"}',
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(
              //                   fontFamily: FitnessAppTheme.fontName,
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 12,
              //                   color: FitnessAppTheme.grey.withOpacity(0.5),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Expanded(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: <Widget>[
              //             Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: <Widget>[
              //                 const Text(
              //                   'Warranty \nEnd Date',
              //                   textAlign: TextAlign.center,
              //                   style: TextStyle(
              //                     fontFamily: FitnessAppTheme.fontName,
              //                     fontWeight: FontWeight.w500,
              //                     fontSize: 16,
              //                     letterSpacing: -0.2,
              //                     color: FitnessAppTheme.darkText,
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding: const EdgeInsets.only(top: 6),
              //                   child: Text(
              //                     bill != null && bill!.billItems.isNotEmpty
              //                         ? bill.billItems[0].warantyEndDate ??
              //                             '-'
              //                         : '-',
              //                     textAlign: TextAlign.center,
              //                     style: TextStyle(
              //                       fontFamily: FitnessAppTheme.fontName,
              //                       fontWeight: FontWeight.w600,
              //                       fontSize: 12,
              //                       color: FitnessAppTheme.grey.withOpacity(0.5),
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //       Expanded(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: <Widget>[
              //             Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               crossAxisAlignment: CrossAxisAlignment.end,
              //               children: <Widget>[
              //                 const Text(
              //                   'Cost',
              //                   style: TextStyle(
              //                     fontFamily: FitnessAppTheme.fontName,
              //                     fontWeight: FontWeight.w500,
              //                     fontSize: 16,
              //                     letterSpacing: -0.2,
              //                     color: FitnessAppTheme.darkText,
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding: const EdgeInsets.only(top: 6),
              //                   child: Text(
              //                     '${bill?.totalAmount}\$',
              //                     textAlign: TextAlign.center,
              //                     style: TextStyle(
              //                       fontFamily: FitnessAppTheme.fontName,
              //                       fontWeight: FontWeight.w600,
              //                       fontSize: 12,
              //                       color: FitnessAppTheme.grey.withOpacity(0.5),
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
