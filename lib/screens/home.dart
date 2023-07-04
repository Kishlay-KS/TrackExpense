import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_expenses/services/AuthServices.dart';
import 'package:track_expenses/services/database_functions.dart';
import 'package:track_expenses/models/cards.dart';
import 'package:track_expenses/models/expenseModel.dart';
import 'package:track_expenses/models/expenseTile.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? user = FirebaseAuth.instance.currentUser!.email;
  String? name = FirebaseAuth.instance.currentUser!.displayName;
  FirebaseFirestore db = FirebaseFirestore.instance;
  int sum = 0;
  int total = 0;
  // final Stream<QuerySnapshot> _stream =
  //     FirebaseFirestore.instance.collection(user).snapshots();
  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance.collection(user!).get().then(
      (querySnapshot) {
        querySnapshot.docs.forEach((result) {
          sum = sum + int.parse(result.data()['amount']);
        });
        setState(() {
          total = sum;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String money = "0";
    // money += ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber[400],
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/addTransaction', arguments: user);
          }),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white.withOpacity(0.3),
        title: Center(
            child: Row(
          children: [
            Text(
              'Welcome ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '$name !',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic),
            )
          ],
        )),
        actions: [
          IconButton(
              onPressed: () {
                AuthServices.signUserOut(context);
                Navigator.pushReplacementNamed(context, '/Login');
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
              child: TopNeuCard(
                  height: 150,
                  balance: (10000 - total).toString(),
                  expense: total.toString(),
                  income: "Rs.10000"),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Statistics",
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () async {
                                  final List<ExpenseDatabase> datalist = [];
                                  await db.collection(user!).get().then(
                                    (querySnapshot) {
                                      print("Successfully completed");
                                      for (var docSnapshot
                                          in querySnapshot.docs) {
                                        var data = ExpenseDatabase.fromJson(
                                            docSnapshot.data());
                                        print(
                                            int.parse(data.amount).runtimeType);
                                        setState(() {
                                          datalist.add(data);
                                        });
                                      }
                                      print(datalist);
                                    },
                                    onError: (e) =>
                                        print("Error completing: $e"),
                                  );

                                  Navigator.pushNamed(context, '/statistics',
                                      arguments: {'data': datalist});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber[400],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_right_alt_rounded,
                                      size: 50,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
                      color: Colors.white,
                    ),
                  ),
                )),
            Flexible(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection(user!).snapshots(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Future remove() => FirebaseFirestore.instance
                            .collection(user!)
                            .doc(snapshot.data!.docs[index].id)
                            .delete();
                        Map<String, dynamic> data = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        // print(data['time'].toDate());
                        // money += int.parse(data['amount']);
                        // print(expenseamt);
                        DateTime dateTime = data['time'].toDate();
                        String formatdate = dateTime.year.toString() +
                            '/' +
                            dateTime.day.toString() +
                            '/' +
                            dateTime.month.toString();
                        return myCard(
                          amount: data['amount'],
                          category: data['category'],
                          mode: data['mode'],
                          type: data['type'],
                          time: formatdate,
                          removeExpense: remove,
                        );
                      });
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20)),
//                           margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
//                           padding: const EdgeInsets.all(10.0),
//                           child: ListTile(
//                             tileColor: Colors.grey[300],
//                             trailing: IconButton(
//                               icon: Icon(Icons.highlight_remove),
//                               onPressed: () {
                                // FirebaseFirestore.instance
                                //     .collection(user!)
                                //     .doc(snapshot.data!.docs[index].id)
                                //     .delete();
//                               },
//                             ),
//                             title: Text(
//                               '${data["category"]}'.toUpperCase(),
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black),
//                             ),
//                             subtitle: Text(
//                               '$formatdate',
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   fontStyle: FontStyle.italic,
//                                   fontWeight: FontWeight.normal,
//                                   color: Colors.grey[600]),
//                             ),
//                           ),
//                         );

// Padding(
//           padding: EdgeInsets.all(30),
//           child: Column(
//             children: [
//               Container(
//                   decoration: BoxDecoration(border: Border.all()),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.all(5),
//                         height: 50,
//                         width: 100,
//                         decoration: BoxDecoration(border: Border.all()),
//                         child: Center(child: Text('Monthly expense')),
//                       ),
//                       Container(
//                         padding: EdgeInsets.all(5),
//                         height: 50,
//                         width: 100,
//                         decoration: BoxDecoration(border: Border.all()),
//                         child: Text('Monthly income'),
//                       )
//                     ],
//                   )),

// Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       height: 60,
//                       width: 100,
//                       padding: EdgeInsets.all(3),
//                       child: Center(
//                           child: Text(
//                         "Monthly Expense",
//                         textAlign: TextAlign.center,
//                       )),
//                       decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(20)),
//                     ),
//                     Container(
//                       height: 60,
//                       width: 100,
//                       padding: EdgeInsets.all(3),
//                       child: Center(
//                           child: Text(
//                         "Monthly Income",
//                         textAlign: TextAlign.center,
//                       )),
//                       decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(20)),
//                     ),
//                   ]),