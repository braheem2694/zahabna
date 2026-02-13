class City {
  final int id;
  final int rDhlCountryId;
  final String name;

  City({
    required this.id,
    required this.rDhlCountryId,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] ?? 0,
      rDhlCountryId: json['r_dhl_country_id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'r_dhl_country_id': rDhlCountryId,
      'name': name,
    };
  }
}
