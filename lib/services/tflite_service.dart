/// Service for loading and running TensorFlow Lite models

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';
import '../models/model_config.dart';

class TFLiteService {
  static final TFLiteService _instance = TFLiteService._internal();

  factory TFLiteService() {
    return _instance;
  }

  TFLiteService._internal();

  Interpreter? _acuteRiskInterpreter;
  Interpreter? _chronicRiskInterpreter;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  bool get isAcuteModelLoaded => _acuteRiskInterpreter != null;
  bool get isChronicModelLoaded => _chronicRiskInterpreter != null;

  /// Initialize TFLite service and load both models
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      await loadAcuteRiskModel();
      await loadChronicRiskModel();
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize TFLite service: $e');
    }
  }

  /// Load Acute Risk Model (Heart Disease)
  Future<void> loadAcuteRiskModel() async {
    try {
      final options = InterpreterOptions()..threads = 2;
      _acuteRiskInterpreter = await Interpreter.fromAsset(
        'assets/models/${AcuteRiskModelConfig.modelFileName}',
        options: options,
      );
      print('✓ Acute Risk Model loaded successfully');
    } catch (e) {
      throw Exception('Failed to load Acute Risk Model: $e');
    }
  }

  /// Load Chronic Risk Model (Cardiac Failure)
  Future<void> loadChronicRiskModel() async {
    try {
      final options = InterpreterOptions()..threads = 2;
      _chronicRiskInterpreter = await Interpreter.fromAsset(
        'assets/models/${ChronicRiskModelConfig.modelFileName}',
        options: options,
      );
      print('✓ Chronic Risk Model loaded successfully');
    } catch (e) {
      throw Exception('Failed to load Chronic Risk Model: $e');
    }
  }

  /// Run inference on Acute Risk Model
  /// Input: normalized features list [1, 11]
  /// Output: probabilities [1, 2] -> [prob_no_disease, prob_has_disease]
  List<List<double>> predictAcuteRisk(List<double> normalizedFeatures) {
    if (!isAcuteModelLoaded) {
      throw Exception('Acute Risk Model not loaded');
    }
    if (normalizedFeatures.length != AcuteRiskModelConfig.featureCount) {
      throw Exception(
          'Invalid feature count: ${normalizedFeatures.length}, expected ${AcuteRiskModelConfig.featureCount}');
    }

    // Create input tensor [1, 11]
    final input = [normalizedFeatures.toList()];

    // Create output tensor [1, 2]
    final output = <List<double>>[];
    output.add([0.0, 0.0]);

    try {
      _acuteRiskInterpreter!.run(input, output);
      return output;
    } catch (e) {
      throw Exception('Acute Risk Model inference failed: $e');
    }
  }

  /// Run inference on Chronic Risk Model
  /// Input: normalized features list [1, 11]
  /// Output: probabilities [1, 2] -> [prob_no_failure, prob_has_failure]
  List<List<double>> predictChronicRisk(List<double> normalizedFeatures) {
    if (!isChronicModelLoaded) {
      throw Exception('Chronic Risk Model not loaded');
    }
    if (normalizedFeatures.length != ChronicRiskModelConfig.featureCount) {
      throw Exception(
          'Invalid feature count: ${normalizedFeatures.length}, expected ${ChronicRiskModelConfig.featureCount}');
    }

    // Create input tensor [1, 11]
    final input = [normalizedFeatures.toList()];

    // Create output tensor [1, 2]
    final output = <List<double>>[];
    output.add([0.0, 0.0]);

    try {
      _chronicRiskInterpreter!.run(input, output);
      return output;
    } catch (e) {
      throw Exception('Chronic Risk Model inference failed: $e');
    }
  }

  /// Get model input and output shapes for debugging
  Map<String, dynamic> getAcuteModelShape() {
    if (!isAcuteModelLoaded) {
      return {};
    }
    return {
      'inputShape': _acuteRiskInterpreter!.getInputTensors().first.shape,
      'outputShape': _acuteRiskInterpreter!.getOutputTensors().first.shape,
    };
  }

  Map<String, dynamic> getChronicModelShape() {
    if (!isChronicModelLoaded) {
      return {};
    }
    return {
      'inputShape': _chronicRiskInterpreter!.getInputTensors().first.shape,
      'outputShape': _chronicRiskInterpreter!.getOutputTensors().first.shape,
    };
  }

  /// Dispose of interpreters
  void dispose() {
    _acuteRiskInterpreter?.close();
    _chronicRiskInterpreter?.close();
    _acuteRiskInterpreter = null;
    _chronicRiskInterpreter = null;
    _isInitialized = false;
    print('TFLite service disposed');
  }
}

