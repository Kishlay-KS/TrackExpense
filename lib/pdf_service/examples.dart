import 'dart:async';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:track_expenses/models/expenseModel.dart';

import 'examples/report.dart';

const examples = <Example>[
  Example('REPORT', 'report.dart', generateReport, true),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, List<ExpenseDatabase> data);

class Example {
  const Example(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}
