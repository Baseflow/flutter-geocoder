import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';

const MethodChannel _channel = MethodChannel('flutter.baseflow.com/geocoding');

/// An implementation of [GeocodingPlatform] for iOS.
class GeocodingDarwin extends GeocodingPlatform {
  /// Registers this class as the default instance of [GeocodingPlatform].
  static void registerWith() {
    GeocodingPlatform.instance = GeocodingDarwin();
  }

  String? _localeIdentifier;

  @override
  Future<void> setLocaleIdentifier(
    String localeIdentifier,
  ) async {
    _localeIdentifier = localeIdentifier;
  }

  @override
  Future<List<Location>> locationFromAddress(String address) async {
    final parameters = <String, String>{
      'address': address,
    };

    if (_localeIdentifier != null) {
      parameters['localeIdentifier'] = _localeIdentifier!;
    }
    try {
      final placemarks = await _channel.invokeMethod(
        'locationFromAddress',
        parameters,
      );

      return Location.fromMaps(placemarks);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
      rethrow;
    }
  }

  @override
  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    final parameters = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };

    if (_localeIdentifier != null) {
      parameters['localeIdentifier'] = _localeIdentifier!;
    }

    final placemarks =
        await _channel.invokeMethod('placemarkFromCoordinates', parameters);
    return Placemark.fromMaps(placemarks);
  }

  @override
  Future<bool> isPresent() => Future<bool>.value(true);

  void _handlePlatformException(PlatformException platformException) {
    switch (platformException.code) {
      case 'NOT_FOUND':
        throw const NoResultFoundException();
    }
  }
}
