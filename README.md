# StudyMind - AI-Powered Educational Assistant

<div align="center">

<img src="https://bksaotrljfplhsqtqgre.supabase.co/storage/v1/object/public/studymind/GitHub%20Content/logo.png" alt="StudyMind" width="120" height="120" style="margin-top: 20px; margin-bottom: 16px">

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![NestJs](https://img.shields.io/badge/NestJs-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)](https://nestjs.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://postgresql.org)
[![LangGraph](https://img.shields.io/badge/LangGraph-1C3C3C?style=for-the-badge&logo=langgraph&logoColor=white)](https://www.langchain.com/langgraph)

</div>

### 🚀 Overview

StudyMind is an AI-powered educational assistant mobile app built with Flutter. This app features a hierarchical content management system with an agentic AI chat system, allowing users to create and interact with educational content through natural language prompts.

### ✨ Key Features

- **📚 Hierarchical Content Management**: Organize study materials in a structured, easy-to-navigate system
- **📖 RAG-Powered Analysis**: Advanced retrieval-augmented generation for content-based queries
- **🤖 AI-Powered Content Creation**: Generate folders, notes, documents, flashcards, audio, and images through natural language prompts
- **💬 Intelligent Chat System**: Contextual chat system with natural language understanding

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
