import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tronixbook_project/services/api_service.dart';

class SideMenu extends StatefulWidget {
  final String selectedPage;
  final ValueChanged<String> onPageSelected;

  SideMenu({required this.selectedPage, required this.onPageSelected});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Load the user's name using the ApiService
  void _loadUserName() async {
    String? name = await ApiService().fetchUserProfile();
    setState(() {
      userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color.fromARGB(255, 0, 56, 158),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/tronix_logo.png',
                  width: 150,
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          _buildDrawerItem(
            context,
            icon: Icons.grid_view,
            label: 'Rooms',
            isSelected: widget.selectedPage == 'Rooms',
            onTap: () => widget.onPageSelected('Rooms'),
          ),
          const Spacer(),
          if (userName != null) _buildProfileMenu(context),
        ],
      ),
    );
  }

  // Method to build each menu item
  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(label, style: const TextStyle(color: Colors.white)),
          onTap: onTap,
        ),
      ),
    );
  }

  // Build the profile menu
  Widget _buildProfileMenu(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: PopupMenuButton(
      offset: Offset(0, -50), // Position the popup
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          height: 30, // Adjust height of the item
          padding: EdgeInsets.zero, // Remove default padding
          child: const SizedBox(
            width: 150, // Set width of the popup item
            child: Center(
              child: Text(
                'Sign Out',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          onTap: () async {
            await _logout(context);
          },
        ),
      ],
      child: ListTile(
        leading: const Icon(Icons.account_circle, color: Colors.white),
        title: Text(userName!, style: const TextStyle(color: Colors.white)),
      ),
    ),
  );
}


  // Logout functionality
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token'); // Remove the JWT token from storage

    // Navigate back to the login screen
    Navigator.of(context).pushReplacementNamed('/loginPage');
  }
}
