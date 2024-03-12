import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:technischer_dienst/shared/domain/report_category.dart';
import '../features/reports/domain/report.dart';

class PdfHelper {
  static const approvedStyle = pw.TextStyle(
    color: PdfColors.green500,
  );
  static const disapprovedStyle = pw.TextStyle(
    color: PdfColors.red500,
  );

  static const categoryTitleStyle = pw.TextStyle(fontSize: 20);
  static final tableHeaderTextStyle = pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold );

  static Future<File> createPdfFromReport(Report report) async {
    final pdf = pw.Document();
    final List<ReportCategory> categories = report.categories;

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Column(children: [
            _createHeader(report.reportName, report.ofTemplate.split(".")[0],
                report.from.toString(), report.inspector),
           pw.SizedBox(height: 10),
            for (ReportCategory c in categories) ...{
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(c.categoryName, style: categoryTitleStyle),
                    pw.SizedBox(height: 5),
                    pw.Table(border: pw.TableBorder.all(), children: [
                      pw.TableRow(

                          children: [pw.Text("Name", style: tableHeaderTextStyle), pw.Text("Status", style: tableHeaderTextStyle)]),
                      for (CategoryItem item in c.items) ...{
                        pw.TableRow(children: [
                          pw.Text(item.itemName),
                          if(item.isChecked == null)
                            pw.Text("nicht OK", style: disapprovedStyle)
                          else if (item.isChecked!)
                            pw.Text("OK", style: approvedStyle)
                          else if (!item.isChecked!)
                              pw.Text("-")
                        ]),
                      }
                    ]),
                    pw.SizedBox(height: 15),
                  ]),
            },
          ]));
        }));

    return await _savePdf(pdf, "test.pdf");
  }

  static pw.Widget _createHeader(
      String name, String templateName, String date, String inspector) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
      pw.Column(children: [
        pw.Table(
          children: [
            pw.TableRow(
              children: [pw.Text("Bericht: "), pw.Text(name)],
            ),
            pw.TableRow(
              children: [pw.Text("Vorlage: "), pw.Text(templateName)],
            ),
            pw.TableRow(
              children: [pw.Text("Prüfer: "), pw.Text(inspector)],
            ),
          ],
        )
      ]),
      pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
        pw.Table(children: [
          pw.TableRow(children: [pw.Text("Datum: "), pw.Text(date.split(" ")[0])]),
        ])
      ]),
    ]);
  }

  static Future<File> _savePdf(pw.Document pdf, String pdfName) async {
    final path = await getTemporaryDirectory();

    final file = File("${path.path}/$pdfName");
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
