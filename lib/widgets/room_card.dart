import 'package:flutter/material.dart';
import '../models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final ValueChanged<Room> onRoomSelected;

  RoomCard({required this.room, required this.onRoomSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onRoomSelected(room),
      child: Card(
        color: Colors.grey[100],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  room.image, // Using URL for the image
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // Display the image when fully loaded
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Icon(Icons.broken_image,
                        size: 50, color: Colors.grey); // Fallback for errors
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(room.location,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
