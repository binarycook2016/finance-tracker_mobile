import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  // Determines the orientation the app will rotate into
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft, // Disable for testing
    DeviceOrientation.landscapeRight, // Disable for testing
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.blueGrey[700],
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            subtitle: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
            ),
            button: TextStyle(color: Colors.black87)),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'Roosevelt',
                    fontSize: 50,
                    color: Colors.black87),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    ),
    Transaction(
      id: 't1',
      title: 'new thing3',
      amount: 29.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't1',
      title: 'new thing4',
      amount: 45.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't1',
      title: 'new thing5',
      amount: 29.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't1',
      title: 'new thing6',
      amount: 45.99,
      date: DateTime.now(),
    )
  ];

  bool _chartToggle = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmt, DateTime txDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmt,
      date: txDate,
      id: DateTime.now().toString(),
    );
    setState(() => _userTransactions.add(newTx));
  }

  void _deleteTransaction(String txId) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == txId);
    });
  }

  void _newTransactionModal(BuildContext modalContext) {
    showModalBottomSheet(
        context: modalContext,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  List<Widget> _buildLandscapeLayout(offset, Widget listWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Show Chart",
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _chartToggle,
            onChanged: (status) {
              setState(() {
                _chartToggle = status;
              });
            },
          ),
        ],
      ),
      _chartToggle
          ? Container(
              height: offset * .7,
              child: Chart(_recentTransactions),
            )
          : listWidget
    ];
  }

  List<Widget> _buildPortraitLayout(offset, Widget listWidget) {
    return [
      Container(
        height: offset * .3,
        child: Chart(_recentTransactions),
      ),
      listWidget
    ];
  }

  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Codettastone'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _newTransactionModal(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Codettastone'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _newTransactionModal(context),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context);
    final isLandscape = device.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = _buildAppBar();

    final listWidget = Container(
      height: (device.size.height -
              device.padding.top -
              appBar.preferredSize.height) *
          .7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final offset =
        device.size.height - appBar.preferredSize.height - device.padding.top;

    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (!isLandscape) ..._buildPortraitLayout(offset, listWidget),
            if (isLandscape) ..._buildLandscapeLayout(offset, listWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? null
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _newTransactionModal(context),
                  ),
          );
  }
}
