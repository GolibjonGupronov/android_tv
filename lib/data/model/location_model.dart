class LocationModel {
  final double latitude;
  final double longitude;

  LocationModel(this.latitude, this.longitude);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      json['latitude'],
      json['longitude'],
    );
  }
}
