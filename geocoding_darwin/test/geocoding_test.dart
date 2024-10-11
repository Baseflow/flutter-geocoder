import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding_darwin/geocoding_darwin.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';

final mockLocation = Location(
  latitude: 52.2165157,
  longitude: 6.9437819,
  timestamp: DateTime.fromMillisecondsSinceEpoch(0).toUtc(),
);

const mockPlacemark = Placemark(
    administrativeArea: 'Overijssel',
    country: 'Netherlands',
    isoCountryCode: 'NL',
    locality: 'Enschede',
    name: 'Gronausestraat',
    postalCode: '',
    street: 'Gronausestraat 710',
    subAdministrativeArea: 'Enschede',
    subLocality: 'Enschmarke',
    subThoroughfare: '',
    thoroughfare: 'Gronausestraat');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter.baseflow.com/geocoding');
  late List<MethodCall> log;

  setUp(() {
    log = <MethodCall>[];
    _ambiguate(TestDefaultBinaryMessengerBinding.instance)!
        .defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);

      return null;
    });
  });

  test('registers instance', () {
    GeocodingDarwin.registerWith();
    expect(GeocodingPlatform.instance, isA<GeocodingDarwin>());
  });

  group('GeocodingAndroid', () {
    test('locationFromAddress', () async {
      _ambiguate(TestDefaultBinaryMessengerBinding.instance)!
          .defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return Future<List<Map<dynamic, dynamic>>>.value([
          mockLocation.toJson(),
        ]);
      });

      final geocoding = GeocodingDarwin();
      final locations = await (geocoding.locationFromAddress(''));

      expect(
        log,
        <Matcher>[
          isMethodCall('locationFromAddress', arguments: <String, String>{
            'address': '',
          })
        ],
      );

      expect(locations.single, mockLocation);
    });

    test('placemarkFromCoordinates', () async {
      _ambiguate(TestDefaultBinaryMessengerBinding.instance)!
          .defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return Future<List<Map<dynamic, dynamic>>>.value([
          mockPlacemark.toJson(),
        ]);
      });

      final geocoding = GeocodingDarwin();
      final locations = await (geocoding.placemarkFromCoordinates(0, 0));

      expect(
        log,
        <Matcher>[
          isMethodCall('placemarkFromCoordinates', arguments: <String, Object?>{
            'latitude': 0.0,
            'longitude': 0.0,
          })
        ],
      );

      expect(locations.single, mockPlacemark);
    });
  });
}

/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.
T? _ambiguate<T>(T? value) => value;
