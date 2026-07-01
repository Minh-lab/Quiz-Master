# Kế hoạch triển khai Chatbot dùng Firebase Vertex AI & Firestore

> **Mục tiêu**: Xây dựng chức năng Chatbot hỏi đáp AI sử dụng dịch vụ chính chủ **Vertex AI in Firebase** (không cần quản lý API Key thủ công qua `.env`) và lưu trữ lịch sử qua **Firebase Firestore**.
> **Kiến trúc**: Tuân thủ Clean Architecture, `Cubit`, `get_it`, `dartz Either`, `Equatable`.

---

## 1. Ưu điểm khi dùng Firebase Vertex AI
Thay vì dùng package `google_generative_ai` (yêu cầu nhúng thẳng API Key vào app - kém bảo mật), chúng ta sẽ dùng package `firebase_vertexai`.
- **Bảo mật cao**: SDK gắn chặt với Firebase Auth và Firebase App Check. Kẻ xấu không thể lấy cắp API Key từ file APK/IPA.
- **Quản lý tập trung**: Quản lý hạn mức (quota) và chi phí chung một nơi trên Firebase Console.
- **Tích hợp sẵn**: Cùng hệ sinh thái với Firestore mà dự án đang dùng.

---

## 2. Phạm vi tính năng
- **Firebase Vertex AI**: Gửi câu hỏi và nhận câu trả lời từ model `gemini-1.5-flash` hoặc `gemini-1.5-pro`.
- **Chat Session**: Người dùng tạo nhiều phiên trò chuyện khác nhau. Tự động sinh tiêu đề (Title).
- **Lưu trữ Firestore**: Lưu trữ an toàn tin nhắn trong collection của user. Tự động đồng bộ lịch sử để làm ngữ cảnh (context) cho AI.

---

## 3. Cấu trúc Cơ sở dữ liệu (Firestore)

**Collection: `users/{uid}/chat_sessions/`**
- `id` (String): ID phiên chat.
- `title` (String): Tiêu đề phiên.
- `createdAt`, `updatedAt` (Timestamp).

**Collection: `users/{uid}/chat_sessions/{sessionId}/messages/`**
- `id` (String)
- `content` (String)
- `role` (String): `"user"` hoặc `"model"` (Firebase Vertex AI dùng `model` thay vì `assistant`).
- `createdAt` (Timestamp)

---

## 4. Tích hợp Firebase Vertex AI (Data Layer)

Thêm package vào `pubspec.yaml`:
```yaml
dependencies:
  firebase_vertexai: ^0.1.1 # (kiểm tra phiên bản mới nhất)
```

**Mã giả Data Source:**
```dart
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  final FirebaseFirestore firestore;
  late final GenerativeModel model;

  ChatbotRemoteDataSourceImpl({required this.firestore}) {
    // Khởi tạo model từ Firebase Vertex AI
    model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-1.5-flash',
      systemInstruction: Content.system('Bạn là gia sư AI luyện thi THPTQG...'),
    );
  }

  @override
  Future<String> sendMessage(String sessionId, String uid, String message, List<ChatMessageEntity> history) async {
    // 1. Chuyển lịch sử local thành định dạng Content của Firebase AI
    final chatHistory = history.map((msg) => 
       Content(msg.role, [TextPart(msg.content)])
    ).toList();

    // 2. Khởi tạo ChatSession của Vertex AI
    final chat = model.startChat(history: chatHistory);

    // 3. Gửi tin nhắn mới
    final response = await chat.sendMessage(Content.text(message));
    
    return response.text ?? 'Không có phản hồi';
  }
}
```

### 4.1. Domain Layer (Repository & UseCase)

**ChatbotRepository (Interface):**
```dart
import 'package:dartz/dartz.dart';
import 'package:quiz_mater_apllication/src/core/error/failures.dart';

abstract class ChatbotRepository {
  Future<Either<Failure, List<ChatSessionEntity>>> getChatSessions(String uid);
  
  Future<Either<Failure, String>> createChatSession(String uid, String title);
  
  Future<Either<Failure, List<ChatMessageEntity>>> getChatHistory(String uid, String sessionId);
  
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String uid,
    required String sessionId,
    required String message,
    required List<ChatMessageEntity> history,
  });
}
```

**UseCases:**
```dart
// Ví dụ: SendMessageUseCase
class SendMessageUseCase {
  final ChatbotRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, ChatMessageEntity>> call(SendMessageParams params) {
    return repository.sendMessage(
      uid: params.uid,
      sessionId: params.sessionId,
      message: params.message,
      history: params.history,
    );
  }
}

class SendMessageParams {
  final String uid;
  final String sessionId;
  final String message;
  final List<ChatMessageEntity> history;

  SendMessageParams({required this.uid, required this.sessionId, required this.message, required this.history});
}
```

### 4.2. Data Layer (Repository Implementation)

