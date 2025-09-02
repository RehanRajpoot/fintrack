import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/transaction_provider.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final bool isDarkMode;

  const TransactionList({
    Key? key,
    required this.transactions,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = isDarkMode
        ? Colors.grey[900]!.withOpacity(0.4)
        : Colors.grey[200]!.withOpacity(0.4);
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No transactions yet',
          style: GoogleFonts.poppins(color: textColor, fontSize: 16),
        ),
      );
    }

    final provider = Provider.of<TransactionProvider>(context, listen: false);

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (ctx, i) {
        final tx = transactions[i];
        return GestureDetector(
          onLongPress: () async {
            bool? confirm = await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Delete Transaction?'),
                content: Text(
                  'Are you sure you want to delete this transaction?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text('Delete'),
                  ),
                ],
              ),
            );

            if (confirm != null && confirm) {
              await provider.deleteTransaction(tx.id!);
            }
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: cardColor,
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: tx.type == 'income'
                    ? Colors.greenAccent.withOpacity(0.85)
                    : Colors.redAccent.withOpacity(0.85),
                child: Icon(
                  tx.type == 'income'
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  color: Colors.white,
                ),
              ),
              title: Text(
                tx.title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              subtitle: Text(
                tx.date,
                style: GoogleFonts.poppins(color: textColor, fontSize: 14),
              ),
              trailing: Text(
                '${tx.type == 'income' ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: tx.type == 'income'
                      ? Colors.greenAccent
                      : Colors.redAccent,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
