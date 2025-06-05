import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/record_model.dart';

class RecordTile extends StatelessWidget {

  const RecordTile({super.key, required this.records});

  final Bill records;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //left column
              Column(
                children: [
                  Text('${records.customerName}\n ${records.totalAmount}'),
                ],
              ),
              //right column
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${records.items[0].quantity} | ${DateFormat.yMd().format(records.date)}',
                      ),
                    ],
                  ),
                  Text(records.totalAmount.toString()),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  print('cash cliked');
                },
                child: Container(
                  height: 25,
                  width: 105,
                  alignment: Alignment.center,
                  child: Text('Cash'),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  print('upi cliked');
                },
                child: Container(
                  height: 25,
                  width: 105,
                  alignment: Alignment.center,
                  child: Text('UPI'),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  print('cheque cliked');
                },
                child: Container(
                  height: 25,
                  width: 105,
                  alignment: Alignment.center,
                  child: Text('Cheque'),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