**ChatbotRepositoryImpl:**
```dart
class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;

  ChatbotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String uid,
    required String sessionId,
    required String message,
    required List<ChatMessageEntity> history,
  }) async {
    try {
      // 1. Gọi Vertex AI qua DataSource
      final aiResponseText = await remoteDataSource.sendMessage(sessionId, uid, message, history);
      
      // 2. Tạo Entity cho tin nhắn AI
      final aiMessage = ChatMessageEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Hoặc dùng UUID
        content: aiResponseText,
        role: MessageRole.model,
        createdAt: DateTime.now(),
        status: MessageStatus.success,
      );
      
      // 3. (Tuỳ chọn) Gọi DataSource để lưu aiMessage vào Firestore tại đây
      // await remoteDataSource.saveMessage(uid, sessionId, aiMessage);

      return Right(aiMessage);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  // ... implement các hàm getChatSessions, createChatSession, getChatHistory
}
```

---

## 5. Kiến trúc & Cấu trúc Folder

Tương tự tiêu chuẩn Clean Architecture:
```text
features/chatbot/
├── data/
│   ├── datasources/chatbot_remote_datasource.dart (Chứa logic Vertex AI + Firestore)
│   ├── models/chat_session_model.dart, chat_message_model.dart
│   └── repositories/chatbot_repository_impl.dart
├── domain/
│   ├── entities/chat_session_entity.dart, chat_message_entity.dart
│   ├── repositories/chatbot_repository.dart
│   └── usecases/send_message_usecase.dart, get_sessions_usecase.dart...
└── presentation/
    ├── cubit/
    │   ├── chat_history_cubit.dart (Quản lý ds session)
    │   └── chatbot_cubit.dart (Quản lý 1 phiên chat cụ thể)
    ├── pages/chat_history_screen.dart, chatbot_screen.dart
    └── widgets/chat_bubble.dart, chat_input.dart...
```

---

## 6. Luồng xử lý chi tiết (User flow)

1. Mở app -> Vào tab Chat Bot -> Hiện **ChatHistoryScreen**.
2. Bấm "Tạo đoạn chat mới" -> Mở **ChatbotScreen** (truyền sessionId = null).
3. Nhập "Giải phương trình x^2 - 4 = 0" -> Bấm Gửi.
4. **ChatbotCubit**:
   - Thấy sessionId == null -> Báo `Data Layer` tạo Session mới trên Firestore.
   - Nhận được ID (VD: `sess123`), lưu tin nhắn User vào Firestore với trạng thái `sending`.
   - Hiển thị UI ngay lập tức.
5. **ChatbotRemoteDataSource**:
   - Gọi `FirebaseVertexAI` gửi câu hỏi.
   - Trả kết quả về cho Cubit.
   - Lưu tin nhắn phản hồi (role: `model`) vào Firestore.
6. **ChatbotCubit**:
   - Update UI hiển thị tin nhắn của AI.
   - Generate một câu tiêu đề ngắn (vd: "Giải pt bậc 2") -> Update Firestore `title` của session.

---

## 7. Cấu hình Firebase Console (Quan trọng)

Để sử dụng Firebase Vertex AI, cần thao tác trên Firebase Console:
1. Nâng cấp Firebase project lên gói **Blaze** (Pay-as-you-go). (Vertex AI yêu cầu gắn thẻ thanh toán, tuy nhiên có mức miễn phí khá rộng rãi).
2. Tìm menu **Vertex AI** trong thanh bên trái của Firebase Console.
3. Bấm **Enable** (Kích hoạt API).
4. Thiết lập **Firestore Rules**:
   ```javascript
   match /users/{userId}/chat_sessions/{document=**} {
     allow read, write: if request.auth != null && request.auth.uid == userId;
   }
   ```

---

## 8. Dependency Injection (get_it)

Đăng ký trong `lib/app/di/injection_container.dart`:

```dart
// Chatbot - Data
sl.registerLazySingleton<ChatbotRemoteDataSource>(
  () => ChatbotRemoteDataSourceImpl(firestore: sl()), 
  // FirebaseVertexAI.instance gọi trực tiếp, không cần DI
);
sl.registerLazySingleton<ChatbotRepository>(
  () => ChatbotRepositoryImpl(remoteDataSource: sl()),
);

// ... Đăng ký UseCases và Cubit tương tự như lịch sử thi
```

---

## 9. Lộ trình code

1. **Cấu hình**: Bật Vertex AI trên Firebase, cấp quyền Firestore, cài package `firebase_vertexai`.
2. **Domain Layer**: Code Entity (Session, Message), Repository Interface, UseCases.
3. **Data Layer**: Code Models (toFirestore, fromFirestore), Implement RemoteDataSource (tích hợp `startChat` của VertexAI).
4. **State Management**: Code `ChatHistoryCubit` và `ChatbotCubit`.
5. **Presentation**: Dựng màn hình, bong bóng chat, gán Cubit vào UI.
6. **Kiểm thử**: Test gửi tin nhắn, lưu DB, thoát ra vào lại có mất dữ liệu không, test context memory (hỏi câu 1, sau đó hỏi câu 2 tham chiếu câu 1 xem AI nhớ không).
