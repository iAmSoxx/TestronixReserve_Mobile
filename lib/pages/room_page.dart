import 'package:flutter/material.dart';
import 'package:tronixbook_project/services/api_service.dart';

import '../widgets/side_menu.dart';
import '../widgets/room_card.dart';
import '../models/room.dart';
import '../pages/room_detail_page.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<Room> rooms = [];
  List<Room> filteredRooms = [];
  TextEditingController searchController = TextEditingController();
  Room? selectedRoom;

  @override
  void initState() {
    super.initState();
     fetchRoomsFromApi();
  }

   Future<void> fetchRoomsFromApi() async {
    try {
      final apiService = ApiService();
      final fetchedRooms = await apiService.fetchRooms();
      setState(() {
        rooms = fetchedRooms;
        filteredRooms = rooms;
      });
    } catch (e) {
      print("Error fetching rooms: $e");
      // Handle the error, e.g., show a Snackbar or a message
    }
  }

  void _filterRooms(String query) {
    final results = rooms
        .where((room) =>
            room.name.toLowerCase().contains(query.toLowerCase()) ||
            room.location.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredRooms = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SideMenu(
              selectedPage: 'Rooms',
              onPageSelected: (page) {
                // Navigate to other pages if needed
              },
            ),
            Expanded(
              child: selectedRoom == null
                  ? Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        title: Row(
                          children: [
                            const Text(
                              'Rooms',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              child: Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    icon:
                                        Icon(Icons.search, color: Colors.grey),
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: _filterRooms,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 4 / 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: filteredRooms.length,
                          itemBuilder: (context, index) {
                            return RoomCard(
                              room: filteredRooms[index],
                              onRoomSelected: (room) {
                                setState(() {
                                  selectedRoom = room;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    )
                  : RoomDetailPage(
                      room: selectedRoom!,
                      onBack: () {
                        setState(() {
                          selectedRoom = null;
                        });
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
