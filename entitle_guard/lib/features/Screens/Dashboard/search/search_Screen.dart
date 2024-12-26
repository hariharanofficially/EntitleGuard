import 'package:entitle_guard/features/Components/CustomSlider.dart';
import 'package:entitle_guard/features/Components/custom_categories_list.dart';
import 'package:entitle_guard/data/Models/custom_Text_Form_fild.dart';
import 'package:entitle_guard/data/Models/custom_button.dart';
import 'package:entitle_guard/Utils/colors.dart';
import 'package:entitle_guard/Utils/fitness_app_theme.dart';
import 'package:entitle_guard/Utils/theme.dart';
import 'package:entitle_guard/features/Screens/Dashboard/Dashboard.dart';
import 'package:entitle_guard/features/Screens/Dashboard/search/bloc.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  static List previousSearchs = [];
  // late User user;
  late SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    // user = FirebaseAuth.instance.currentUser!;
    _searchBloc = SearchBloc();
  }

  @override
  void dispose() {
    _searchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                color: isDarkMode ? Colors.black : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CostomTextFormFild(
                          hint: "Serch",
                          prefixIcon: IconlyLight.search,
                          controller: searchController,
                          filled: true,
                          suffixIcon: searchController.text.isEmpty
                              ? null
                              : Icons.cancel_sharp,
                          onTapSuffixIcon: () {
                            searchController.clear();
                          },
                          onChanged: (query) {
                            _searchBloc.updateSearch(query);
                          },
                          onEditingComplete: () {
                            previousSearchs.add(searchController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard()),
                            );
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  context: context,
                                  builder: (context) =>
                                      _custombottomSheetFilter(context));
                            });
                          },
                          icon: Icon(
                            IconlyBold.filter,
                            color: isDarkMode ? outline : mainText,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                child: StreamBuilder<String>(
                  stream: _searchBloc.searchStream,
                  builder: (context, snapshot) {
                    // Implement previous search items UI here
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: previousSearchs.length,
                      itemBuilder: (context, index) =>
                          previousSearchsItem(index),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                color: isDarkMode ? Colors.black : Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Search Suggestions",
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: Colors.blue, // Change color to blue
                            // Add any other desired text style properties here
                          ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        // Implement search suggestions UI here
                        searchSuggestionsTiem("Warrenty"),
                        searchSuggestionsTiem("Date"),
                        searchSuggestionsTiem("Type"),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget previousSearchsItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {},
        child: Dismissible(
          key: GlobalKey(),
          onDismissed: (DismissDirection dir) {
            setState(() {});
            previousSearchs.removeAt(index);
          },
          child: Row(
            children: [
              const Icon(
                IconlyLight.time_circle,
                color: SecondaryText,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                previousSearchs[index],
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: mainText),
              ),
              const Spacer(),
              const Icon(
                Icons.call_made_outlined,
                color: SecondaryText,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget searchSuggestionsTiem(String text) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return Container(
      margin: EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
          color: isDarkMode ? FitnessAppTheme.dark_grey : form,
          borderRadius: BorderRadius.circular(30)),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: isDarkMode ? Colors.white : mainText),
      ),
    );
  }

  _custombottomSheetFilter(BuildContext context) {
    final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
    final isDarkMode = themeMode == ThemeModeType.dark;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        height: 600,
        color: isDarkMode ? SecondaryText : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Add a Filter",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            CustomCategoriesList(),
            CustomSlider(),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    text: "Cancel",
                    color: form,
                    textColor: mainText,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                      );
                    },
                    text: "Done",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:entitle_guard/Utils/fitness_app_theme.dart';
// import 'package:entitle_guard/Utils/theme.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';

// import '../../Utils/colors.dart';

// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';

// import 'Dashboard.dart';
// import '../../Components/CustomSlider.dart';
// import '../../Models/custom_Text_Form_fild.dart';
// import '../../Models/custom_button.dart';
// import '../../Components/custom_categories_list.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({Key? key}) : super(key: key);

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController searchController = TextEditingController();
//   static List previousSearchs = [];
//   late User user;

//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.currentUser!; // Initialize user variable
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
//     final isDarkMode = themeMode == ThemeModeType.dark;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: isDarkMode ? Colors.black : Colors.white,
//         body: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: [
//               // Search Bar
//               Container(
//                 color: isDarkMode ? Colors.black : Colors.white,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Row(
//                     children: [
//                       // IconButton(
//                       //     onPressed: () {
//                       //       Navigator.pop(context);
//                       //     },
//                       //     icon: const Icon(
//                       //       Icons.arrow_back_ios,
//                       //       color: mainText,
//                       //     )),
//                       Expanded(
//                         child: CostomTextFormFild(
//                           hint: "Serch",
//                           prefixIcon: IconlyLight.search,
//                           controller: searchController,
//                           filled: true,
//                           suffixIcon: searchController.text.isEmpty
//                               ? null
//                               : Icons.cancel_sharp,
//                           onTapSuffixIcon: () {
//                             searchController.clear();
//                           },
//                           onChanged: (pure) {
//                             setState(() {});
//                           },
//                           onEditingComplete: () {
//                             previousSearchs.add(searchController.text);
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Dashboard(user: user)),
//                             );
//                           },
//                         ),
//                       ),
//                       IconButton(
//                           onPressed: () {
//                             setState(() {
//                               showModalBottomSheet(
//                                   shape: const RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.vertical(
//                                       top: Radius.circular(25),
//                                     ),
//                                   ),
//                                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                                   context: context,
//                                   builder: (context) =>
//                                       _custombottomSheetFilter(context));
//                             });
//                           },
//                           icon: Icon(
//                             IconlyBold.filter,
//                             color: isDarkMode ? outline : mainText,
//                           )),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 8,
//               ),

