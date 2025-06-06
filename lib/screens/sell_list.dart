import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/item_provider.dart'; // adjust import path
import '../model/record_model.dart';
import 'bill_detail.dart'; // contains the Bill model

class SellReports extends ConsumerStatefulWidget {
  const SellReports({super.key});

  @override
  ConsumerState<SellReports> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<SellReports> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bills = ref.watch(billsProvider);

    if (bills.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No bills recorded yet.')),
      );
    }

    // Apply search filter
    final filteredBills = bills.where((bill) {
      final query = searchQuery.toLowerCase();
      final billId = bill.id.toLowerCase();
      final billDate = "${bill.date.year}-${bill.date.month.toString().padLeft(2, '0')}-${bill.date.day.toString().padLeft(2, '0')}";
      return billId.contains(query) || billDate.contains(query);
    }).toList();

    // Group filtered bills by date
    final grouped = <String, List<Bill>>{};
    for (final bill in filteredBills) {
      final dateKey = "${bill.date.year}-${bill.date.month.toString().padLeft(2, '0')}-${bill.date.day.toString().padLeft(2, '0')}";
      grouped[dateKey] = [...grouped[dateKey] ?? [], bill];
    }

    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(title: const Text('Report / History')),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Bill ID or Date (yyyy-mm-dd)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                      searchController.clear();
                    });
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                setState(() => searchQuery = value.trim());
              },
            ),
          ),

          // 📜 Bill List
          Expanded(
            child: sortedDates.isEmpty
                ? const Center(child: Text('No matching bills found.'))
                : ListView.builder(
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final billsForDate = grouped[date]!;

                return ExpansionTile(
                  title: Text(date),
                  children: billsForDate.map((bill) {
                    return ListTile(
                      title: Text("Bill ID: ${bill.id.substring(0, 6)}"),
                      subtitle: Text("Total: ₹${bill.totalAmount.toStringAsFixed(2)}"),
                      trailing: Icon(
                        bill.isPaid ? Icons.check_circle : Icons.pending,
                        color: bill.isPaid ? Colors.green : Colors.orange,
                      ),
                      onTap: () {
                        // Optional: View bill details
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BillDetailsScreen(bill: bill),
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
