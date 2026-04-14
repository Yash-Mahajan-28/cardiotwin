import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class CardioModelService {
  static const String _acuteModelPath =
      'assets/models/best_acute_risk_model.tflite';
  static const String _chronicModelPath =
      'assets/models/best_chronic_risk_model.tflite';

  Interpreter? _acuteInterpreter;
  Interpreter? _chronicInterpreter;
  bool _isLoading = false;

  bool get isLoaded => _acuteInterpreter != null && _chronicInterpreter != null;

  Future<void> loadModels() async {
    if (isLoaded) {
      debugPrint('[CardioModelService] Models already loaded.');
      return;
    }

    if (_isLoading) {
      return;
    }

    _isLoading = true;
    try {
      final InterpreterOptions options = InterpreterOptions()..threads = 2;

      _acuteInterpreter = await Interpreter.fromAsset(
        _acuteModelPath,
        options: options,
      );
      _chronicInterpreter = await Interpreter.fromAsset(
        _chronicModelPath,
        options: options,
      );

      debugPrint('[CardioModelService] Loaded acute model: $_acuteModelPath');
      debugPrint('[CardioModelService] Loaded chronic model: $_chronicModelPath');
      _logTensorInfo();
    } catch (e, st) {
      developer.log(
        'Failed to load TFLite models',
        name: 'CardioModelService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Map<String, double> predictRisk({
    required List<double> acuteFeatures,
    required List<double> chronicFeatures,
  }) {
    _ensureLoaded();

    try {
      final Float32List acuteInput = _prepareInput(acuteFeatures);
      final Float32List chronicInput = _prepareInput(chronicFeatures);

      debugPrint('[CardioModelService] Acute input: ${acuteInput.toList()}');
      debugPrint('[CardioModelService] Chronic input: ${chronicInput.toList()}');

      final double acuteRisk = _runSinglePrediction(
        interpreter: _acuteInterpreter!,
        input: acuteInput,
        modelLabel: 'acute',
      );
      final double chronicRisk = _runSinglePrediction(
        interpreter: _chronicInterpreter!,
        input: chronicInput,
        modelLabel: 'chronic',
      );

      final Map<String, double> output = {
        'acute_risk': acuteRisk,
        'chronic_risk': chronicRisk,
      };

      debugPrint('[CardioModelService] Prediction output: $output');
      return output;
    } catch (e, st) {
      developer.log(
        'Inference failed',
        name: 'CardioModelService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  void dispose() {
    _acuteInterpreter?.close();
    _chronicInterpreter?.close();
    _acuteInterpreter = null;
    _chronicInterpreter = null;
    debugPrint('[CardioModelService] Interpreters disposed.');
  }

  Float32List _prepareInput(List<double> features) {
    if (features.isEmpty) {
      throw ArgumentError('Feature list cannot be empty.');
    }

    final List<double> normalized = _normalizeInput(features);
    return Float32List.fromList(normalized);
  }

  List<double> _normalizeInput(List<double> values) {
    return values.map((double value) {
      final double safeValue = value.isFinite ? value : 0.0;
      final double scaled = safeValue / 100.0;
      if (scaled.isNaN || scaled.isInfinite) {
        return 0.0;
      }
      return scaled.clamp(0.0, 1.0).toDouble();
    }).toList(growable: false);
  }

  double _runSinglePrediction({
    required Interpreter interpreter,
    required Float32List input,
    required String modelLabel,
  }) {
    final List<int> inputShape = interpreter.getInputTensor(0).shape;
    final List<int> outputShape = interpreter.getOutputTensor(0).shape;

    if (inputShape.isEmpty) {
      throw StateError('[$modelLabel] Unexpected empty input tensor shape.');
    }

    final int expectedFeatureCount = inputShape.length == 1
        ? inputShape[0]
        : inputShape.sublist(1).fold<int>(1, (int acc, int value) => acc * value);

    if (expectedFeatureCount != input.length) {
      throw ArgumentError(
        '[$modelLabel] Expected $expectedFeatureCount features, got ${input.length}.',
      );
    }

    final Object inputBuffer = inputShape.length == 1 ? input : [input];
    final Object outputBuffer = _createOutputBuffer(outputShape);

    interpreter.run(inputBuffer, outputBuffer);

    final double score = _extractScalarOutput(outputBuffer);
    debugPrint('[CardioModelService] $modelLabel output: $score');
    return score;
  }

  Object _createOutputBuffer(List<int> outputShape) {
    if (outputShape.isEmpty) {
      return List<double>.filled(1, 0.0);
    }

    if (outputShape.length == 1) {
      return List<double>.filled(outputShape[0], 0.0);
    }

    final int rows = outputShape.first;
    final int columns = outputShape.sublist(1).fold<int>(1, (int acc, int value) => acc * value);
    return List.generate(
      rows,
      (_) => List<double>.filled(columns, 0.0),
      growable: false,
    );
  }

  double _extractScalarOutput(Object outputBuffer) {
    if (outputBuffer is List<double>) {
      return _sanitizeScore(outputBuffer.first);
    }

    if (outputBuffer is List &&
        outputBuffer.isNotEmpty &&
        outputBuffer.first is List) {
      final dynamic firstRow = outputBuffer.first;
      if (firstRow is List && firstRow.isNotEmpty) {
        return _sanitizeScore(firstRow.first as double);
      }
    }

    throw StateError('Unsupported model output format: ${outputBuffer.runtimeType}');
  }

  double _sanitizeScore(double value) {
    if (value.isNaN || value.isInfinite) {
      return 0.0;
    }
    return value;
  }

  void _ensureLoaded() {
    if (!isLoaded) {
      throw StateError('Models not loaded. Call loadModels() before predictRisk().');
    }
  }

  void _logTensorInfo() {
    final List<int>? acuteIn = _acuteInterpreter?.getInputTensor(0).shape;
    final List<int>? acuteOut = _acuteInterpreter?.getOutputTensor(0).shape;
    final List<int>? chronicIn = _chronicInterpreter?.getInputTensor(0).shape;
    final List<int>? chronicOut = _chronicInterpreter?.getOutputTensor(0).shape;

    debugPrint('[CardioModelService] Acute input shape: $acuteIn');
    debugPrint('[CardioModelService] Acute output shape: $acuteOut');
    debugPrint('[CardioModelService] Chronic input shape: $chronicIn');
    debugPrint('[CardioModelService] Chronic output shape: $chronicOut');
  }
}
