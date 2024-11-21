import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tronixbook_project/widgets/custom_textfield.dart';
import 'package:tronixbook_project/widgets/success_dialog.dart';
import '../models/room.dart';
import '../providers/booking_provider.dart';
import '../services/api_service.dart';

class CustomerDetailsDialog extends StatefulWidget {
  final Room room;

  const CustomerDetailsDialog({required this.room, Key? key}) : super(key: key);

  @override
  _CustomerDetailsDialogState createState() => _CustomerDetailsDialogState();
}

class _CustomerDetailsDialogState extends State<CustomerDetailsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Loading state

  @override
  Widget build(BuildContext context) {
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: 500,
              height: 700,
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Room image and details
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.room.image,
                            width: 100,
                            height: 80,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.room.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(widget.room.location,
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(thickness: 0, color: Colors.grey[300]),
                    const SizedBox(height: 10),
                    const Text(
                      'Customer Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    CustomTextfield(
                      label: "First Name",
                      controller: bookingProvider.firstNameController,
                      validator: (value) =>
                          value!.isEmpty ? "First name is required" : null,
                    ),
                    const SizedBox(height: 15),
                    CustomTextfield(
                      label: "Last Name",
                      controller: bookingProvider.lastNameController,
                      validator: (value) =>
                          value!.isEmpty ? "Last name is required" : null,
                    ),
                    const SizedBox(height: 15),
                    CustomTextfield(
                      label: "Email",
                      controller: bookingProvider.emailController,
                      validator: bookingProvider.validateEmail,
                    ),
                    const SizedBox(height: 15),
                    CustomTextfield(
                      label: "Notes (Optional)",
                      controller: bookingProvider.notesController,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              _submitReservation(context, bookingProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 56, 158),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Submit"),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black54,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color:
                    Colors.black.withOpacity(0.5), // Semi-transparent overlay
                child: const Center(
                  child: CircularProgressIndicator(), // Loading spinner
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Function to handle reservation submission
  Future<void> _submitReservation(
      BuildContext context, BookingProvider bookingProvider) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading
      });

      try {
        // Make reservation API call
        var reservationData = await ApiService().makeReservation(
          date: bookingProvider.dateController.text,
          time: bookingProvider.timeController.text,
          venue: bookingProvider.roomController.text,
          firstName: bookingProvider.firstNameController.text,
          lastName: bookingProvider.lastNameController.text,
          email: bookingProvider.emailController.text,
          notes: bookingProvider.notesController.text,
        );

        bookingProvider.resetBookingDetails();

        // Show the success dialog
        showDialog(
          context: context,
          builder: (context) => SuccessDialog(
            reservationData: reservationData,
          ),
        ).then((_) {
          // Pop the CustomerDetailsDialog after the SuccessDialog is closed
          Navigator.pop(context);
        });
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading
        });
      }
    }
  }
}
