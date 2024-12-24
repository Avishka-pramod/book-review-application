import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.103:5000';

  static Future<List<dynamic>> fetchReviews() async {
    final response = await http.get(Uri.parse('$baseUrl/reviews'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch reviews');
    }
  }

  static Future<void> addReview(Map<String, dynamic> review) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(review),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add review');
    }
  }

  static Future<void> updateReview(int id, Map<String, dynamic> review) async {
    final response = await http.put(
      Uri.parse('$baseUrl/reviews/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(review),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update review');
    }
  }

  static Future<void> deleteReview(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/reviews/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete review');
    }
  }

  static Future<List<dynamic>> sortReviews(String by) async {
    final response = await http.get(Uri.parse('$baseUrl/reviews/sort?by=$by'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sort reviews');
    }
  }

  static Future<Map<String, dynamic>> fetchAverageRating() async {
    final response = await http.get(Uri.parse('$baseUrl/reviews/average'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch average rating');
    }
  }
}
