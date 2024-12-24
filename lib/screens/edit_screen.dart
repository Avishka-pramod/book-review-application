import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/api_service.dart';

class EditScreen extends StatefulWidget {
  final Map<String, dynamic> review;

  const EditScreen({Key? key, required this.review}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String author;
  late double rating;
  late String text;

  @override
  void initState() {
    super.initState();
    // Initialize fields with current review data
    title = widget.review['title'];
    author = widget.review['author'];
    rating = widget.review['rating'].toDouble();
    text = widget.review['text'];
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await ApiService.updateReview(widget.review['id'], {
        'title': title,
        'author': author,
        'rating': rating.toInt(),
        'text': text,
      });
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Review'),
        backgroundColor: Colors.deepPurple, 
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
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3), 
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title Input Field
                          TextFormField(
                            initialValue: title,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: const TextStyle(color: Colors.deepPurple),
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            onSaved: (value) => title = value!,
                            validator: (value) => value!.isEmpty ? 'Title is required' : null,
                          ),
                          const SizedBox(height: 16),

                          // Author Input Field
                          TextFormField(
                            initialValue: author,
                            decoration: InputDecoration(
                              labelText: 'Author',
                              labelStyle: const TextStyle(color: Colors.deepPurple),
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            onSaved: (value) => author = value!,
                            validator: (value) => value!.isEmpty ? 'Author is required' : null,
                          ),
                          const SizedBox(height: 16),

                          // Review Text Field
                          TextFormField(
                            initialValue: text,
                            decoration: InputDecoration(
                              labelText: 'Review Text',
                              labelStyle: const TextStyle(color: Colors.deepPurple),
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.7),
                            ),
                            maxLines: 4, 
                            onSaved: (value) => text = value!,
                            validator: (value) => value!.isEmpty ? 'Review text is required' : null,
                          ),
                          const SizedBox(height: 20),

                          // Rating Section
                          const Text(
                            'Rating',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          ),
                          const SizedBox(height: 10),
                          RatingBar.builder(
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (value) {
                              setState(() {
                                rating = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          // Update Button
                          Center(
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
