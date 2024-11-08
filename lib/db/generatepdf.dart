import 'package:listasqflite/model/item.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class GeneratePrinting {
  Future<void> printingPdf(List<Item> items) async {
    final pdf = pw.Document();

    // Exemplo de imagem de rede
    //final netImage = await networkImage('https://www.nfet.net/nfet.jpg');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                width: 100,
                height: 300,
                //child: pw.Image(netImage, fit: pw.BoxFit.cover),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Lista de Compras',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('nome: ${item.nome}'),
                      pw.Text('Quantidade: ${item.quantidade}'),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
