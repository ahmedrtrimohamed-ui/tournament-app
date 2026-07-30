// lib/data/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_profile.dart';
import '../../core/constants/api_constants.dart';
import '../providers/storage_provider.dart';

class AuthService {
  final http.Client client;
  final StorageService storage;

  AuthService({required this.client, required this.storage});

  // Login method
  Future<void> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.saveToken(data['access']);
      await storage.saveRefreshToken(data['refresh']);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Login failed');
    } else {
      throw Exception('Server error. Please try again.');
    }
  }

  // Register method
  Future<void> register(String username, String email, String password) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // Registration successful, OTP sent
      return;
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body);

      // Handle field-specific errors
      if (error is Map) {
        if (error.containsKey('email')) {
          throw Exception(error['email'][0]);
        } else if (error.containsKey('username')) {
          throw Exception(error['username'][0]);
        } else {
          throw Exception('Registration failed');
        }
      }
      throw Exception('Registration failed');
    } else {
      throw Exception('Server error. Please try again.');
    }
  }

  // Verify OTP method
  Future<void> verifyOtp(String email, String otp) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.verifyOtp}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp_code': otp}),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'OTP verification failed');
    }
  }

  // Logout method
  Future<void> logout() async {
    await storage.removeToken();
    await storage.removeRefreshToken();
  }

  // Check if authenticated
  Future<bool> isAuthenticated() async {
    final token = storage.getToken();
    return token != null && token.isNotEmpty;
  }

  // Fetch user profile
  Future<UserProfile?> fetchProfile() async {
    final token = storage.getToken();
    if (token == null) return null;

    final response = await client.get(
      Uri.parse(
        '${ApiConstants.baseUrl}/users/profile/',
      ), // Assuming standard DRF path or adjust later
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data);
    }
    return null;
  }
}
