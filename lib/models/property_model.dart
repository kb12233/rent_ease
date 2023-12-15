// property_model.dart


class PropertyModel {
  final dynamic propertyID;
  final String propertyOwner;
  final String propertyName;
  final String description;
  final String locationAddress;
  final dynamic rentPrice;
  final String? tenant; // Added tenant field
  final List<String> photoURLs;
  final int minStay;

  PropertyModel({
    required this.propertyID,
    required this.propertyOwner,
    required this.propertyName,
    required this.description,
    required this.locationAddress,
    required this.rentPrice,
    required this.tenant,
    required this.photoURLs,
    required this.minStay,
  });
}
