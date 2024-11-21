class Room {
  final String name;
  final String location;
  final String image;
  final String details;
  final String capacity;

  Room({
    required this.name,
    required this.location,
    required this.image,
    required this.details,
    required this.capacity,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      name: json['room-venue'],
      location: json['room-location'],
      image: json['room-image'],
      details: json['room-features'],
      capacity: json['room-capacity'],
    );
  }
}
