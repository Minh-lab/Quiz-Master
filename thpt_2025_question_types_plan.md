# 🎓 Kế Hoạch Nâng Cấp Hệ Thống Câu Hỏi Theo Chuẩn THPT 2025 (3 Phần)

> **Dự án:** Quiz Master | **Feature:** Cấu trúc đề thi THPT Quốc Gia 2025 mới nhất.
> **Mục tiêu:** Hỗ trợ đầy đủ 3 dạng câu hỏi (Trắc nghiệm nhiều lựa chọn, Đúng/Sai, Trả lời ngắn) một cách linh hoạt ở cả Database, Models, BLoC, và UI.

---

## 1. Phân Tích Cấu Trúc Đề Thi THPT 2025 Mới Nhất

Theo hướng dẫn của Bộ Giáo dục và Đào tạo, một đề thi chuẩn bao gồm **22 câu hỏi** chia làm 3 phần chính với cách tính điểm và giao diện riêng biệt:

| Phần | Loại câu hỏi | Số lượng | Mô tả đáp án & Lựa chọn | Cách tính điểm chuẩn 2025 |
| :--- | :--- | :--- | :--- | :--- |
| **PHẦN I** | Trắc nghiệm 4 lựa chọn | **12 câu** (Câu 1 - 12) | Chọn **1** trong **4** phương án (A, B, C, D) | Đúng mỗi câu được **0.25 điểm** |
| **PHẦN II** | Trắc nghiệm Đúng / Sai | **4 câu** (Câu 13 - 16) | Mỗi câu hỏi có **4 ý độc lập (a, b, c, d)**. Với mỗi ý, thí sinh chọn Đúng hoặc Sai. | Đúng 1 ý: **0.1đ**<br>Đúng 2 ý: **0.25đ**<br>Đúng 3 ý: **0.5đ**<br>Đúng 4 ý: **1.0đ** |
| **PHẦN III** | Trắc nghiệm Trả lời ngắn | **6 câu** (Câu 17 - 22) | Thí sinh tự nhập câu trả lời ngắn (chữ số, dấu âm, hoặc dấu phẩy thập phân). | Đúng mỗi câu được **0.25 điểm** (hoặc 0.5 điểm tùy môn) |

---

## 2. Tái Thiết Kế Database Firestore (`questions`)

Để hỗ trợ cả 3 loại câu hỏi, chúng ta cần bổ sung thêm trường `type` để phân loại và linh hoạt hoá cấu trúc `options` cùng `correct_answer`.

```typescript
enum QuestionType {
  multipleChoice = 'multiple_choice',  // Phần I
  trueFalse = 'true_false',            // Phần II
  shortAnswer = 'short_answer'         // Phần III
}
```

### 2.1. Cấu Trúc Câu Hỏi Phần I (Multiple Choice)
```json
{
  "id": "q_01",
  "order": 1,
  "type": "multiple_choice",
  "content": "Tính đạo hàm của hàm số $y = x^2$.",
  "options": ["2x", "x", "2", "x^2"],
  "correct_answer": 0, // Lưu index (0 tương ứng A)
  "score": 0.25
}
```

### 2.2. Cấu Trúc Câu Hỏi Phần II (True / False)
`options` sẽ chứa 4 ý hỏi con (a, b, c, d) và `correct_answer` sẽ là một Map/Object chứa đáp án Đúng (true) hoặc Sai (false) cho từng ý.
```json
{
  "id": "q_13",
  "order": 13,
  "type": "true_false",
  "content": "Cho hàm số $y = x^3 - 3x$. Khảo sát các mệnh đề sau:",
  "options": [
    "a) Hàm số đồng biến trên khoảng $(1; +\\infty)$",
    "b) Hàm số nghịch biến trên khoảng $(-1; 1)$",
    "c) Đồ thị hàm số có điểm cực đại là $(1; -2)$",
    "d) Đường thẳng $y = 2$ cắt đồ thị hàm số tại 3 điểm phân biệt"
  ],
  "correct_answer": {
    "a": true,
    "b": true,
    "c": false,
    "d": false
  },
  "score": 1.0 // Tổng điểm tối đa nếu đúng cả 4 ý
}
```

### 2.3. Cấu Trúc Câu Hỏi Phần III (Short Answer)
Không cần trường `options`, `correct_answer` là một chuỗi văn bản/chữ số chính xác.
```json
{
  "id": "q_17",
  "order": 17,
  "type": "short_answer",
  "content": "Tìm giá trị cực đại của hàm số $y = -x^2 + 4x + 1$.",
  "options": [],
  "correct_answer": "5", // Đáp án đúng dạng chuỗi
  "score": 0.25
}
```

---

## 3. Cập Nhật Domain Layer (Entity & Models)

