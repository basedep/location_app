class CustomUser {
  final String? id;
  final String name;
  final double latitude;
  final double longitude;

  CustomUser({required this.latitude, required this.longitude, required this.id, required this.name});

  factory CustomUser.fromMap(Map<String, dynamic> map) {
    return CustomUser(
      id: map['\$id'],
      name: map['name'],
      latitude: map['latitude'].toDouble(),
      longitude: map['longitude'].toDouble(),
    );
  }
}