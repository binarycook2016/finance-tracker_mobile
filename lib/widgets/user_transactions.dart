import 'package:flutter/material.dart';

import './transaction_list.dart';
import './new_transaction.dart';
import '../models/transaction.dart';

class UserTransactions extends StatefulWidget {
  @override
  _UserTransactionsState createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'new thing1',
      amount: 29.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't1',
      title: 'new thing2',
      amount: 45.99,
      date: DateTime.now(),
    )
  ];

  void _addNewTransaction(String txTitle, double txAmt) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmt,
      date: DateTime.now(),
      id: DateTime.now().toString(),
    );
    setState(() => _userTransactions.add(newTx));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NewTransaction(_addNewTransaction),
        TransactionList(_userTransactions)
      ],
    );
  }
}