### 3.1. Cập Nhật `QuestionEntity` (`question.dart`)
Chúng ta điều chỉnh kiểu dữ liệu của `correctAnswer` thành `dynamic` để lưu được cả `int`, `Map<String, bool>` và `String`.

```dart
class QuestionEntity extends Equatable {
  final String id;
  final int order;
  final String type; // 'multiple_choice', 'true_false', 'short_answer'
  final String content;
  final String? imageUrl;
  final List<String> options;
  final dynamic correctAnswer; // int, Map<String, bool>, hoặc String
  final double score;
  final String? explanation;

  const QuestionEntity({
    required this.id,
    required this.order,
    required this.type,
    required this.content,
    this.imageUrl,
    required this.options,
    required this.correctAnswer,
    required this.score,
    this.explanation,
  });

  @override
  List<Object?> get props => [id, order, type, content, options, correctAnswer];
}
```

---

## 4. Tái Cấu Trúc State Quản Lý Đáp Án Của Học Sinh

Hiện tại, `selectedAnswers` trong `ExamDetailState` được định nghĩa là `Map<int, int?>` (chỉ lưu được index đáp án chọn duy nhất). 

Chúng ta cần đổi nó thành **`Map<int, dynamic>`** để lưu trữ các dạng câu trả lời khác nhau:
- **Phần I (Multiple Choice):** `int` (ví dụ: `0` cho câu A)
- **Phần II (True / False):** `Map<String, bool?>` (ví dụ: `{'a': true, 'b': false, 'c': null, 'd': true}`)
- **Phần III (Short Answer):** `String` (ví dụ: `"5"`)

```dart
// Trong exam_detail_state.dart
class ExamDetailLoaded extends ExamDetailState {
  final List<QuestionEntity> questions;
  final int currentIndex;
  final Map<int, dynamic> selectedAnswers; // 🌟 Nâng cấp thành dynamic

  ExamDetailLoaded({
    required this.questions,
    this.currentIndex = 0,
    this.selectedAnswers = const {},
  });
}
```

---

## 5. Phát Triển Giao Diện (UI) Động Cho Từng Loại Câu Hỏi

Trong `_buildQuestionCard` của `exam_detail_screen.dart`, chúng ta sẽ sử dụng câu lệnh `switch-case` hoặc `if-else` dựa vào `question.type` để quyết định hiển thị widget đáp án phù hợp.

```dart
Widget _buildAnswerSection(QuestionEntity question, dynamic userAnswer) {
  switch (question.type) {
    case 'multiple_choice':
      return _buildMultipleChoiceAnswers(question, userAnswer);
    case 'true_false':
      return _buildTrueFalseAnswers(question, userAnswer);
    case 'short_answer':
      return _buildShortAnswerInput(question, userAnswer);
    default:
      return const SizedBox();
  }
}
```

### 5.1. UI Phần I: Trắc nghiệm 4 lựa chọn (Giữ nguyên UI hiện có)
Sử dụng `List.generate` để sinh ra các đáp án từ A, B, C, D.

### 5.2. UI Phần II: Trắc nghiệm Đúng / Sai (Mới ✨)
Chúng ta sẽ vẽ một bảng gồm 4 hàng (tương ứng với 4 ý a, b, c, d). Với mỗi hàng, người dùng có 2 nút tròn: **Đúng** (màu xanh lá) và **Sai** (màu đỏ).

```dart
Widget _buildTrueFalseAnswers(QuestionEntity question, dynamic userAnswer) {
  // userAnswer có kiểu dữ liệu là Map<String, bool?>
  final answers = userAnswer as Map<String, bool?>? ?? {};
  final keys = ['a', 'b', 'c', 'd'];

  return Column(
    children: List.generate(4, (index) {
      final key = keys[index];
      final optionText = question.options[index];
      final currentSelection = answers[key];

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(optionText, style: AppTypography.bodyLarge()),
            ),
            const SizedBox(width: 8),
            // Nút "Đúng"
            _buildTrueFalseButton(
              label: 'Đúng',
              isSelected: currentSelection == true,
              color: AppColors.success,
              onTap: () => _updateTrueFalseAnswer(question.order, key, true),
            ),
            const SizedBox(width: 8),
            // Nút "Sai"
            _buildTrueFalseButton(
              label: 'Sai',
              isSelected: currentSelection == false,
              color: AppColors.error,
              onTap: () => _updateTrueFalseAnswer(question.order, key, false),
            ),
          ],
        ),
      );
    }),
  );
}
```

### 5.3. UI Phần III: Trắc nghiệm trả lời ngắn (Mới ✨)
Hiển thị một hộp thoại nhập dữ liệu (TextField) để thí sinh điền câu trả lời ngắn bằng chữ số.

