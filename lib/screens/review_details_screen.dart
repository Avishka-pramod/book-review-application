import 'dart:ui';
import 'package:flutter/material.dart';
import 'edit_screen.dart';

class ReviewDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> review;

  const ReviewDetailsScreen({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Review Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                // Glass Effect Card Content
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2), 
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            review['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber, 
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Author
                          Text(
                            'By: ${review['author'] ?? 'Unknown Author'}',
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          const SizedBox(height: 10),

                          // Rating with full stars
                          Row(
                            children: [
                              const Text(
                                'Rating: ',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                              ),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    Icons.star,
                                    color: index < (review['rating'] ?? 0)
                                        ? Colors.amber
                                        : Colors.grey.shade400,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 30,
                            thickness: 1.5,
                            color: Colors.white38,
                          ),

                          // Review Text Section
                          const Text(
                            'Review:',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            review['text'] ?? 'No review text available.',
                            style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.6),
                            textAlign: TextAlign.justify,
                          ),

                          const SizedBox(height: 20), 

                          // Date Added
                          Text(
                            'Added on: ${review['date_added'] ?? 'Unknown Date'}',
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
