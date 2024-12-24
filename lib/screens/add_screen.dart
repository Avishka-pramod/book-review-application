import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/api_service.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String author = '';
  double rating = 1; 
  String text = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await ApiService.addReview({
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
      resizeToAvoidBottomInset: true, 
      appBar: AppBar(
        title: const Text('Add Review'),
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
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          TextFormField(
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


                          TextFormField(
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


                          TextFormField(
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
                                'Submit',
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
