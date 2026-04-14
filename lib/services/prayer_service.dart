import 'dart:ui' as ui;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:location/location.dart';

class PrayerService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> getPrayerTimes() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return null;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return null;
    }

    _locationData = await location.getLocation();

    try {
      final response = await _dio.get(
        'https://api.aladhan.com/v1/timings',
        queryParameters: {
          'latitude': _locationData.latitude,
          'longitude': _locationData.longitude,
          'method': 5, // Egyptian General Authority of Survey
        },
      );
      if (response.statusCode == 200) {
        return response.data['data']['timings'];
      }
    } catch (e) {
      print("Error fetching prayer times: $e");
    }
    return null;
  }
}
