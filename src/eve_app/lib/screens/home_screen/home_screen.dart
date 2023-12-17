import 'package:eve_app/constants/app_colors.dart';
import 'package:eve_app/constants/app_sizes.dart';
import 'package:eve_app/models/guest.dart';
import 'package:eve_app/providers/guest_provider.dart';
import 'package:eve_app/screens/guest_form_screen/guest_form_screen.dart';
import 'package:eve_app/screens/home_screen/components/guests_list_widget.dart';
import 'package:eve_app/services/auth_service.dart';
import 'package:eve_app/widgets/buttons/light_dark_mode_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchTerm = "";
  final FocusNode searchTermFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();

  bool showGuestsWhoWillCome = true;
  bool showGuestsWhoWillNotCome = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GuestProvider guestProvider = Provider.of<GuestProvider>(context, listen: false);
      guestProvider.getGuestsOnline(context); //on fait un premier appel
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sWidth = size.width;
    GuestProvider guestProvider = Provider.of<GuestProvider>(context);
    List<Guest> guests = guestProvider.guests ?? [];
    guests = searchedAndFilteredGuests(guests);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Invités"),
            automaticallyImplyLeading: false,
            actions: [
              const LightDarkModeButton(),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                icon: const Icon(Icons.logout), // Power-off icon for log out
                onPressed: () async {
                  await AuthService().userDisconnect(context: context);
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GuestFormScreen()));
              },
              label: const Text("Ajouter un invité")),
          body: Column(
            children: [
              const SizedBox(
                height: AppSizes.contentTopPadding - 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.calcScreenHorizontalPadding(sWidth)),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: showGuestsWhoWillCome,
                                onChanged: (value) {
                                  setState(() {
                                    showGuestsWhoWillCome = value!;
                                  });
                                },
                              ),
                              sWidth > AppSizes.screenBreakPointTablet ? const Text('Afficher les invités présents') : const Text('Présents')
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: showGuestsWhoWillNotCome,
                                onChanged: (value) {
                                  setState(() {
                                    showGuestsWhoWillNotCome = value!;
                                  });
                                },
                              ),
                              sWidth > AppSizes.screenBreakPointTablet ? const Text('Afficher les invités absents') : const Text('Absents'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.calcScreenHorizontalPadding(sWidth) + 4),
                child: Row(
                  children: [
                    SizedBox(
                        height: AppSizes.searchRowHeight,
                        child: ElevatedButton(
                            onPressed: () {
                              guestProvider.getGuestsOnline(context); //pour actualiser la liste
                            },
                            child: const Icon(Icons.refresh))),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: AppSizes.searchRowHeight,
                        child: Card(
                          margin: EdgeInsets.zero,
                          // borderRadius: BorderRadius.circular(10),
                          // color: Theme.of(context).colorScheme.surface,
                          elevation: 2,
                          child: TextField(
                            focusNode: searchTermFocusNode,
                            onChanged: (value) {
                              setState(() {
                                searchTerm = value;
                              });
                            },
                            onTapOutside: (event) {
                              searchTermFocusNode.unfocus();
                            },
                            // textAlignVertical: TextAlignVertical.top,
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: "Rechercher",
                              // hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: const Icon(
                                Icons.search,
                                // color: AppColors.mainColor,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  // color: AppColors.mainColor,
                                ),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() {
                                    searchTerm = "";
                                  });
                                },
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: guestProvider.guestsIsLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : guests.isEmpty
                        // ignore: prefer_const_constructors
                        ? Center(child: const Text("Aucun invité"))
                        : GuestsListWidget(guests: guests),
              ),
            ],
          )),
    );
  }

  List<Guest> searchedAndFilteredGuests(List<Guest> allGuests) {
    String lowerCaseSearchTerm = searchTerm.toLowerCase();
    List<Guest> searchFilteredGuests = allGuests.where((guest) {
      return ((guest.willCome == true && showGuestsWhoWillCome) || (guest.willCome == false && showGuestsWhoWillNotCome)) &&
          ((searchTerm == "") ||
              ("${guest.id}".contains(lowerCaseSearchTerm) || guest.firstname.toLowerCase().contains(lowerCaseSearchTerm) || guest.lastname.toLowerCase().contains(lowerCaseSearchTerm)));
    }).toList();

    return searchFilteredGuests;
  }
}
