import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/utilities/app_exception.dart';
import 'package:expense_tracker/models/color_categories.dart';
import 'package:expense_tracker/models/enum_categories.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/icon_categories.dart';
import 'package:expense_tracker/providers/expense_controller_provider.dart';
import 'package:expense_tracker/utilities/formatters.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({
    super.key,
    Expense? expense,
    required DateTime selectedDate,
  }) : _selectedDate = selectedDate,
       _expense = expense;

  final Expense? _expense;
  final DateTime _selectedDate;

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _priceController = TextEditingController();
  final _commentController = TextEditingController();
  Category? _selectedCategory;
  bool errorAmount = true;
  bool errorCategory = true;
  late DateTime _selectedDate;

  @override
  void dispose() {
    _priceController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final edit = widget._expense != null;

    if (edit) {
      _priceController.text = amountFormat(widget._expense!.amount);
      _selectedCategory = widget._expense!.category;
      final String comment = widget._expense!.comment == null
          ? ''
          : widget._expense!.comment!;
      _commentController.text = comment;
      errorAmount = false;
    }

    _selectedDate = widget._selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final editMode = widget._expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editMode ? "Edit Expense" : "Add Expense",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        scrolledUnderElevation: 0,
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Text(
                    "Amount",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 24,
                    ),
                    child: SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          suffix: const Text("RON"),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: errorAmount ? Colors.red : null,
                        ),
                        textAlign: TextAlign.center,
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
                  const SizedBox(height: 24),
                  Text(
                    "Category",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 48),
                  Text(
                    "Date",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final firstDate = DateTime(
                        now.year - 5,
                        now.month,
                        now.day,
                      );

                      final selectedDate = await showDatePicker(
                        context: context,
                        firstDate: firstDate,
                        lastDate: now,
                        initialDate: _selectedDate,
                      );

                      if (selectedDate != null &&
                          DateUtils.dateOnly(selectedDate) !=
                              DateUtils.dateOnly(_selectedDate)) {
                        setState(() {
                          _selectedDate = selectedDate;
                        });
                      }
                    },
                    child: Text(
                      formatDate(_selectedDate, [dd, ' ', MM, ' ', yyyy]),
                    ),
                  ),
                  const SizedBox(height: 48),
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
                      maxLength: 100,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: (errorAmount || _selectedCategory == null)
                          ? null
                          : () {
                              _saveExpenseOptimistic(editMode);
                            },
                      child: Text(
                        editMode ? "Save" : "Add",
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveExpenseOptimistic(bool isEditMode) {
    double amount = double.parse(_priceController.text.replaceAll(',', '.'));
    String comment = _commentController.text.trim();

    final expense = Expense(
      id: isEditMode ? widget._expense!.id : '',
      category: _selectedCategory!,
      amount: amount,
      comment: comment.isEmpty ? null : comment,
      date: _selectedDate,
      createdAt: isEditMode ? widget._expense!.createdAt : DateTime.now(),
    );

    final controllerNotifier = ref.read(expenseControllerProvider.notifier);

    Future<void> saveOperation;

    if (isEditMode) {
      saveOperation = controllerNotifier.updateExpense(
        widget._expense!.id,
        expense,
      );
    } else {
      saveOperation = controllerNotifier.addExpense(expense);
    }

    saveOperation.catchError((error) {
      String message = "Unknown error ocurred.";

      if (error is NetworkException) {
        message = error.message;
      } else if (error is PermissionException) {
        message = error.message;
      } else if (error is AppException) {
        message = error.message;
      }

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Colors.red),
          ),
          behavior: SnackBarBehavior.floating,
          // action: SnackBarAction(
          //   label: 'Retry',
          //   textColor: Colors.white,
          //   onPressed: () {},
          // ),
          showCloseIcon: true,
        ),
      );
    });

    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }
}
