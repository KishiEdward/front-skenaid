import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'biometric_exception.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    final bool canCheck = await _auth.canCheckBiometrics;
    final bool isSupported = await _auth.isDeviceSupported();
    return canCheck && isSupported;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  Future<bool> authenticate({
    String reason = 'Verifikasi untuk membuka Skena.id',
  }) async {
    final bool available = await isBiometricAvailable();
    if (!available) {
      throw BiometricException(
        code: BiometricErrorCode.noBiometricHardware,
        message: 'No hardware',
        userMessage: 'Perangkat tidak mendukung biometrik',
      );
    }

    final List<BiometricType> types = await getAvailableBiometrics();
    if (types.isEmpty) {
      throw BiometricException(
        code: BiometricErrorCode.notEnrolled,
        message: 'Not enrolled',
        userMessage: 'Belum ada sidik jari terdaftar di HP ini',
      );
    }

    try {
      final bool result = await _auth.authenticate(
        localizedReason: reason,
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Keamanan Skena.id',
            cancelButton: 'Batal',
          ),
        ],
        biometricOnly: false,
        sensitiveTransaction: true,
        persistAcrossBackgrounding: true,
      );

      if (!result) {
        throw BiometricException(
          code: BiometricErrorCode.userCanceled,
          message: 'User canceled',
          userMessage: 'Autentikasi dibatalkan',
        );
      }

      return true;
    } on PlatformException catch (e) {
      throw BiometricException.fromPlatformException(e);
    }
  }
}
