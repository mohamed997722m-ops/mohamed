import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class OCRService {
  TextRecognizer? _textRecognizer;

  OCRService() {
    if (!kIsWeb) {
      _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    }
  }

  Future<String> recognizeText(String imagePath) async {
    if (kIsWeb) {
      return "ميزة التعرف على النصوص غير مدعومة حالياً على الويب";
    }
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText = await _textRecognizer!.processImage(inputImage);

    String text = recognizedText.text;
    return text;
  }

  void dispose() {
    _textRecognizer?.close();
  }
}
