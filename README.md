# book_review_application

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

# Book Review Application

## Overview
The Book Review Application is a straightforward project that allows users to create, view, update, and delete book reviews. It uses a backend API built with Python Flask and a frontend developed in Flutter.

## Features
- **Backend**:
  - A REST API using Flask.
  - SQLite database for managing reviews.
  - CRUD operations for reviews (Create, Read, Update, Delete).
  - CORS support for seamless integration with the Flutter frontend.
- **Frontend**:
  - Built with Flutter for a responsive and user-friendly interface.
  - Includes features like filtering reviews by rating and sorting by date.

## Tech Stack
- **Backend**: Python, Flask, SQLite
- **Frontend**: Flutter, Dart

## How to Set Up

### Backend Setup
1. Open your terminal and go to the `backend` folder.
   ```bash
   cd backend
   ```
2. Create a virtual environment for Python dependencies.
   ```bash
   python -m venv venv
   ```
3. Activate the virtual environment:
   - **Windows**:
     ```bash
     venv\Scripts\activate
     ```
   - **Linux/Mac**:
     ```bash
     source venv/bin/activate
     ```
4. Install the required dependencies.
   ```bash
   pip install -r requirements.txt
   ```
5. Start the Flask server.
   ```bash
   python app.py
   ```
   The backend will run at `http://127.0.0.1:5000/`.

### Frontend Setup
1. Navigate to the `lib` folder for the Flutter project.
   ```bash
   cd lib
   ```
2. Install Flutter dependencies.
   ```bash
   flutter pub get
   ```
3. Run the Flutter application.
   ```bash
   flutter run
   ```
   Make sure an emulator or a connected device is available.

## API Endpoints
- **GET /reviews**: Fetch all reviews.
- **POST /reviews**: Add a new review.
- **PUT /reviews/<id>**: Update a review by ID.
- **DELETE /reviews/<id>**: Delete a review by ID.

## Troubleshooting
- **Flask Module Missing (ModuleNotFoundError: No module named 'flask')**:
  - Ensure the virtual environment is activated:
    ```bash
    venv\Scripts\activate  # On Windows
    source venv/bin/activate  # On Linux/Mac
    ```
  - Install Flask:
    ```bash
    pip install flask
    ```

- **Database Not Found**:
  - Ensure `db.sqlite` is in the `backend` folder.
  - If the file is missing, delete any old database files and restart the Flask server. This will recreate the database.

- **Flask Server Not Running or Issues with Dependencies**:
  - Check if all required dependencies are installed using:
    ```bash
    pip install flask flask-cors flask-sqlalchemy
    ```
  - If the issue persists, uninstall and reinstall Flask:
    ```bash
    pip uninstall flask
    pip install flask
    ```

- **Emulator Issues**:
  - For Flutter emulators, use `http://10.0.2.2:5000/` as the backend URL in your `main.dart` file.
  - Ensure the backend server and emulator are running on the same network for physical devices.



