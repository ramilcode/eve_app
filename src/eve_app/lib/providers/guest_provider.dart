import 'package:eve_app/http/http_guest.dart';
import 'package:eve_app/models/guest.dart';
import 'package:eve_app/utils/print_utils.dart';
import 'package:eve_app/widgets/popups/toast.dart';

import 'package:flutter/widgets.dart';

class GuestProvider extends ChangeNotifier {
  bool _guestsIsLoading = false;
  List<Guest> _guests = [];

  List<Guest>? get guests => _guests;
  bool get guestsIsLoading => _guestsIsLoading;

  ///gets online guests and updates the data inside the provider
  Future<void> getGuestsOnline(BuildContext context) async {
    _guestsIsLoading = true;
    notifyListeners();
    final (bool hadApiError, List<Guest>? guestsOnline) = await HttpGuest.getGuests(context);
    if (!hadApiError) {
      _guests = guestsOnline ?? [];
    }
    _guestsIsLoading = false;
    notifyListeners();
  }

  Future<bool> updateGuest(BuildContext context, Guest guestToUpdate) async {
    AppToast.showToast("Mise à jour de l'invité en cours ...", context: context, toastDurationEnum: ToastDurationEnum.short);
    final (bool hadApiError, Guest? onlineUpdatedGuest) = await HttpGuest.putGuest(context, guestToPut: guestToUpdate);
    if (!hadApiError && onlineUpdatedGuest != null) {
      int indexOfGuestToReplace = _guests.indexWhere((element) => element.id == onlineUpdatedGuest.id);
      _guests[indexOfGuestToReplace] = onlineUpdatedGuest;
      AppToast.showToast('Invité "${onlineUpdatedGuest.getFullName()}" mis à jour', context: context, toastDurationEnum: ToastDurationEnum.short);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> addNewGuest(BuildContext context, Guest guestToPost) async {
    AppToast.showToast("Ajout de l'invité en cours ...", context: context, toastDurationEnum: ToastDurationEnum.short);
    final (bool hadApiError, Guest? onlineAddedGuest) = await HttpGuest.postGuest(context, guestToPost: guestToPost);
    if (!hadApiError && onlineAddedGuest != null) {
      _guests.add(onlineAddedGuest);
      AppToast.showToast('Invité "${onlineAddedGuest.getFullName()}" ajouté', context: context, toastDurationEnum: ToastDurationEnum.short);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> deleteGuest(BuildContext context, Guest guestToDelete) async {
    AppToast.showToast("Suppression l'invité en cours ...", context: context, toastDurationEnum: ToastDurationEnum.short);
    final (bool hadApiError, dynamic response) = await HttpGuest.deleteGuest(context, guestToDelete: guestToDelete, printResponse: true);
    if (!hadApiError && response != null) {
      // int indexOfGuestToReplace = _guests.indexWhere((element) => element.id == guestToDelete.id);
      _guests.removeWhere((element) => element.id == guestToDelete.id);
      AppToast.showToast('Invité "${guestToDelete.getFullName()}" supprimé', context: context, toastDurationEnum: ToastDurationEnum.short);
      notifyListeners();
      return true;
    }
    return false;
  }

  void setGuests(List<Guest>? newGuests) {
    printF("GuestProvider:setGuests");
    _guests = newGuests ?? [];
    notifyListeners();
  }

  void reset() {
    printF("ActorProvider:reset");
    _guests = [];
    _guestsIsLoading = false;
    notifyListeners();
  }
}
