import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:ui' as ui;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class OCRService {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> recognizeText(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    return text;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
