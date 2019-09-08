import 'package:flutter/material.dart';

class Bars extends StatelessWidget {
  final label;
  final double spendingAmount;
  final double spendingPercent;

  Bars(this.label, this.spendingAmount, this.spendingPercent);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: <Widget>[
          Container(
            height: constraints.maxHeight * .15,
            child: FittedBox(
                child: Text('\$${spendingAmount.toStringAsFixed(0)}')),
          ),
          SizedBox(
            height: constraints.maxHeight * .05,
          ),
          Container(
            height: constraints.maxHeight * .6,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black87,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(220, 220, 220, 1)),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPercent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * .05,
          ),
          Container(
            height: constraints.maxHeight * .15,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      );
    });
  }
}
