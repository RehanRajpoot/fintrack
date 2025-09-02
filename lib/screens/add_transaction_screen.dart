import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  String type = 'income';
  DateTime selectedDate = DateTime.now();

  void submit() {
    if (titleController.text.isEmpty || amountController.text.isEmpty) return;

    final tx = TransactionModel(
      title: titleController.text,
      amount: double.parse(amountController.text),
      type: type,
      date: DateFormat('yyyy-MM-dd').format(selectedDate),
    );

    Provider.of<TransactionProvider>(context, listen: false).addTransaction(tx);
    Navigator.pop(context);
  }

  void pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                DropdownButton<String>(
                  value: type,
                  items: ['income', 'expense']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => type = val!),
                ),
                Spacer(),
                TextButton(
                  onPressed: pickDate,
                  child: Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: submit, child: Text('Add')),
          ],
        ),
      ),
    );
  }
}
