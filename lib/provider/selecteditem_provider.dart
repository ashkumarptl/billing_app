import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/item_model.dart';



final selectedItemsProvider =
    StateNotifierProvider<SelectedItemsNotifier, List<Items>>(
      (ref) => SelectedItemsNotifier(),
    );

class SelectedItemsNotifier extends StateNotifier<List<Items>> {
  SelectedItemsNotifier() : super([]);

  void toggleItem(Items item) {
    final index = state.indexWhere((e) => e.id == item.id);
    print("this is selectedItem index  $index");
    if (index != -1) {
      state = [...state]..removeAt(index);
    } else {
      state = [...state, item.copyWith()];
    }
  }

  void addItem(Items item) {
    state = [...state, item];
  }

  void deleteItem(String id) {
    state = [
      for (final item in state)
        if (item.id != id) item,
    ];
  }

  void editItem(Items item) {
    state = [
      for (final i in state)
        if (i.id == item.id) item else i,
    ];
  }

  void increaseQuantity(String id) {
    state =
        state.map((item) {
          if (item.id == id) {
            return item.copyWith(quantity: item.quantity + 1);
          }
          return item;
        }).toList();
  }

  void decreaseQuantity(String id) {
    state =
        state.map((item) {
          if (item.id == id && item.quantity > 1) {
            return item.copyWith(quantity: item.quantity - 1);
          }
          return item;
        }).toList();
  }

  void clearSelectedItems() {
    state = [];
  }

  void resetQuantity() {
    state =
        state.map((item) {
          return item.copyWith(quantity: 1);
        }).toList();
  }
}
