import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatefulWidget {
  final String? textButton;
  final Function() onTap;
  const AuthButton({super.key, this.textButton, required this.onTap});

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.black87,
      backgroundColor: AppColors.primaryColor,
      minimumSize: Size(size.width, 46),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
    return ElevatedButton(
        style: buttonStyle,
        onPressed: widget.onTap,
        child: Text(
          widget.textButton ?? "Submit",
          style: TextStyles.normalText.copyWith(
            color: Colors.white,
          ),
        ));
  }
}