//               // Previous Searches
//               Container(
//                 color: Colors.white,
//                 child: ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: previousSearchs.length,
//                     itemBuilder: (context, index) =>
//                         previousSearchsItem(index)),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),

//               // Search Suggestions
//               Container(
//                 width: double.infinity,
//                 color: isDarkMode ? Colors.black : Colors.white,
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Search Suggestions",
//                       style: Theme.of(context).textTheme.headline2!.copyWith(
//                             color: Colors.blue, // Change color to blue
//                             // Add any other desired text style properties here
//                           ),
//                     ),
//                     const SizedBox(
//                       height: 24,
//                     ),
//                     Row(
//                       children: [
//                         searchSuggestionsTiem("Warrenty"),
//                         searchSuggestionsTiem("Date"),
//                         searchSuggestionsTiem("Type"),
//                       ],
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   previousSearchsItem(int index) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: InkWell(
//         onTap: () {},
//         child: Dismissible(
//           key: GlobalKey(),
//           onDismissed: (DismissDirection dir) {
//             setState(() {});
//             previousSearchs.removeAt(index);
//           },
//           child: Row(
//             children: [
//               const Icon(
//                 IconlyLight.time_circle,
//                 color: SecondaryText,
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 previousSearchs[index],
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText2!
//                     .copyWith(color: mainText),
//               ),
//               const Spacer(),
//               const Icon(
//                 Icons.call_made_outlined,
//                 color: SecondaryText,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   searchSuggestionsTiem(String text) {
//     final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
//     final isDarkMode = themeMode == ThemeModeType.dark;
//     return Container(
//       margin: EdgeInsets.only(left: 8),
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//       decoration: BoxDecoration(
//           color: isDarkMode ? FitnessAppTheme.dark_grey : form,
//           borderRadius: BorderRadius.circular(30)),
//       child: Text(
//         text,
//         style: Theme.of(context)
//             .textTheme
//             .bodyText2!
//             .copyWith(color: isDarkMode ? Colors.white : mainText),
//       ),
//     );
//   }

//   _custombottomSheetFilter(BuildContext context) {
//     final themeMode = Provider.of<ThemeProviderNotifier>(context).themeMode;
//     final isDarkMode = themeMode == ThemeModeType.dark;
//     return SingleChildScrollView(
//       child: Container(
//         padding: EdgeInsets.all(20),
//         height: 600,
//         color: isDarkMode ? SecondaryText : Colors.white,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               "Add a Filter",
//               style: Theme.of(context).textTheme.headline3,
//             ),
//             CustomCategoriesList(),
//             CustomSlider(),
//             Row(
//               children: [
//                 Expanded(
//                   child: CustomButton(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     text: "Cancel",
//                     color: form,
//                     textColor: mainText,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: CustomButton(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => Dashboard(user: user)),
//                       );
//                     },
//                     text: "Done",
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
