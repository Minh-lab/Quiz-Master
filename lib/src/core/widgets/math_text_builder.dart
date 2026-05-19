import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class MathTextBuilder extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const MathTextBuilder({
    Key? key, 
    required this.text, 
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cắt chuỗi theo cấu trúc gác cổng $
    final parts = text.split('\$');
    
    List<InlineSpan> spans = [];
    
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      
      if (i % 2 == 0) {
        spans.add(TextSpan(
          text: parts[i], 
          style: style,
        ));
      } else {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle, // Căn trục dọc công thức nằm chính giữa dòng chữ
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2), // Tạo khoảng cách nhỏ hai bên công thức
              child: Math.tex(
                parts[i].replaceAll(r'\\', r'\'), // Dọn dẹp lỗi nhân đôi dấu gạch chéo của Firestore nếu có
                textStyle: style?.copyWith(
                  fontSize: (style?.fontSize ?? 14) + 1, // Tăng nhẹ 1px cho ký tự toán dễ đọc hơn
                ),
                mathStyle: MathStyle.text,
              ),
            ),
          ),
        );
      }
    }

    // Trả về Text.rich để tối ưu hóa hiệu năng render và ngắt dòng tự nhiên
    return Text.rich(
      TextSpan(children: spans),
      style: style,
    );
  }
}