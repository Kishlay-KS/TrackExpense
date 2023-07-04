import 'dart:ui';

import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;

  const ExpenseTile(
      {super.key,
      required this.name,
      required this.amount,
      required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('${dateTime.day} / ${dateTime.month} / ${dateTime.year}'),
      trailing: Text(amount),
    );
  }
}

class myCard extends StatelessWidget {
  final String amount;
  final String category;
  final String mode;
  final String type;
  final String time;
  final Future Function() removeExpense;

  const myCard(
      {super.key,
      required this.amount,
      required this.category,
      required this.mode,
      required this.type,
      required this.time,
      required this.removeExpense});

  @override
  Widget build(BuildContext context) {
    String img = "";
    String modeimg = "";
    if (mode == "Cash") modeimg = "cash.png";
    if (mode == "UPI") modeimg = "upi.png";
    if (mode == "Other") modeimg = "other.jpg";

    if (category == "Food") img = "food.jpg";
    if (category == "Friend") img = "pic.png";
    if (category == "Grocery") img = "grocery.jpg";
    if (category == "Stationery") img = "stationery.jpg";
    if (category == "Travel") img = "travel.jpg";
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 5, 5),
      height: 100,
      width: MediaQuery.sizeOf(context).width / 2,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.asset(
                      "assets/images/$img",
                      height: 40,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    "$category".toUpperCase(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                width: 8,
              ),
              Row(
                children: [
                  Text(
                    "Rs. $amount",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  IconButton(
                    onPressed: removeExpense,
                    icon: Icon(
                      Icons.highlight_remove,
                      color: Colors.white,
                    ),
                    // iconSize: 25,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                "$time",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
              SizedBox(
                width: 100,
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/images/$modeimg",
                    height: 40,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "$mode",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              // SizedBox(
              //   width: 5,
              // ),
            ],
          )
        ],
      ),
    );
  }
}
