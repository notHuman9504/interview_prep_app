# Interview Prep App

A Flutter application that allows students to add and share interview questions and answers.

## Features

- User authentication with email and password
- View a list of interview questions and answers
- Filter questions by category
- Add new questions with detailed answers
- View full question details and reveal/hide answers
- User profiles with question history
- Persistent data storage with SharedPreferences

## Setup Instructions

1. Make sure you have Flutter installed on your machine.
2. Clone this repository to your local machine.
3. Run `flutter pub get` to install the required dependencies.
4. Connect a device or start an emulator.
5. Run the app with `flutter run`.

## Dependencies

- Provider: For state management
- UUID: For generating unique IDs for questions
- SharedPreferences: For local data persistence

## Authentication

The app implements a simple authentication system using SharedPreferences:

- Register with name, email, and password
- Login with email and password
- Automatic login on app restart if previously logged in
- Logout functionality

## Data Persistence

All data is stored locally using SharedPreferences:

- User account information
- Interview questions and answers
- Login state

## How to Use

### Authentication

- Start by creating an account with your name, email, and password
- Once registered, you'll be automatically logged in
- Your session persists between app restarts
- Logout from your profile page when needed

### Viewing Questions

- The home screen displays all available interview questions.
- Tap on any question card to view its details.
- Use the filter icon in the app bar to filter questions by category.

### Adding Questions

1. Tap the floating action button (+ icon) on the home screen.
2. Fill in the question details:
   - Title: A brief title for the interview question.
   - Description: More context for the question.
   - Answer: The complete answer to the question.
   - Category: Select from predefined categories.
   - Option to post anonymously.
3. Tap "Submit Question" to add the question to the collection.

### Profile Management

- View your profile information
- See questions you've added
- Access account settings
- Logout from your account

## Future Improvements

- Backend integration for cloud storage
- Social sharing features
- Bookmarking favorite questions
- Question rating system
- Advanced search functionality

## License

This project is licensed under the MIT License.
