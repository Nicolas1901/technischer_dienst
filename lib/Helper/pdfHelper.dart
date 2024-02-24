import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:technischer_dienst/Models/ReportCategory.dart';
import '../Models/report.dart';

class PdfHelper {
  static void createPdfFromReport(Report report) {
    final pdf = pw.Document();
    const approvedStyle = pw.TextStyle(
      color: PdfColors.green500,
    );
    const disapprovedStyle = pw.TextStyle(
      color: PdfColors.red500,
    );

    final pw.TableRow header =
        pw.TableRow(children: [pw.Text("Name"), pw.Text("Status")]);
    pw.Text approved = pw.Text("OK", style: approvedStyle);
    pw.Text disapproved = pw.Text("nicht OK", style: disapprovedStyle);

    final List<ReportCategory> categories = report.categories;

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Column(children: [
            for (ReportCategory c in categories) ...{
              pw.Column(children: [
                pw.Text(c.categoryName),
                pw.Table(border: pw.TableBorder.all(), children: [
                  pw.TableRow(children: [pw.Text("Name"), pw.Text("Status")]),
                  for (CategoryItem item in c.items) ...{
                    pw.TableRow(children: [
                      pw.Text(item.itemName),
                      if (item.isChecked)
                        pw.Text("OK", style: approvedStyle)
                      else if (!item.isChecked)
                        pw.Text("nicht OK", style: disapprovedStyle),
                    ]),
                  }
                ]),
              ]),
            },
          ]));
        }));

    _savePdf(pdf, "test.pdf");
  }

  static Future<void> _savePdf(pw.Document pdf, String pdfName) async {
    final path = await getTemporaryDirectory();

    final file = File("${path.path}/$pdfName");
    await file.writeAsBytes(await pdf.save());
  }
}
