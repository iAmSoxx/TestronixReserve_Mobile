import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingProvider with ChangeNotifier {
  // Controllers for customer details
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Controllers for reservation details
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  String? selectedDate;
  String? selectedTime;

  // Mapping to store reserved times for each room/venue
  Map<String, List<String>> venueReservedTimes = {};

  // Email validation regex pattern
  final String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';

  // Initialize room/venue name
  void setVenue(String venueName) {
    roomController.text = venueName;
    notifyListeners();
  }

  // Set reserved times for a specific venue
  void setReservedTimes(String venueName, List<String> times) {
    venueReservedTimes[venueName] = times;
    notifyListeners();
  }

  // Reset all controllers and selected data
  void resetBookingDetails() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    notesController.clear();
    dateController.clear();
    timeController.clear();
    roomController.clear();
    selectedDate = null;
    selectedTime = null;
    notifyListeners();
  }

  // Set selected date and time
  void setSelectedDate(DateTime date) {
    selectedDate = DateFormat('yyyy-MM-dd').format(date);
    dateController.text = selectedDate!;
    notifyListeners();
  }

  void setSelectedTime(String time) {
    selectedTime = time;
    timeController.text = time;
    notifyListeners();
  }

  // Get reserved times for a specific venue
  List<String> getReservedTimes(String venueName) {
    return venueReservedTimes[venueName] ?? [];
  }

  // Validation method for customer email
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email is required";
    } else if (!RegExp(emailPattern).hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }
  
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    notesController.dispose();
    dateController.dispose();
    timeController.dispose();
    roomController.dispose();
    super.dispose();
  }
}
