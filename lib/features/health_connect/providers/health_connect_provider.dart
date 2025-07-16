import 'package:flutter/material.dart';
import '../services/health_connect_service.dart';
import '../../../models/heal_connect_model.dart';

class HealthConnectProvider extends ChangeNotifier {
  final HealthConnectService _service = HealthConnectService();
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Stream<HealConnectData?> getHealConnectData() {
    return _service.getHealConnectData();
  }

  Future<bool> requestPermissions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.requestPermissions();
      return result;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getTodayHealthData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _service.getTodayHealthData();
      return result;
    } catch (e) {
      _error = e.toString();
      return {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> connectDevice(String deviceId, String deviceName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.connectDevice(deviceId, deviceName);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> disconnectDevice(String deviceId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.disconnectDevice(deviceId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
