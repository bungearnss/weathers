class Coord {
  final double? lat;
  final double? lon;

  Coord({
    this.lat,
    this.lon,
  });

  factory Coord.fromJson(dynamic json) {
    if (json == null) {
      return Coord();
    }

    return Coord(lat: json['lat'], lon: json['lon']);
  }
}
