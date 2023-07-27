import 'package:fin_app/constant/color.dart';
import 'package:flutter/material.dart';

class QuestionText extends StatelessWidget {
  final String questionText;
  final String answerText;
  final Function() onTap;
  const QuestionText({
    super.key,
    required this.questionText,
    required this.answerText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          questionText,
          style: const TextStyle(),
        ),
        const SizedBox(width: 4),
        GestureDetector(
            onTap: onTap,
            child: Text(
              answerText,
              style: const TextStyle(color: AppColors.primaryColor),
            ))
      ],
    );
  }
}
