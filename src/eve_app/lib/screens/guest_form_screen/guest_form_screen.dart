import 'package:eve_app/constants/app_sizes.dart';
import 'package:eve_app/providers/guest_provider.dart';
import 'package:flutter/material.dart';

import 'package:eve_app/models/guest.dart';
import 'package:provider/provider.dart';

class GuestFormScreen extends StatefulWidget {
  final Guest? guestToEdit;
  const GuestFormScreen({
    Key? key,
    this.guestToEdit,
  }) : super(key: key);

  @override
  State<GuestFormScreen> createState() => _GuestFormScreenState();
}

class _GuestFormScreenState extends State<GuestFormScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isEditMode = false;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  bool? willCome;
  bool submitIsLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.guestToEdit != null) {
      isEditMode = true;
      firstNameController.text = widget.guestToEdit!.firstname;
      lastNameController.text = widget.guestToEdit!.lastname;
      willCome = widget.guestToEdit!.willCome;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        title: isEditMode ? Text("Modification de l'invité : ${widget.guestToEdit!.getFullName()}") : const Text("Ajout d'un Invité"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.calcScreenHorizontalPadding(sWidth) + 4),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (willCome != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.guestToEdit!.getFullName(),
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                "Sera présent :",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Switch(
                                  value: willCome!,
                                  onChanged: (newValue) async {
                                    setState(() {
                                      willCome = newValue;
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: "Prénom",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Prénom requis';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: "Nom",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nom requis';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: submitIsLoading
                                ? null
                                : () {
                                    submit();
                                  },
                            child: isEditMode ? const Text('Mettre à jour') : const Text("Ajouter"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      bool submitSuccess = false;
      setState(() {
        submitIsLoading = true;
      });
      GuestProvider guestProvider = Provider.of<GuestProvider>(context, listen: false);
      if (isEditMode) {
        submitSuccess = await guestProvider.updateGuest(
            context,
            widget.guestToEdit!.copyWith(
              firstname: firstNameController.text,
              lastname: lastNameController.text,
              willCome: willCome,
            ));
      } else {
        submitSuccess = await guestProvider.addNewGuest(
            context,
            Guest(
              id: -1,
              firstname: firstNameController.text,
              lastname: lastNameController.text,
              willCome: true,
            ));
      }
      setState(() {
        submitIsLoading = false;
      });
      if (submitSuccess && context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
