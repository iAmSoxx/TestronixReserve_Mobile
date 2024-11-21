import 'package:flutter/material.dart';
import '../models/room.dart';
import '../widgets/reservation_dialog.dart';

class RoomDetailPage extends StatelessWidget {
  final Room room;
  final VoidCallback onBack;

  RoomDetailPage({required this.room, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: onBack,
        ),
        title: Text(room.name, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(top: 25, left: 50, right: 50, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Image and Details
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    room.image, // Assuming this is the URL of the image
                    width: 300,
                    height: 250,
                    fit: BoxFit.cover,
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
                          size: 250, color: Colors.grey); // Fallback for errors
                    },
                  ),
                ),
                const SizedBox(width: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(room.location,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(thickness: 0, color: Colors.grey[300]),
            const SizedBox(height: 16),

            // Details Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 243, 242, 242),
                ),
              ),
              child: Card(
                color: Colors.white,
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Row(
                        children: [
                          Text('Capacity',
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(width: 200),
                          Text('Location',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(room.capacity),
                          const SizedBox(width: 230),
                          Text(room.location),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text('Details',
                          style: TextStyle(color: Colors.grey)),
                      Text(room.details),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Reservation Button
            ElevatedButton(
              onPressed: () {
                // Show reservation dialog on button press
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ReservationDialog(room: room); // Pass room data
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 56, 158),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Make a Reservation"),
            ),
          ],
        ),
      ),
    );
  }
}
