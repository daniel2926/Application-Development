import 'package:nominatim_geocoding/nominatim_geocoding.dart';

Future<String> getAddress(double latitude, double longitude) async {
  await NominatimGeocoding.init();

  Geocoding result = await NominatimGeocoding.to.reverseGeoCoding(
    Coordinate(latitude: latitude, longitude: longitude),
  );

  final address = result.address;
  final formattedAddress = [
    address.road, // Road/Street
    address.city, // City
    address.country, // City
  ].join(', ');

  return formattedAddress.isNotEmpty ? formattedAddress : 'Address not found';
}