```dart
Widget _buildShortAnswerInput(QuestionEntity question, dynamic userAnswer) {
  final textController = TextEditingController(text: userAnswer as String? ?? '');

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Nhập đáp án của bạn:', style: AppTypography.headlineSmall()),
      const SizedBox(height: 12),
      TextField(
        controller: textController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        decoration: InputDecoration(
          hintText: 'Nhập câu trả lời là số...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: AppColors.surfaceVariant,
        ),
        onChanged: (value) {
          // Gửi event lưu đáp án dạng chữ vào Bloc
          context.read<ExamDetailBloc>().add(
            SelectAnswerEvent(questionIndex: question.order, answerIndex: value), // answerIndex sẽ nhận dynamic value
          );
        },
      ),
    ],
  );
}
```

---

## 6. Thuật Toán Tính Điểm Chuẩn Kỳ Thi THPT 2025

Thuật toán tính điểm nộp bài trong `ExamDetailBloc` cần được viết lại để tuân thủ 100% cách tính điểm đặc biệt của Bộ Giáo dục:

```dart
double calculateTotalScore(List<QuestionEntity> questions, Map<int, dynamic> selectedAnswers) {
  double totalScore = 0.0;

  for (var question in questions) {
    final userAnswer = selectedAnswers[question.order];
    if (userAnswer == null) continue;

    if (question.type == 'multiple_choice') {
      // PHẦN I: Đúng mỗi câu được 0.25 điểm
      if (userAnswer is int && userAnswer == question.correctAnswer) {
        totalScore += 0.25;
      }
    } 
    else if (question.type == 'true_false') {
      // PHẦN II: Tính điểm luỹ tiến cho 4 ý Đúng/Sai
      final correctMap = question.correctAnswer as Map<String, dynamic>;
      final userMap = userAnswer as Map<String, dynamic>;

      int correctCount = 0;
      final keys = ['a', 'b', 'c', 'd'];
      for (var key in keys) {
        if (userMap[key] != null && userMap[key] == correctMap[key]) {
          correctCount++;
        }
      }

      // Quy tắc tính điểm Đúng/Sai chuẩn 2025
      if (correctCount == 1) totalScore += 0.1;
      else if (correctCount == 2) totalScore += 0.25;
      else if (correctCount == 3) totalScore += 0.5;
      else if (correctCount == 4) totalScore += 1.0;
    } 
    else if (question.type == 'short_answer') {
      // PHẦN III: Trả lời ngắn, so khớp chuỗi (đã chuẩn hoá chữ số thập phân)
      final correctStr = question.correctAnswer.toString().trim().replaceAll(',', '.');
      final userStr = userAnswer.toString().trim().replaceAll(',', '.');

      if (userStr.isNotEmpty && userStr == correctStr) {
        totalScore += 0.25; // Tuỳ môn học có thể là 0.25 hoặc 0.5 điểm
      }
    }
  }

  return double.parse(totalScore.toStringAsFixed(2));
}
```

---

## 7. Kế Hoạch Triển Khai Từng Bước (Roadmap)

- [ ] **Bước 1 (Database):** Cập nhật dữ liệu test của 1 đề thi trên Firestore bao gồm 12 câu Phần I, 4 câu Phần II và 6 câu Phần III đúng cấu trúc trường `type` và `correct_answer`.
- [ ] **Bước 2 (Domain/Models):** Nâng cấp thuộc tính `correctAnswer` của `QuestionEntity` và `QuestionModel` sang kiểu dữ liệu `dynamic`.
- [ ] **Bước 3 (BLoC State):** Đổi kiểu dữ liệu `selectedAnswers` của `ExamDetailLoaded` từ `Map<int, int?>` sang `Map<int, dynamic>`.
- [ ] **Bước 4 (BLoC Logic):** Thêm Event `UpdateTrueFalseAnswerEvent` (để update từng ý a, b, c, d của câu Đúng/Sai) và cập nhật hàm tính điểm `calculateTotalScore`.
- [ ] **Bước 5 (UI Multiple Choice):** Giữ nguyên UI trắc nghiệm cũ.
- [ ] **Bước 6 (UI True / False):** Thiết kế widget bảng lựa chọn Đúng / Sai cho 4 ý hỏi.
- [ ] **Bước 7 (UI Short Answer):** Tạo Widget TextField cho phép nhập số âm, số thập phân cho phần trả lời ngắn.
- [ ] **Bước 8 (Testing):** Chạy thử nghiệm giả lập thí sinh làm bài thi 22 câu với đầy đủ 3 định dạng và đối chiếu điểm số với cách tính của Bộ Giáo dục.

---

> [!NOTE]
> Bằng cách áp dụng kiến trúc đề thi THPT 2025 hoàn chỉnh này, ứng dụng Quiz Master của bạn sẽ đạt được độ **chân thực và chuyên nghiệp tối đa**, tạo ra lợi thế cạnh tranh vô cùng lớn đối với các app học tập khác trên thị trường!
