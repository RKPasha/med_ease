import 'dart:io';
import 'package:med_ease/api/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfParagraphApi {
  static Future<File> generate(String clinic, String docname, String patentname,
      String date, String time, String description) async {
    final pdf = Document();
    pdf.addPage(
      MultiPage(
        build: (context) => <Widget>[
          buildCustomHeader(),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Paragraph(
            text:
                "This Report is developed by certified doctor. Do follow the instructions prescribed blow.",
            style: TextStyle(font: Font.times(), fontSize: 16),
          ),
          buildCustomHeadline(clinic),
          //buildLink(),
          ...buildBulletPoints(patentname, date, time, docname),
          Header(
            child: Text('Patient Report',
                style: const TextStyle(
                  fontSize: 18,
                )),
          ),
          Paragraph(text: description, style: const TextStyle(fontSize: 16)),
          // Paragraph(text: LoremText().paragraph(60)),
          // Paragraph(text: LoremText().paragraph(60)),
          // Paragraph(text: LoremText().paragraph(60)),
          // Paragraph(text: LoremText().paragraph(60)),
        ],
        footer: (context) {
          const text =
              'Contact us on: dukocommunity@gmail.com | © All rights Reserved';

          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 1 * PdfPageFormat.cm),
            child: Text(
              text,
              style: const TextStyle(color: PdfColors.black),
            ),
          );
        },
      ),
    );
    return PdfApi.saveDocument(name: 'Report.pdf', pdf: pdf);
  }

  static Widget buildCustomHeader() => Container(
        padding: const EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: PdfColors.blue)),
        ),
        child: Row(
          children: [
            SizedBox(width: 0.5 * PdfPageFormat.cm),
            Text(
              "MedEase Reports",
              style: const TextStyle(
                fontSize: 30,
                color: PdfColors.blue,
              ),
            ),
          ],
        ),
      );

  static Widget buildCustomHeadline(String clinic) => Header(
        child: Text(
          clinic,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: PdfColors.white,
          ),
        ),
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: PdfColors.red),
      );

  // static Widget buildLink() => UrlLink(
  //       destination: 'https://flutter.dev',
  //       child: Text(
  //         'Go to flutter.dev',
  //         style: TextStyle(
  //           decoration: TextDecoration.underline,
  //           color: PdfColors.blue,
  //         ),
  //       ),
  //     );

  static List<Widget> buildBulletPoints(
          String patientname, String date, String time, String docname) =>
      [
        Bullet(
            text: 'Patient Name : $patientname',
            style: const TextStyle(fontSize: 18)),
        Bullet(
            text: 'Doctor Name  : $docname',
            style: const TextStyle(fontSize: 17)),
        Bullet(
            text: 'Date Created : $date', style: const TextStyle(fontSize: 17)),
        Bullet(
            text: 'Time Created : $time', style: const TextStyle(fontSize: 17)),
      ];
}
