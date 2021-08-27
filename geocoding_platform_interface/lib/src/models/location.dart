import 'package:meta/meta.dart';

/// Contains detailed location information.
@immutable
class Location {
  /// Constructs an instance with the given values for testing. [Location]
  /// instances constructed this way won't actually reflect any real information
  /// from the platform, just whatever was passed in at construction time.
  Location({
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });

  Location._({
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });

  /// The latitude associated with the placemark.
  final double latitude;

  /// The longitude associated with the placemark.
  final double longitude;

  /// The UTC timestamp the coordinates have been requested.
  DateTime? timestamp;

  @override
  bool operator ==(dynamic o) =>
      o is Location &&
      o.latitude == latitude &&
      o.longitude == longitude &&
      o.timestamp == timestamp;

  @override
  int get hashCode =>
      latitude.hashCode ^ longitude.hashCode ^ timestamp.hashCode;

  /// Converts a list of [Map] instances to a list of [Location] instances.
  static List<Location> fromMaps(dynamic message) {
    if (message == null) {
      throw ArgumentError('The parameter \'message\' should not be null.');
    }

    final List<Location> list = message.map<Location>(fromMap).toList();
    return list;
  }

  /// Converts the supplied [Map] to an instance of the [Location] class.
  static Location fromMap(dynamic message) {
    if (message == null) {
      throw ArgumentError('The parameter \'message\' should not be null.');
    }

    final Map<dynamic, dynamic> locationMap = message;
    final timestamp = (locationMap['timestamp']!=null)
      ? DateTime.fromMillisecondsSinceEpoch(
        locationMap['timestamp'].toInt(),
        isUtc: true)
      : null;

    if (locationMap['latitude'] == null || locationMap['longitude'] == null) {
      throw ArgumentError(
          'The parameters latitude and longitude should not be null.');
    }

    return Location._(
      latitude: locationMap['latitude'],
      longitude: locationMap['longitude'],
      timestamp: timestamp,
    );
  }

  /// Converts the [Location] instance into a [Map] instance that can be
  /// serialized to JSON.
  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp?.millisecondsSinceEpoch,
      };

  @override
  String toString() {
    return '''
      Latitude: $latitude,
      Longitude: $longitude,
      Timestamp: $timestamp''';
  }

   /// allows automatic deserialization with the json_serializable lib
  factory Location.fromJson(Map<String, dynamic> json) => fromMap(json);

  /// create a copy of the Location
  Location copy() {
    return Location(
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp
    );
  }

}
