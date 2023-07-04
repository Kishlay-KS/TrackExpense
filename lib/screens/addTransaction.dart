import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:track_expenses/models/expenseTile.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  List<String> items = ["Expense", "Income"];
  List<String> categories = [
    "Food",
    "Travel",
    "Stationery",
    "Grocery",
    "Friend"
  ];
  List<String> modes = ["Cash", "UPI", "Other"];
  String mode = "Cash";
  String chosenValue = "Expense";
  String cat = "Food";
  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments;
    print(email);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Icon(
            Icons.logout,
            color: Colors.black,
            size: 30,
          ),
          backgroundColor: Colors.amber[400],
        ),
        backgroundColor: Colors.black,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white.withOpacity(0.3),
            // actions: [
            //   IconButton(
            //       onPressed: () {
            //         Navigator.pushReplacementNamed(context, '/home');
            //       },
            //       icon: Icon(
            //         Icons.logout,
            //         size: 30,
            //         color: Colors.black,
            //       ))
            // ],
            title: Center(
              child: Text(
                "Add Transaction",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            )),
        body: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Transaction Type",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        DropdownButton(
                            dropdownColor: Colors.amber[400],
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            value: chosenValue,
                            items: items
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                chosenValue = value!;
                              });
                            }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0, 25, 25),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Choose Category",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          DropdownButton(
                              dropdownColor: Colors.amber[400],
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 20,
                              value: cat,
                              items: categories.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  cat = value!;
                                });
                              }),
                        ],
                      )),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0, 25, 25),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.white.withOpacity(0.3),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Payment Mode",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 65,
                          ),
                          DropdownButton(
                              dropdownColor: Colors.amber[400],
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              value: mode,
                              items: modes.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  mode = value!;
                                });
                              }),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: amountController,
                      minLines: 1,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      // controller: myController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Amount',
                        labelStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        icon: Icon(
                          Icons.attach_money,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
                  child: SizedBox(
                      height: 70,
                      width: 400,
                      child: Builder(builder: (context) {
                        return ElevatedButton(
                          onPressed: () async {
                            // String newEvent = myController.text;
                            // await DatabaseService().addEventDetails(newEvent);
                            // Navigator.of(context).pop(newEvent);
                            if (amountController.text != "") {
                              await FirebaseFirestore.instance
                                  .collection(email.toString())
                                  .doc()
                                  .set({
                                'type': chosenValue,
                                'category': cat,
                                'mode': mode,
                                'amount': amountController.text,
                                'time': DateTime.now()
                              });
                            }
                            String money = (amountController.text);
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80),
                              ),
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.white),
                              backgroundColor: Colors.white),
                        );
                      })),
                ),
              ],
            ),
          ),
        ));
  }
}
