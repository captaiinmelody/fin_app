import 'package:fin_app/constant/color.dart';
import 'package:fin_app/constant/text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String? textButton;
  final ButtonStyle? buttonStyle;
  final TextStyle? textStyle;
  final double? width;
  final Function() onTap;
  const CustomButton({
    super.key,
    this.textButton,
    this.buttonStyle,
    this.textStyle,
    this.width,
    required this.onTap,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(widget.width ?? size.width, 46),
        textStyle: widget.textStyle ??
            TextStyles.normalText.copyWith(color: Colors.white),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))));
    return ElevatedButton(
        onPressed: widget.onTap,
        style: widget.buttonStyle ?? buttonStyle,
        child: Text(widget.textButton ?? "Submit",
            style: widget.textStyle ??
                TextStyles.normalText.copyWith(color: Colors.white)));
  }
}
