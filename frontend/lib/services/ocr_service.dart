import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class OCRService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  Future<String> extractText(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  Future<String?> scanBarcode(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final barcodes = await _barcodeScanner.processImage(inputImage);
    if (barcodes.isEmpty) return null;
    return barcodes.first.displayValue;
  }

  Future<Map<String, dynamic>> scanReceipt(String imagePath) async {
    final text = await extractText(imagePath);
    final lines = text.split('\n');
    final items = <String>[];
    double total = 0;

    for (final line in lines) {
      final words = line.split(' ');
      for (final word in words) {
        final price = double.tryParse(word.replaceAll(RegExp(r'[^0-9.]'), ''));
        if (price != null && price > 0) {
          total += price;
          items.add(line.trim());
          break;
        }
      }
    }

    return {
      'fullText': text,
      'items': items,
      'total': total,
      'lines': lines,
    };
  }

  void dispose() {
    _textRecognizer.close();
    _barcodeScanner.close();
  }
}
