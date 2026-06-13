import 'package:flutter/services.dart';

enum BiometricErrorCode {
  noBiometricHardware,
  notEnrolled,
  temporaryLockout,
  biometricLockout,
  userCanceled,
  systemCanceled,
  unknown,
}

class BiometricException implements Exception {
  final BiometricErrorCode code;
  final String message;
  final String userMessage;

  BiometricException({
    required this.code,
    required this.message,
    required this.userMessage,
  });

  factory BiometricException.fromPlatformException(PlatformException e) {
    switch (e.code) {
      case 'NotAvailable':
        return BiometricException(
          code: BiometricErrorCode.noBiometricHardware,
          message: e.message ?? '',
          userMessage: 'Perangkat tidak memiliki sensor biometrik.',
        );
      case 'NotEnrolled':
        return BiometricException(
          code: BiometricErrorCode.notEnrolled,
          message: e.message ?? '',
          userMessage:
              'Belum ada sidik jari tersimpan. Daftarkan di Pengaturan.',
        );
      case 'LockedOut':
        return BiometricException(
          code: BiometricErrorCode.temporaryLockout,
          message: e.message ?? '',
          userMessage:
              'Terkunci sementara karena terlalu banyak percobaan gagal.',
        );
      case 'PermanentlyLockedOut':
        return BiometricException(
          code: BiometricErrorCode.biometricLockout,
          message: e.message ?? '',
          userMessage: 'Terkunci permanen. Buka HP dengan PIN terlebih dahulu.',
        );
      default:
        return BiometricException(
          code: BiometricErrorCode.unknown,
          message: e.message ?? '',
          userMessage: 'Terjadi kesalahan sistem.',
        );
    }
  }

  bool get isRetryable =>
      code == BiometricErrorCode.userCanceled ||
      code == BiometricErrorCode.systemCanceled ||
      code == BiometricErrorCode.unknown;
  bool get requiresSettings => code == BiometricErrorCode.notEnrolled;
  bool get requiresFallback =>
      code == BiometricErrorCode.noBiometricHardware ||
      code == BiometricErrorCode.biometricLockout;
}
