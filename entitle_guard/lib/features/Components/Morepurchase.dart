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

class Morepurchase extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final List<Bill> bill;

  const Morepurchase({
    Key? key,
    required this.bill,
    this.animationController,
    this.animation,
  }) : super(key: key);

  String getFormattedDate(String dateTimeString) {
    try {
      DateTime date = DateTime.parse(dateTimeString.split("T")[0]);
      return DateFormat('MM-dd-yyyy').format(date);
    } catch (e) {
      print("Error parsing date: $e");
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bill.isEmpty) {
      return Center(
        child: Text("No purchases available."),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("More"),
        ),
        body: GestureDetector(
          child: SingleChildScrollView(
            child: Column(
              children: bill
                  .map((item) => _buildLatestPurchaseWidget(context, item))
                  .toList(),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildLatestPurchaseWidget(BuildContext context, Bill item) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? outline : FitnessAppTheme.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(68.0),
            ),
            boxShadow: [
              BoxShadow(
                color: FitnessAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 4, bottom: 8, top: 16),
                      child: Text(
                        item.merchantName ?? 'null',
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: FitnessAppTheme.darkText,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 8),
                              child: Text(
                                '\$',
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4, bottom: 3),
                              child: Text(
                                '${item.totalAmount ?? 0}',
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: FitnessAppTheme.grey.withOpacity(0.5),
                                  size: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    getFormattedDate(item.purchaseDate ?? ''),
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
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
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
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
            ],
          ),
        ),
      ),
    );
  }
}
