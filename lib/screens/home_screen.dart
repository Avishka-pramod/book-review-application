import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_screen.dart';
import 'edit_screen.dart';
import 'review_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> reviews;
  late Future<Map<String, dynamic>> averageRating;

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _loadAverageRating();
  }

  void _loadReviews() {
    setState(() {
      reviews = ApiService.fetchReviews();
    });
  }

  void _loadAverageRating() {
    setState(() {
      averageRating = ApiService.fetchAverageRating();
    });
  }

  void _sortReviews(String by) async {
    try {
      final sortedReviews = await ApiService.sortReviews(by);
      setState(() {
        reviews = Future.value(sortedReviews);
      });
    } catch (e) {
      _showSnackBar('Failed to sort reviews: ${e.toString()}');
    }
  }

  void _filterReviews(int rating) async {
    try {
      final allReviews = await ApiService.fetchReviews();
      final filtered = allReviews.where((review) => review['rating'] == rating).toList();
      setState(() {
        reviews = Future.value(filtered);
      });
    } catch (e) {
      _showSnackBar('Failed to filter reviews: ${e.toString()}');
    }
  }

  void _deleteReview(int id) async {
    try {
      await ApiService.deleteReview(id);
      _loadReviews();
      _loadAverageRating();
      _showSnackBar('Review deleted successfully.');
    } catch (e) {
      _showSnackBar('Failed to delete review: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Book Reviews',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(blurRadius: 2.0, color: Colors.black45, offset: Offset(0.5, 0.5)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.white),
            onPressed: _showSortSheet,
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            _buildGlassAverageRatingCard(),
            _buildReviewsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddScreen()),
          );
          if (result == true) {
            _loadReviews();
            _loadAverageRating();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildGlassAverageRatingCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: averageRating,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Failed to fetch average rating.'),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Average Rating: ${data['average_rating']} ⭐ (${data['total_reviews']} reviews)',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No reviews to calculate average rating.'),
          );
        }
      },
    );
  }

  Widget _buildReviewsList() {
    return Expanded(
      child: FutureBuilder<List<dynamic>>(
        future: reviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No reviews found.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            );
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => _buildReviewCard(data[index], index),
            );
          }
        },
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 5,
        color: index.isEven ? Colors.deepPurpleAccent.shade200 : Colors.deepPurpleAccent.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          title: Text(
            review['title'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    color: index < review['rating'] ? Colors.amber : Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                review['author'] ?? 'Unknown Author',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                review['text']!.length > 50 ? '${review['text']!.substring(0, 50)}...' : review['text'],
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Added on: ${review['date_added']}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditScreen(review: review)),
                  );
                  if (result == true) {
                    _loadReviews();
                    _loadAverageRating();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () => _deleteReview(review['id']),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReviewDetailsScreen(review: review)),
            );
          },
        ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.white.withOpacity(0.2),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Sort by Rating'),
                  onTap: () {
                    Navigator.pop(context);
                    _sortReviews('rating');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Sort by Date'),
                  onTap: () {
                    Navigator.pop(context);
                    _sortReviews('date');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.white.withOpacity(0.2),
            child: Wrap(
              children: List.generate(
                5,
                (index) => ListTile(
                  leading: Icon(Icons.star, color: Colors.amber),
                  title: Text('${index + 1} Star'),
                  onTap: () {
                    Navigator.pop(context);
                    _filterReviews(index + 1);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
