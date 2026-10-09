# StudyMind - AI-Powered Learning Platform

<div align="center">

<img src="https://bksaotrljfplhsqtqgre.supabase.co/storage/v1/object/public/studymind/GitHub%20Content/logo.png" alt="StudyMind" width="120" height="120" style="margin-top: 20px; margin-bottom: 16px">

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![NestJs](https://img.shields.io/badge/NestJs-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)](https://nestjs.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://postgresql.org)
[![LangGraph](https://img.shields.io/badge/LangGraph-1C3C3C?style=for-the-badge&logo=langgraph&logoColor=white)](https://www.langchain.com/langgraph)

</div>

### 🚀 Overview

StudyMind is an AI-powered learning platform to create, organize, and interact with study materials. It includes hierarchical content management, RAG-based question answering, and agentic AI to generate content from natural-language prompts.

### ✨ Key Features

- **📚 Hierarchical Content Management**: Organize study materials in one place.
- **📖 RAG-Based Question Answering**: Ask questions and get answers based on user-uploaded study materials.
- **🤖 Agentic AI Content Generation**: Generate folder, note, document, flashcard, image, and audio from natural-language prompts.

### 📱 Screenshots

<div align="center" style="display: grid;
  grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
  <img src="https://bksaotrljfplhsqtqgre.supabase.co/storage/v1/object/public/studymind/GitHub%20Content/Home.png" alt="Home Screen" width="200" style="margin: 10px">
  <img src="https://bksaotrljfplhsqtqgre.supabase.co/storage/v1/object/public/studymind/GitHub%20Content/Library.png" alt="Library Screen" width="200" style="margin: 10px">
  <img src="https://bksaotrljfplhsqtqgre.supabase.co/storage/v1/object/public/studymind/GitHub%20Content/Chat.png" alt="Chat Screen" width="200" style="margin: 10px">
</div>

### 🛠️ Technical Stack

**Frontend**: Dart, Flutter, Getx

**Backend**: TypeScript, NestJS, PostgreSQL, Drizzle ORM

**AI & ML**: Gemini API, LangChain, LangGraph, Pinecone

### 📱 App Navigation

```
Splash Screen
├── Authentication
│   ├── Login
│   └── Register
└── Main App (Bottom Navigation)
    ├── Home
    ├── Library
    │   └── Floating '+' Button → Create Item
    ├── Chatbot
    │   └── Floating '+' Button → Create Chat
    └── Profile
```

### 🏗️ Project Structure

```
lib/
├── bindings/
├── constants/
├── controllers/
├── core/
├── layouts/
├── models/
├── presentation/
│   ├── chatbot/
│   │   ├── widgets/
│   │   └── chat.dart
│   ├── home/
│   │   ├── widgets/
│   │   └── home.dart
│   ├── library/
│   │   ├── widgets/
│   │   └── library.dart
│   └── profile/
│       ├── widgets/
│       └── profile.dart
├── routes/
├── services/
├── theme/
├── widgets/
└── main.dart
```

## 🤖 AI Capabilities

### Content Creation

```
Create a folder named 'Time Complexity'
Create a pdf document about 'Time Complexity'
```

### Content Read

```
@Time Complexity can you please explain O(log n)
```

---

<div align="center">
  Made with ❤️ for better learning experiences

⭐ **Don't forget to star this repository if you found it helpful!** ⭐

</div>
