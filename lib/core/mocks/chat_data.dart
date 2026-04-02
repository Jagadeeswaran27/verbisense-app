import 'package:verbisense/features/chat/data/models/chat_model.dart';

final List<ChatModel> chatMessagesMock = [
  ChatModel(
    query: "What is Flutter?",
    heading1: "Introduction to Flutter",
    heading2: [
      "Cross-platform Framework",
      "Widget-based Architecture",
      "Hot Reload Feature",
    ],
    keyTakeaways:
        "Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.",
    points: Points(
      points: {
        "Performance": [
          "Compiles to native ARM code",
          "60fps smooth animations",
          "Fast startup time",
        ],
        "Development": [
          "Hot reload for instant updates",
          "Rich widget library",
          "Extensive documentation",
        ],
        "Community": [
          "Large and active community",
          "Thousands of packages on pub.dev",
          "Regular updates from Google",
        ],
      },
    ),
    example: [
      "Building mobile apps for iOS and Android",
      "Creating responsive web applications",
      "Developing desktop applications for Windows, macOS, and Linux",
    ],
    summary:
        "Flutter enables developers to create high-performance, beautiful applications across multiple platforms using a single codebase, with features like hot reload and a rich widget ecosystem.",
    error: "",
  ),
  ChatModel(
    query: "Explain async and await in Dart",
    heading1: "Asynchronous Programming in Dart",
    heading2: [
      "Future and Async Operations",
      "Error Handling",
      "Best Practices",
    ],
    keyTakeaways:
        "Async/await makes asynchronous code look and behave like synchronous code, making it easier to read and maintain.",
    points: Points(
      points: {
        "Async Keyword": [
          "Marks a function as asynchronous",
          "Returns a Future automatically",
          "Allows use of await inside",
        ],
        "Await Keyword": [
          "Pauses execution until Future completes",
          "Can only be used in async functions",
          "Returns the completed value",
        ],
        "Error Handling": [
          "Use try-catch blocks",
          "Handle Future errors with catchError",
          "Always handle potential errors",
        ],
      },
    ),
    example: [
      "Future<String> fetchData() async { return await http.get(url); }",
      "try { var data = await fetchData(); } catch (e) { print(e); }",
      "await Future.delayed(Duration(seconds: 2));",
    ],
    summary:
        "Async/await syntax in Dart simplifies asynchronous programming by allowing you to write asynchronous code that looks synchronous, improving code readability and maintainability.",
    error: "",
  ),
  ChatModel(
    query: "What is state management in Flutter?",
    heading1: "State Management Fundamentals",
    heading2: ["Types of State", "Popular Solutions", "When to Use What"],
    keyTakeaways:
        "State management is crucial for managing data flow and UI updates in Flutter applications efficiently.",
    points: Points(
      points: {
        "Local State": [
          "Managed within a single widget",
          "Use setState() for simple cases",
          "Short-lived and widget-specific",
        ],
        "App State": [
          "Shared across multiple widgets",
          "Requires state management solution",
          "Persists across widget rebuilds",
        ],
        "Popular Solutions": [
          "Provider - Simple and recommended",
          "Riverpod - Modern and type-safe",
          "Bloc - Event-driven architecture",
          "GetX - All-in-one solution",
        ],
      },
    ),
    example: [
      "setState(() { counter++; }) for local state",
      "Provider.of<MyModel>(context) for app state",
      "ref.watch(myProvider) with Riverpod",
    ],
    summary:
        "Effective state management is essential for building scalable Flutter apps. Choose the right solution based on your app's complexity and team preferences.",
    error: "",
  ),
];
