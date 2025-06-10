import 'package:billing_app/model/item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../model/record_model.dart';

final itemsBoxProvider = Provider<Box<Items>>((ref) => throw UnimplementedError());

final itemsProvider = StateNotifierProvider<ItemNotifier, List<Items>>((ref) {
  final box = ref.watch(itemsBoxProvider);
  return ItemNotifier(box);
});

class ItemNotifier extends StateNotifier<List<Items>> {
  late Box<Items> _box;

  ItemNotifier(this._box) : super(_box.values.toList());

  void _syncHive() {
    _box.clear(); // remove all
    for (var item in state) {
      _box.put(item.id, item); // key = item.id
    }
  }

  void addItem(Items item) {
    state = [...state, item];
    _box.put(item.id, item);
  }

  void editItem(Items item) {
    state = [
      for (final i in state)
        if (i.id == item.id) item else i,
    ];
    _box.put(item.id, item);
  }

  void deleteItem(String id) {
    state = [
      for (final item in state)
        if (item.id != id) item,
    ];
    _box.delete(id);
  }

  void updateQuantity(String id, int delta) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(quantity: (item.quantity + delta).clamp(0, 9999))
        else
          item,
    ];
    _syncHive();
  }

  void setQuantity(String id, double newQuantity) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(quantity: newQuantity)
        else
          item
    ];
    _syncHive();
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
final billsBoxProvider = Provider<Box<Bill>>((ref) => throw UnimplementedError());

final billsProvider = StateNotifierProvider<BillsNotifier, List<Bill>>((ref) {

  final box = ref.watch(billsBoxProvider);

  return BillsNotifier(box);
});

class BillsNotifier extends StateNotifier<List<Bill>> {

  late Box<Bill> _box;

  BillsNotifier(this._box) : super(_box.values.toList());


  void _syncHive() {
    _box.clear();
    for (var bill in state) {
      _box.put(bill.id, bill);
    }
  }

  void addBill(Bill bill) {
    state = [...state, bill];
    _box.put(bill.id, bill);
  }

  void deleteBill(String id) {
    state = state.where((bill) => bill.id != id).toList();
    _box.delete(id);
  }

  void markAsPaid(String id) {
    state = [
      for (final bill in state)
        if (bill.id == id) bill.copyWith(isPaid: true) else bill,
    ];
    _syncHive();
  }


// Optionally: Add methods to persist to local storage
}
