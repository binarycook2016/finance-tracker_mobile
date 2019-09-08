import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;

  TransactionList(this.userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions yet!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constraints.maxHeight * .6,
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: Image.asset(
                        'assets/images/stone.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (context, i) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: FittedBox(
                          child: Text('\$${userTransactions[i].amount}')),
                    ),
                  ),
                  title: Text(
                    userTransactions[i].title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(userTransactions[i].date)),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? FlatButton.icon(
                          textColor: Theme.of(context).errorColor,
                          icon: Icon(
                            Icons.delete,
                          ),
                          label: Text('Delete'),
                          onPressed: () =>
                              deleteTransaction(userTransactions[i].id),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          onPressed: () =>
                              deleteTransaction(userTransactions[i].id),
                        ),
                ),
              );
            },
            itemCount: userTransactions.length,
          );
  }
}
