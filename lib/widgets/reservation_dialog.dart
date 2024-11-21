import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/room.dart';
import '../providers/booking_provider.dart';
import '../services/api_service.dart';
import 'customer_details_dialog.dart';

class ReservationDialog extends StatefulWidget {
  final Room room;

  ReservationDialog({required this.room});

  @override
  _ReservationDialogState createState() => _ReservationDialogState();
}

class _ReservationDialogState extends State<ReservationDialog> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  List<String> availableTimes = [
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM"
  ];

  List<String> reservedTimes = [];

  @override
  void initState() {
    super.initState();
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    bookingProvider.setVenue(widget.room.name); // Set the venue (room name)
    _fetchReservedTimes(); // Fetch reserved times for this venue/room
  }

  // Fetch reserved times for the specific venue (room) and selected date
  void _fetchReservedTimes() async {
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    try {
      var reserved = await ApiService().fetchReservedTimes(
          widget.room.name, bookingProvider.selectedDate ?? '');
      setState(() {
        reservedTimes = reserved;
        // Reset availableTimes and remove reserved times
        availableTimes = [
          "9:00 AM",
          "10:00 AM",
          "11:00 AM",
          "12:00 PM",
          "1:00 PM",
          "2:00 PM",
          "3:00 PM",
          "4:00 PM"
        ]; // Reset to all times
        // Filter available times by removing the reserved times
        availableTimes = availableTimes
            .where((time) => !reservedTimes.contains(time))
            .toList();
        bookingProvider.setReservedTimes(widget.room.name,
            reservedTimes); // Store room-specific reserved times
      });
    } catch (e) {
      print("Error fetching reserved times: $e");
    }
  }

  void _showCustomerDetailsDialog() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => CustomerDetailsDialog(room: widget.room),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: 500,
          height: 800,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
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

                // Calendar widget
                const Text(
                  'Select Reservation Date & Time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 16),
                TableCalendar(
                  focusedDay: _focusDay,
                  firstDay: DateTime.now(),
                  lastDay: DateTime(2025, 12, 31),
                  calendarFormat: _format,
                  currentDay: _currentDay,
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 56, 158),
                      shape: BoxShape.circle,
                    ),
                  ),
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _format = format;
                    });
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _currentDay = selectedDay;
                      _focusDay = focusedDay;
                      _dateSelected = true;
                      bookingProvider.setSelectedDate(selectedDay);
                      _fetchReservedTimes();

                      // check if weekend is selected
                      if (selectedDay.weekday == 6 ||
                          selectedDay.weekday == 7) {
                        _isWeekend = true;
                        _timeSelected = false;
                        _currentIndex = null;
                      } else {
                        _isWeekend = false;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Display available times if not a weekend
                if (!_isWeekend)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableTimes.asMap().entries.map((entry) {
                      int index = entry.key;
                      String time = entry.value;
                      return ChoiceChip(
                        label: Text(time),
                        selected: _currentIndex == index,
                        selectedColor: const Color.fromARGB(
                            255, 0, 56, 158), // Selected color
                        backgroundColor: Colors.grey[200], // Unselected color
                        onSelected: (selected) {
                          setState(() {
                            _currentIndex = index;
                            _timeSelected = true;
                            bookingProvider.setSelectedTime(time);
                          });
                        },
                        labelStyle: TextStyle(
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.black, // Text color
                        ),
                      );
                    }).toList(),
                  ),

                if (_isWeekend)
                  const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Weekends are not available for reservations.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 30),

                // Confirm button
                ElevatedButton(
                  onPressed: _timeSelected && _dateSelected
                      ? _showCustomerDetailsDialog
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 56, 158),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
