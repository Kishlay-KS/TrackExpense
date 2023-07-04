import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:flutter/material.dart';
import 'package:track_expenses/main.dart';
import 'package:track_expenses/models/expenseModel.dart';
import 'package:track_expenses/pdf_service/app.dart';

class PieChart extends StatefulWidget {
  const PieChart({super.key});

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  // late List<GDPdata> _chartData;
  late TooltipBehavior _tooltip;
  late TooltipBehavior _tool;
  late TooltipBehavior _toolday;
  String? user = FirebaseAuth.instance.currentUser!.email;
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    // print("init called");
    // TODO: implement initState
    // expenseData = await getExpenseData();
    // _chartData = getchartdata();
    _toolday = TooltipBehavior(enable: true);
    _tooltip = TooltipBehavior(enable: true);
    _tool = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final datalist = ModalRoute.of(context)!.settings.arguments as Map;
    // final List<chartData> chartdata = [
    //   chartData(Day: 'Mon', amount: 100),
    //   chartData(Day: 'Tue', amount: 200),
    //   chartData(Day: 'Wed', amount: 300),
    //   chartData(Day: 'Thu', amount: 400),
    //   chartData(Day: 'Fri', amount: 500),
    //   chartData(Day: 'Sat', amount: 600),
    //   chartData(Day: 'Sun', amount: 700)
    // ];
    final expense = getExpenseData(datalist["data"], "Category");
    final modedata = getExpenseData(datalist["data"], "Mode");
    final daydata = getExpenseData(datalist["data"], "day");
    // print(datalist["data"].runtimeType);
    // print(datalist);
    // print(_chartData);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Material(
          color: Colors.amber[400],
          child: InkWell(
            onTap: () async {
              final List<ExpenseDatabase> datalist = [];
              await db.collection(user!).get().then(
                (querySnapshot) {
                  print("Successfully completed");
                  for (var docSnapshot in querySnapshot.docs) {
                    var data = ExpenseDatabase.fromJson(docSnapshot.data());
                    print(int.parse(data.amount).runtimeType);
                    setState(() {
                      datalist.add(data);
                    });
                  }
                  print(datalist);
                },
                onError: (e) => print("Error completing: $e"),
              );
              Navigator.pushNamed(context, '/pdfScreen',
                  arguments: {'data': datalist});
            },
            child: const SizedBox(
              height: kToolbarHeight,
              width: double.infinity,
              child: Center(
                child: Text(
                  'Generate Summary PDF',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: Icon(
              Icons.logout,
              color: Colors.black,
              size: 30,
            ),
            backgroundColor: Colors.amber[400]),
        backgroundColor: Colors.black,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.grey,
            title: Center(
              child: Container(
                  // margin: EdgeInsets.only(right: 50),
                  child: Text(
                'Expense Summary',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
            )),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              SfCircularChart(
                backgroundColor: Colors.white,
                tooltipBehavior: _tool,
                title: ChartTitle(
                    text: 'Category Wise Expense Summary',
                    textStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
                series: <CircularSeries>[
                  PieSeries<Piedata, String>(
                    enableTooltip: true,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    dataSource: expense,
                    xValueMapper: (Piedata data, _) => data.category,
                    yValueMapper: (Piedata data, _) => data.amount,
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              SfCircularChart(
                backgroundColor: Colors.white,
                tooltipBehavior: _tooltip,
                title: ChartTitle(
                    text: 'Mode Wise Expense Summary',
                    textStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
                series: <CircularSeries>[
                  PieSeries<Piedata, String>(
                    enableTooltip: true,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    dataSource: modedata,
                    xValueMapper: (Piedata data, _) => data.category,
                    yValueMapper: (Piedata data, _) => data.amount,
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              SfCartesianChart(
                backgroundColor: Colors.white,
                tooltipBehavior: _toolday,
                legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
                title: ChartTitle(
                    text: 'Weekday Wise Expense Summary',
                    textStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                primaryXAxis: CategoryAxis(),
                series: [
                  StackedColumnSeries<Piedata, String>(
                      dataSource: daydata,
                      xValueMapper: (Piedata ch, _) => ch.category,
                      yValueMapper: (Piedata ch, _) => ch.amount)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// List<GDPdata> getchartdata() {
//   final List<GDPdata> data = [
//     GDPdata(continent: 'Oceania', value: 1600),
//     GDPdata(continent: 'Africa', value: 2490),
//     GDPdata(continent: 'S America', value: 2900),
//     GDPdata(continent: 'N America', value: 29200),
//     GDPdata(continent: 'Asia', value: 34200),
//   ];
//   return data;
// }

// class GDPdata {
//   GDPdata({required this.continent, required this.value});
//   String continent;
//   int value;
// }

List<Piedata> getExpenseData(List<ExpenseDatabase> data, String x) {
  Piedata footcat = Piedata(category: 'Food', amount: 0);
  Piedata friendcat = Piedata(category: 'Friend', amount: 0);
  Piedata travelcat = Piedata(category: 'Travel', amount: 0);
  Piedata stacat = Piedata(category: 'Stationery', amount: 0);
  Piedata grocat = Piedata(category: 'Grocery', amount: 0);

  Piedata cash = Piedata(category: 'Cash', amount: 0);
  Piedata upi = Piedata(category: 'UPI', amount: 0);
  Piedata other = Piedata(category: 'Other', amount: 0);

  Piedata mon = Piedata(category: "Mon", amount: 0);
  Piedata tue = Piedata(category: "Tue", amount: 0);
  Piedata wed = Piedata(category: "Wed", amount: 0);
  Piedata thu = Piedata(category: "Thu", amount: 0);
  Piedata fri = Piedata(category: "Fri", amount: 0);
  Piedata sat = Piedata(category: "Sat", amount: 0);
  Piedata sun = Piedata(category: "Sun", amount: 0);

  List<Piedata> ans = [];
  List<Piedata> modeans = [];
  List<Piedata> dayans = [];
  print(data.length);
  for (var i in data) {
    // print(i.runtimeType);
    DateTime timestamp = i.time;
    String day = timestamp.weekday.toString();
    print(day);
    if (i.category == 'Food') footcat.amount += int.parse(i.amount);
    if (i.category == 'Travel') travelcat.amount += int.parse(i.amount);
    if (i.category == 'Stationery') stacat.amount += int.parse(i.amount);
    if (i.category == 'Friend') friendcat.amount += int.parse(i.amount);
    if (i.category == 'Grocery') grocat.amount += int.parse(i.amount);

    if (i.mode == 'Cash') cash.amount += int.parse(i.amount);
    if (i.mode == 'UPI') upi.amount += int.parse(i.amount);
    if (i.mode == 'Other') other.amount += int.parse(i.amount);

    if (day == "1") mon.amount += int.parse(i.amount);
    if (day == "2") tue.amount += int.parse(i.amount);
    if (day == "3") wed.amount += int.parse(i.amount);
    if (day == "4") thu.amount += int.parse(i.amount);
    if (day == "5") fri.amount += int.parse(i.amount);
    if (day == "6") sat.amount += int.parse(i.amount);
    if (day == "7") sun.amount += int.parse(i.amount);
  }
  // print("XxxXxx");
  // print(DateTime.now().weekday);
  // print(ans.runtimeType);
  ans.add(footcat);
  ans.add(travelcat);
  ans.add(friendcat);
  ans.add(stacat);
  ans.add(grocat);

  modeans.add(cash);
  modeans.add(upi);
  modeans.add(other);

  dayans.add(mon);
  dayans.add(tue);
  dayans.add(wed);
  dayans.add(thu);
  dayans.add(fri);
  dayans.add(sat);
  dayans.add(sun);
  // print("xxxxxxxxxx");
  // print(footcat.amount);
  // print("xxxxxxxxxx");
  if (x == "Category") {
    return ans;
  } else if (x == "Mode") {
    return modeans;
  } else {
    return dayans;
  }
}

class Piedata {
  String category;
  int amount;

  Piedata({required this.category, required this.amount});
}

class chartData {
  String Day;
  int amount;

  chartData({required this.Day, required this.amount});
}
