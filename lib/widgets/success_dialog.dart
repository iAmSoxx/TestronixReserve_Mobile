import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessDialog extends StatelessWidget {
  final Map<String, dynamic> reservationData;

  const SuccessDialog({super.key, required this.reservationData});

  @override
  Widget build(BuildContext context) {
    // Extract the actual reservation data
    final Map<String, dynamic> data = reservationData['data'];

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: 500,
        height: 700,
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Lottie.asset('assets/successDarkBlue1.json'),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Your Reservation ID is: ${data['reservation_id'] ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 56, 158),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
