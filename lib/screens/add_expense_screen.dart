import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/providers/selected_date_provider.dart';
import 'package:expense_tracker/models/color_categories.dart';
import 'package:expense_tracker/models/enum_categories.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/icon_categories.dart';
import 'package:expense_tracker/providers/expense_controller_provider.dart';
import 'package:expense_tracker/utilities/formatters.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({
    super.key,
  });

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _priceController = TextEditingController();
  final _commentController = TextEditingController();
  Category? _selectedCategory;
  bool errorAmount = true;
  bool errorCategory = true;

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch<DateTime>(selectedDateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Amount"),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  suffix: const Text("RON"),
                ),
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: errorAmount ? Colors.red : Colors.black,
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      errorAmount = true;
                    });
                    return;
                  }

                  String strAmount = value.replaceAll(',', '.');
                  double? amount = double.tryParse(strAmount);
                  int i = strAmount.indexOf('.');

                  if (i >= 1 &&
                      (amount == null ||
                          strAmount.substring(i + 1).length > 2)) {
                    setState(() {
                      errorAmount = true;
                    });
                  } else {
                    setState(() {
                      errorAmount = false;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Category"),
          DropdownButton<Category>(
            hint: const Text("Select a category"),
            items: iconCategories.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(capitalize(entry.key.name)),
                    const SizedBox(width: 6),
                    Icon(
                      entry.value,
                      color: colorCategories[entry.key],
                    ),
                  ],
                ),
              );
            }).toList(),
            value: _selectedCategory,
            onChanged: (selectedValue) {
              if (selectedValue != null) {
                setState(() {
                  _selectedCategory = selectedValue;
                  errorCategory = false;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                label: const Text("Comment"),
              ),
              maxLength: 128,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: errorAmount || errorCategory
                  ? null
                  : () {
                      double amount = double.parse(
                        _priceController.text.replaceAll(',', '.'),
                      );
                      String comment = _commentController.text.trim();

                      Expense expense = Expense(
                        category: _selectedCategory!,
                        amount: amount,
                        comment: comment.isEmpty ? null : comment,
                        date: selectedDate,
                        createdAt: DateTime.now(),
                      );

                      ref
                          .read(expenseControllerProvider.notifier)
                          .addExpense(expense);

                      Navigator.pop(context);
                    },
              child: const Text(
                "Add",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
