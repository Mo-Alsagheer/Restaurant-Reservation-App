import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import '../domain/models/location.dart';

class LocationService {
  /// Check and request location permissions
  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'Location services are disabled. Please enable location services in your device settings.',
      );
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permissions are denied. Please grant permission to access your location.',
        );
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. Please enable them in app settings.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Please enable them in app settings and try again.',
      );
    }

    return true;
  }

  /// Get current GPS coordinates
  Future<Position> getCurrentPosition() async {
    await checkAndRequestPermission();

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  /// Get current location with address
  Future<Location> getCurrentLocation() async {
    final position = await getCurrentPosition();

    // Get address from coordinates
    final placemarks = await geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String address = 'Unknown address';
    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      address = _formatAddress(placemark);
    }

    return Location(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
    );
  }

  /// Get coordinates from an address string
  Future<Location> getLocationFromAddress(String address) async {
    try {
      final locations = await geocoding.locationFromAddress(address);

      if (locations.isEmpty) {
        throw Exception('Address not found');
      }

      final location = locations.first;

      return Location(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address,
      );
    } catch (e) {
      throw Exception('Failed to get location from address: $e');
    }
  }

  /// Get address from coordinates
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return 'Unknown address';
      }

      return _formatAddress(placemarks.first);
    } catch (e) {
      return 'Unknown address';
    }
  }

  /// Format placemark into readable address
  String _formatAddress(geocoding.Placemark placemark) {
    final parts = <String>[];

    if (placemark.street != null && placemark.street!.isNotEmpty) {
      parts.add(placemark.street!);
    }

    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      parts.add(placemark.subLocality!);
    }

    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    }

    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      parts.add(placemark.administrativeArea!);
    }

    if (placemark.country != null && placemark.country!.isNotEmpty) {
      parts.add(placemark.country!);
    }

    return parts.isEmpty ? 'Unknown address' : parts.join(', ');
  }

  /// Calculate distance between two points in meters
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Calculate distance between two locations in meters
  double calculateDistanceBetweenLocations(Location start, Location end) {
    return calculateDistance(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }
}
