from flask import Flask, request, jsonify
from flask_cors import CORS
from models import db, Review

app = Flask(__name__)
CORS(app)


app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///db.sqlite'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False


db.init_app(app)
with app.app_context():
    db.create_all()


    if not Review.query.all():
        sample_review_1 = Review(
            title="The Great Gatsby",
            author="F. Scott Fitzgerald",
            rating=5,
            text="A classic novel of the Jazz Age."
        )
        sample_review_2 = Review(
            title="To Kill a Mockingbird",
            author="Harper Lee",
            rating=4,
            text="A profound novel about racial injustice."
        )
        db.session.add(sample_review_1)
        db.session.add(sample_review_2)
        db.session.commit()

# Routes
@app.route('/reviews', methods=['GET'])
def get_reviews():
    """Fetch all reviews."""
    reviews = Review.query.all()
    return jsonify([review.to_dict() for review in reviews])

@app.route('/reviews', methods=['POST'])
def create_review():
    """Create a new review."""
    data = request.get_json()

    if not all(key in data for key in ('title', 'author', 'rating', 'text')):
        return jsonify({'error': 'Invalid request. Missing fields.'}), 400

    new_review = Review(
        title=data['title'],
        author=data['author'],
        rating=data['rating'],
        text=data['text']
    )
    db.session.add(new_review)
    db.session.commit()
    return jsonify(new_review.to_dict()), 201

@app.route('/reviews/<int:id>', methods=['PUT'])
def update_review(id):
    """Update an existing review by ID."""
    data = request.get_json()

    if not all(key in data for key in ('title', 'author', 'rating', 'text')):
        return jsonify({'error': 'Invalid request. Missing fields.'}), 400

    review = Review.query.get_or_404(id)
    review.title = data['title']
    review.author = data['author']
    review.rating = data['rating']
    review.text = data['text']
    db.session.commit()
    return jsonify(review.to_dict())

@app.route('/reviews/<int:id>', methods=['DELETE'])
def delete_review(id):
    """Delete a review by ID."""
    review = Review.query.get_or_404(id)
    db.session.delete(review)
    db.session.commit()
    return jsonify({'message': 'Review deleted successfully'})

@app.route('/reviews/sort', methods=['GET'])
def sort_reviews():
    """Sort reviews by the specified parameter."""
    sort_by = request.args.get('by', 'rating')
    if sort_by == 'rating':
        reviews = Review.query.order_by(Review.rating.desc()).all()
    elif sort_by == 'date':
        reviews = Review.query.order_by(Review.date_added.desc()).all()
    else:
        return jsonify({'error': 'Invalid sort parameter. Use "rating" or "date".'}), 400

    return jsonify([review.to_dict() for review in reviews])

@app.route('/reviews/average', methods=['GET'])
def calculate_average_rating():
    """Calculate and return the average rating of all reviews."""
    reviews = Review.query.all()
    if not reviews:
        return jsonify({'average_rating': 0, 'total_reviews': 0})

    total_rating = sum(review.rating for review in reviews)
    average_rating = total_rating / len(reviews)

    return jsonify({'average_rating': round(average_rating, 2), 'total_reviews': len(reviews)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
