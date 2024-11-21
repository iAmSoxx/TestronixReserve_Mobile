import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tronixbook_project/models/room.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _apiUrl = "https://api-tronix-reserve.supsofttech.tmc-innovations.com/api/reservation";
  final String _getURL = "https://api-tronix-reserve.supsofttech.tmc-innovations.com/api/dashboard";
  final String _loginUrl = "https://api-tronix-reserve.supsofttech.tmc-innovations.com/api/auth/login";
  final String _registerUrl = "https://api-tronix-reserve.supsofttech.tmc-innovations.com/api/auth/register";
  final String _fetchProfile = "https://api-tronix-reserve.supsofttech.tmc-innovations.com/api/me";
  final String _fetchRooms = "https://api-tronix-reserve.supsofttech.tmc-innovations.com/api/room";

  // Existing method to make a reservation
  Future<Map<String, dynamic>> makeReservation({
    required String firstName,
    required String lastName,
    required String email,
    String? notes,
    required String venue,
    required String date,
    required String time,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        print("No JWT token found.");
        throw Exception("Missing JWT token");
      }

      // Set the token in the headers
      _dio.options.headers['Authorization'] = 'Bearer $token';

      var response = await _dio.post(_apiUrl,
          data: json.encode({
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'notes': notes,
            'venue': venue,
            'date': date,
            'time': time,
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data; // Returns the reservation info with ID
      } else {
        throw Exception(
            'Failed to make reservation: ${response.statusMessage}');
      }
    } catch (e) {
      print("Error making reservation: $e");
      throw Exception('Error: $e');
    }
  }

  // Fetch reserved times for a specific venue and date
  Future<List<String>> fetchReservedTimes(String venue, String date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        print("No JWT token found.");
        throw Exception("Missing JWT token");
      }

      // Set the token in the headers
      _dio.options.headers['Authorization'] = 'Bearer $token';

      var response = await _dio.get(_getURL);

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data['data']);

        // Filter reservations based on venue and date
        List<String> reservedTimes = data
            .where((reservation) =>
                reservation['customer']['venue'] == venue &&
                reservation['customer']['date'] == date)
            .map((reservation) => reservation['customer']['time'] as String)
            .toList();

        return reservedTimes;
      } else {
        throw Exception(
            'Failed to fetch reservations: ${response.statusMessage}');
      }
    } catch (e) {
      print("Error fetching reserved times: $e");
      throw Exception('Error: $e');
    }
  }

  // New method for user login
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        _loginUrl,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        String token = response.data['access_token'];

        // Store token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        return token; // Return the token if login is successful
      } else {
        return null; // Login failed, return null
      }
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 401) {
        // Return null specifically for 401 Unauthorized status
        return null;
      } else {
        throw Exception('Login Error: $e');
      }
    }
  }

  // New method for user registration
  Future<String?> register(String name, String email, String password,
      String passwordConfirmation) async {
    try {
      final response = await _dio.post(
        _registerUrl,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 200) {
        return response
            .data['access_token']; // Return token if registration is successful
      } else {
        throw Exception('Failed to register: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Registration Error: $e');
    }
  }

  // Add this new method to ApiService

  Future<String?> fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        print("No JWT token found.");
        throw Exception("Missing JWT token");
      }

      // Set the token in the headers
      _dio.options.headers['Authorization'] = 'Bearer $token';

      // API call to get user profile
      final response = await _dio.get(_fetchProfile);

      if (response.statusCode == 200) {
        // Extract the "name" field from the response
        String name = response.data['name'];
        return name;
      } else {
        throw Exception(
            'Failed to fetch user profile: ${response.statusMessage}');
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      throw Exception('Error: $e');
    }
  }

  Future<List<Room>> fetchRooms() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception("Missing JWT token");
    }

    // Set the token in the headers
    _dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await _dio.get(_fetchRooms);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch rooms: ${response.statusMessage}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

}
