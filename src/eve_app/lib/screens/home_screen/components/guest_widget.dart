import 'package:eve_app/constants/app_sizes.dart';
import 'package:eve_app/providers/guest_provider.dart';
import 'package:eve_app/screens/guest_form_screen/guest_form_screen.dart';
import 'package:eve_app/utils/app_utils.dart';
import 'package:eve_app/utils/device_utils.dart';
import 'package:eve_app/widgets/popups/app_dialog.dart';
import 'package:flutter/material.dart';

import 'package:eve_app/models/guest.dart';
import 'package:provider/provider.dart';

class GuestWidget extends StatelessWidget {
  final Guest guest;
  const GuestWidget({
    Key? key,
    required this.guest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sWidth = size.width;
    GuestProvider guestProvider = Provider.of<GuestProvider>(context, listen: false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GuestFormScreen(guestToEdit: guest)));
                        },
                        child: const Icon(
                          Icons.edit,
                        )),
                    TextButton(
                        onPressed: () {
                          AppDialog.showDialogAllCustom(
                              contextParent: context,
                              title: "Suppression d'un invité",
                              textButtonValidR: "Oui, supprimer",
                              textButton: "Non, annuler",
                              colorButtonValidR: Theme.of(context).colorScheme.error,
                              colorButton: Theme.of(context).colorScheme.onSurface,
                              content: Text(
                                "Voulez-vous vraiment supprimer l'invité ${guest.getFullName()} ?",
                                // textAlign: TextAlign.center,
                              ),
                              onPressCustomValidR: () async {
                                await guestProvider.deleteGuest(context, guest);
                              });
                        },
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        )),
                    if (sWidth > AppSizes.screenBreakPointTablet) ...[
                      labelAndValue(context, "ID :", "${guest.id}"),
                      labelAndValue(context, "Prenom :", guest.firstname),
                      labelAndValue(context, "Nom :", guest.lastname),
                    ],
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Sera présent :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Switch(
                        value: guest.willCome,
                        onChanged: (newValue) async {
                          await guestProvider.updateGuest(context, guest.copyWith(willCome: newValue));
                        }),
                  ],
                )
              ],
            ),
            if (sWidth <= AppSizes.screenBreakPointTablet)
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        labelAndValue(context, "ID :", "${guest.id}"),
                        labelAndValue(context, "Prenom :", guest.firstname),
                        labelAndValue(context, "Nom :", guest.lastname),
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget labelAndValue(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => GuestFormScreen(guestToEdit: guest)));
              },
              child: Text(value))
        ],
      ),
    );
  }
}
