import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class RoundTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String hitText;
  final Widget icon;
  final bool readOnly;
  final int maxLines;
  final Widget? rigtIcon;
  final bool obscureText;
  final EdgeInsets? margin;

  const RoundTextField({
    super.key,
    required this.hitText,
    required this.icon,
    this.controller,
    this.margin,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.obscureText = false,
    this.rigtIcon,
  });

  @override
  _RoundTextFieldState createState() => _RoundTextFieldState();
}

class _RoundTextFieldState extends State<RoundTextField> {
  final _textFieldKey = GlobalKey();
  double _prefixIconHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePrefixIconHeight();
    });
  }

  void _updatePrefixIconHeight() {
    final RenderBox? textFieldBox =
        _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (textFieldBox != null) {
      setState(() {
        _prefixIconHeight = textFieldBox.size.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        key: _textFieldKey,
        maxLines: widget.maxLines,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        readOnly: widget.readOnly,
        onChanged: (_) => _updatePrefixIconHeight(),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: widget.hitText,
          border: const OutlineInputBorder(),
          labelText: widget.hitText,
          suffixIcon: widget.rigtIcon,
          prefixIcon: Container(
            width: 50,
            height: _prefixIconHeight,
            margin: const EdgeInsets.only(right: 3),
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromARGB(255, 182, 208, 229),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
            ),
            child: widget.icon,
          ),
          hintStyle: TextStyle(color: TColor.gray, fontSize: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            // Validate if the value is empty
            return 'This field is required';
          }
          return null; // Return null if validation passes
        },
      ),
    );
  }
}
