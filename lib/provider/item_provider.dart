import 'package:billing_app/model/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/record_model.dart';

final itemsProvider = StateNotifierProvider<ItemNotifier, List<Items>>((ref) {
  return ItemNotifier();
});

class ItemNotifier extends StateNotifier<List<Items>> {
  ItemNotifier() : super([]);

  void addItem(Items item) {
    state = [...state, item];
  }

  void editItem(Items item) {
    state = [
      for (final i in state)
        if (i.id == item.id) item else i,
    ];
  }

  void deleteItem(String id) {
    state = [
      for (final item in state)
        if (item.id != id) item,
    ];
  }

  void updateQuantity(String id, int delta) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(quantity: (item.quantity + delta).clamp(0, 9999))
        else
          item,
    ];
  }

  void setQuantity(String id, double newQuantity) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(quantity: newQuantity)
        else
          item
    ];
  }


}

//filter

final searchQueryProvider = StateProvider<String>((ref) => '');
final filterOptionProvider = StateProvider<String>((ref) => 'All');
final isSearchProvider = StateProvider<bool>((ref) => false);
final isEditableProvider = StateProvider((ref)=>false);

final filteredItemsProvider = Provider<List<Items>>((ref) {
  final items = ref.watch(itemsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final filter = ref.watch(filterOptionProvider);

  List<Items> filtered = items.where((item) {
    return item.productName.toLowerCase().contains(query);
  }).toList();

  if (filter == 'Low Quantity') {
    filtered = filtered.where((item) => item.quantity <= 5).toList();
  } else if (filter == 'Price > 100') {
    filtered = filtered.where((item) => item.price > 100).toList();
  }

  return filtered;
});



//bill

final billsProvider = StateNotifierProvider<BillsNotifier, List<Bill>>((ref) {
  return BillsNotifier();
});

class BillsNotifier extends StateNotifier<List<Bill>> {
  BillsNotifier() : super([]);

  void addBill(Bill bill) {
    state = [...state, bill];
  }

  void deleteBill(String id) {
    state = state.where((bill) => bill.id != id).toList();
  }

  void markAsPaid(String id) {
    state = [
      for (final bill in state)
        if (bill.id == id) bill.copyWith(isPaid: true) else bill,
    ];
  }


// Optionally: Add methods to persist to local storage
}
