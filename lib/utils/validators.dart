// utils/validators.dart
import 'helpers.dart';  // Add this import

class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email adresi gerekli';
    }
    if (!Helpers.isValidEmail(value)) {
      return 'Geçerli bir email adresi girin';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gerekli';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalı';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'İsim gerekli';
    }
    if (value.length < 2) {
      return 'İsim en az 2 karakter olmalı';
    }
    return null;
  }

  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName gerekli';
    }
    return null;
  }
}