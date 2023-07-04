import 'dart:math';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:track_expenses/models/expenseModel.dart';
import 'package:intl/intl.dart';

Future<Uint8List> generateReport(
    PdfPageFormat pageFormat, List<ExpenseDatabase> dataExpense) async {
  dataExpense
      .sort((expense1, expense2) => expense2.time.compareTo(expense1.time));
  const tableHeaders = ['Date', 'Category', 'Mode', 'Amount'];
  print(dataExpense);

  var food = 0;
  var friend = 0;
  var travel = 0;
  var grocery = 0;
  var stationery = 0;
  var total = 0;
  for (int i = 0; i < dataExpense.length; i++) {
    if (dataExpense[i].category == "Food") {
      food += int.parse(dataExpense[i].amount);
    }
    if (dataExpense[i].category == "Friend") {
      friend += int.parse(dataExpense[i].amount);
    }
    if (dataExpense[i].category == "Travel") {
      travel += int.parse(dataExpense[i].amount);
    }
    if (dataExpense[i].category == "Grocery") {
      grocery += int.parse(dataExpense[i].amount);
    }
    if (dataExpense[i].category == "Stationery") {
      stationery += int.parse(dataExpense[i].amount);
    }
  }
  total = food + friend + stationery + travel + grocery;
  var PieExpense = [
    ["Food", food],
    ["Friend", friend],
    ["Travel", travel],
    ["Grocery", grocery],
    ["Stationery", stationery],
  ];

  const baseColor = PdfColors.cyan;

  // Create a PDF document.
  final document = pw.Document();

  final theme = pw.ThemeData.withFont(
    base: await PdfGoogleFonts.openSansRegular(),
    bold: await PdfGoogleFonts.openSansBold(),
  );

  // Data table
  final table = pw.TableHelper.fromTextArray(
    border: null,
    headers: tableHeaders,
    data: List<List<dynamic>>.generate(
      min(20, dataExpense.length),
      (index) => <String>[
        DateFormat.yMMMd().format(dataExpense[index].time).toString(),
        dataExpense[index].category,
        dataExpense[index].mode,
        dataExpense[index].amount,
      ],
    ),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontWeight: pw.FontWeight.bold,
    ),
    headerDecoration: const pw.BoxDecoration(
      color: baseColor,
    ),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: baseColor,
          width: .5,
        ),
      ),
    ),
    cellAlignment: pw.Alignment.centerRight,
    cellAlignments: {0: pw.Alignment.centerLeft},
  );

  // Second page with a pie chart
  document.addPage(
    pw.Page(
      pageFormat: pageFormat,
      theme: theme,
      build: (context) {
        const chartColors = [
          PdfColors.blue300,
          PdfColors.green300,
          PdfColors.amber300,
          PdfColors.pink300,
          PdfColors.cyan300,
          PdfColors.purple300,
          PdfColors.lime300,
        ];

        return pw.Column(
          children: [
            pw.Flexible(
              child: pw.Chart(
                title: pw.Text(
                  'Expense breakdown',
                  style: const pw.TextStyle(
                    color: baseColor,
                    fontSize: 20,
                  ),
                ),
                grid: pw.PieGrid(),
                datasets: List<pw.Dataset>.generate(PieExpense.length, (index) {
                  final data = PieExpense[index];
                  final color = chartColors[index % chartColors.length];
                  final value = data[1] as num;
                  final pct = (value / total * 100).round();
                  return pw.PieDataSet(
                    legend: '${data[0]}\n$pct%',
                    value: value,
                    color: color,
                    legendStyle: const pw.TextStyle(fontSize: 10),
                  );
                }),
              ),
            ),
            table,
          ],
        );
      },
    ),
  );

  return document.save();
}
