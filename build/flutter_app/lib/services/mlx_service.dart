import 'dart:async';
import 'package:flutter/foundation.dart';

/// Errors that can occur during MLX model operations
class MLXServiceError implements Exception {
  final String message;
  MLXServiceError(this.message);

  static MLXServiceError modelNotFound(String path) =>
      MLXServiceError('لم يتم العثور على النموذج في المسار: $path');

  static MLXServiceError modelLoadFailed(String error) =>
      MLXServiceError('فشل تحميل النموذج: $error');

  static MLXServiceError modelNotLoaded() =>
      MLXServiceError('النموذج غير محمّل. يرجى تحميل النموذج أولاً.');

  static MLXServiceError generationFailed(String error) =>
      MLXServiceError('فشل توليد الرد: $error');

  static MLXServiceError generationCancelled() =>
      MLXServiceError('تم إلغاء عملية التوليد.');

  @override
  String toString() => message;
}

/// Service for managing MLX model loading and inference
class MLXService extends ChangeNotifier {
  bool _isModelLoaded = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _modelPath;
  List<String> _tokenBuffer = [];

  bool get isModelLoaded => _isModelLoaded;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // MARK: - Model Loading

  Future<void> loadModel(String modelPath) async {
    _isLoading = true;
    _errorMessage = null;
    _isModelLoaded = false;
    notifyListeners();

    try {
      // Simulate async loading
      await Future.delayed(const Duration(milliseconds: 100));

      _modelPath = modelPath;
      _isModelLoaded = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = MLXServiceError.modelLoadFailed(e.toString()).message;
      _isModelLoaded = false;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void unloadModel() {
    _modelPath = null;
    _isModelLoaded = false;
    _errorMessage = null;
    _tokenBuffer.clear();
    notifyListeners();
  }

  // MARK: - Token Generation

  Stream<String> generate(String prompt) async* {
    if (!_isModelLoaded) {
      throw MLXServiceError.modelNotLoaded();
    }

    _tokenBuffer.clear();

    final simulatedTokens = _generateSimulatedResponse(prompt);

    for (final token in simulatedTokens) {
      await Future.delayed(const Duration(milliseconds: 20));
      _tokenBuffer.add(token);
      yield token;
    }
  }

  List<String> getGeneratedTokens() => List.from(_tokenBuffer);

  List<String> _generateSimulatedResponse(String prompt) {
    final lowercasedPrompt = prompt.toLowerCase();

    if (lowercasedPrompt.contains('رخصة') ||
        lowercasedPrompt.contains('القيادة') ||
        lowercasedPrompt.contains('اجدد') ||
        lowercasedPrompt.contains('license') ||
        lowercasedPrompt.contains('driving')) {
      return [
        'أهلاً! ',
        'يمكنك ',
        'تجديد ',
        'رخصة ',
        'القيادة ',
        'بسهولة ',
        'من ',
        'خلال ',
        'الضغط ',
        'على ',
        'الرابط ',
        'أدناه. ',
        'الرسوم ',
        'هي ',
        '٤٠ ',
        'ريال ',
        'فقط.',
      ];
    }

    if (lowercasedPrompt.contains('تنبيه') ||
        lowercasedPrompt.contains('إشعار')) {
      return [
        'مرحباً! ',
        'لاحظت ',
        'أن ',
        'رخصة ',
        'قيادتك ',
        'على ',
        'وشك ',
        'الانتهاء. ',
        'يمكنك ',
        'تجديدها ',
        'الآن ',
        'بسهولة. ',
        'اضغط ',
        'على ',
        'الرابط ',
        'أدناه ',
        'للمتابعة.',
      ];
    }

    if (lowercasedPrompt.contains('جواز') ||
        lowercasedPrompt.contains('السفر') ||
        lowercasedPrompt.contains('passport')) {
      return [
        'يمكنك ',
        'تجديد ',
        'جواز ',
        'السفر ',
        'من ',
        'خلال ',
        'الرابط ',
        'أدناه.',
      ];
    }

    if (lowercasedPrompt.contains('هوية') ||
        lowercasedPrompt.contains('الوطنية')) {
      return [
        'يمكنك ',
        'تجديد ',
        'الهوية ',
        'الوطنية ',
        'من ',
        'خلال ',
        'الرابط ',
        'أدناه.',
      ];
    }

    return [
      'مرحباً ',
      'بك ',
      'في ',
      'أبشر. ',
      'كيف ',
      'يمكنني ',
      'مساعدتك ',
      'اليوم؟ ',
      'يمكنني ',
      'مساعدتك ',
      'في ',
      'تجديد ',
      'رخصة ',
      'القيادة، ',
      'جواز ',
      'السفر، ',
      'أو ',
      'الهوية ',
      'الوطنية.',
    ];
  }
}
