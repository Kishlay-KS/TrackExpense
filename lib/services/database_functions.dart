import 'package:cloud_firestore/cloud_firestore.dart';

class dbms_services {
  //creating an instance
  CollectionReference UserExpense =
      FirebaseFirestore.instance.collection('User-expense');
  Future addUserExpense() async {
    return UserExpense.add(
            {'name': 'Kishlay', 'amount': '25', 'time': DateTime.now()})
        .then((value) => print('user added'))
        .catchError((onError) => print('failed due to $onError'));
  }
}
