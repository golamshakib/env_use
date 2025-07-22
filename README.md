# Flutter Dotenv Integration

This documentation provides the steps to integrate the **Flutter Dotenv** package into your Flutter project. By following these steps, you will be able to securely store secret keys and other sensitive data in environment variables.

## Prerequisites

Before proceeding, make sure you have:

- A Flutter project set up.
- A basic understanding of Flutter and Dart.
  
## Steps for Integration

### 1. Set up a Flutter Project
If you don't have an existing Flutter project, you can create one using the following command:

```bash
flutter create your_project_name
cd your_project_name
```

### 2. Add Flutter Dotenv Package

  - Open your pubspec.yaml file.

  - Under dependencies, add the following:

  ```bash
  dependencies:
    flutter:
      sdk: flutter
    flutter_dotenv: ^5.0.2
  ```
   - Under the assets section, add the .env file:

  ```bash
  flutter:
    assets:
      - .env
  ```
  - Run the following command to get the packages:

  ```bash
  flutter pub get
  ```

### 3. Create the .env File

  - Create a .env file at the root of your project.

  - Add your secret keys and their values inside the .env file. For example:
  
  ```bash
  Firebase_web_api_key='Your Firebase Web API Key'
  ```

### 4. Load the .env File in main.dart

  - Import the flutter_dotenv package in your main.dart file:
  
  ```bash
  import 'package:flutter_dotenv/flutter_dotenv.dart';
  ```

  - Load the environment variables at the start of the app in the main() function:
  
  ```bash
  void main() async {
    await dotenv.load(filename: '.env');
    runApp(MyApp());
  }
  ```

  - Access the values from the .env file like this:

  ```bash
  String? firebaseApiKey = dotenv.env['Firebase_web_api_key'];
  print(firebaseApiKey);
  ```

  - Manually Import the Package
  In case the package is not automatically imported by your IDE, manually import it where required in your project:

  ```bash
  import 'package:flutter_dotenv/flutter_dotenv.dart';
  ```

### Notes

- Make sure to keep your .env file out of version control by adding it to .gitignore.

- This package will help you securely store sensitive information like API keys, database credentials, and secret tokens.

For more details, visit the official Flutter Dotenv package documentation.

