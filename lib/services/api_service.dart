import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // === USERS ===

  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> getUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('User not found');
    }
  }

  /// ✅ NEW: Fetch all users (for swipe deck)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Could not fetch users');
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableUsers(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/available?userId=$userId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Could not fetch available users for userId: $userId');
    }
  }

  Future<void> updateUserLocation(String userId, String location) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/$userId/location'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'location': location}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update location');
    }
  }

  // === SKILLS ===
  Future<List<Map<String, dynamic>>> getAllSkills() async {
    final response = await http.get(Uri.parse('$baseUrl/skills'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch skills');
    }
  }

  Future<void> createSkill(String skillName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/skills'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': skillName}),
    );
    if (response.statusCode != 200) {
      throw Exception('Could not create skill');
    }
  }

  // === USER SKILLS ===

  Future<void> addSkillToUser(String userId, Map<String, dynamic> skill) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/skills'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(skill),
    );
    if (response.statusCode != 200) {
      throw Exception('Could not add skill to user');
    }
  }

  Future<void> removeSkillFromUser(String userId, int skillId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId/skills/$skillId'),
    );
    if (response.statusCode != 204) {
      throw Exception('Could not remove skill');
    }
  }

  // === MATCHES ===

  Future<void> createMatch(String user1Id, String user2Id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/matches?user1Id=$user1Id&user2Id=$user2Id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Could not create match');
    }
  }

  Future<void> updateMatchStatus(String matchId, String status) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/matches/$matchId/status?status=$status'),
    );
    if (response.statusCode != 200) {
      throw Exception('Could not update match status');
    }
  }

  Future<List<dynamic>> getMatchesForUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/matches/user/$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Could not load matches');
    }
  }

  // === MATCH SKILLS ===

  Future<List<dynamic>> getSkillsForMatch(String matchId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/matches/$matchId/skills'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Could not get match skills');
    }
  }

  Future<void> addSkillToMatch(String matchId, int skillId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/matches/$matchId/skills?skillId=$skillId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Could not add skill to match');
    }
  }

  Future<void> removeSkillFromMatch(String matchId, int skillId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/matches/$matchId/skills?skillId=$skillId'),
    );
    if (response.statusCode != 204) {
      throw Exception('Could not remove skill from match');
    }
  }

  // === MESSAGES ===

  Future<void> sendMessage(Map<String, dynamic> message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(message),
    );
    if (response.statusCode != 200) {
      throw Exception('Could not send message');
    }
  }

  Future<List<dynamic>> getMessagesForMatch(String matchId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/messages/match/$matchId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Could not get messages');
    }
  }
}
