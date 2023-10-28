import 'package:flutter/material.dart';
import 'package:goshare/core/input_validator.dart';
import 'package:goshare/theme/pallet.dart';

class PasscodeField extends StatefulWidget {
  final String? label;
  final TextEditingController controller;
  const PasscodeField({
    super.key,
    this.label,
    required this.controller,
  });

  @override
  State<PasscodeField> createState() => _PasscodeFieldState();
}

class _PasscodeFieldState extends State<PasscodeField> {
  //final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        TextFormField(
          cursorHeight: 0,
          cursorWidth: 0,
          controller: widget.controller,
          keyboardType: TextInputType.number,
          maxLength: 6,
          obscuringCharacter: ' ',
          obscureText: true,
          style: const TextStyle(
            color: Colors.transparent,
            fontSize: 22,
          ),
          decoration: InputDecoration(
            counterText: '',
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Pallete.primaryColor),
            ),
            border: const OutlineInputBorder(),
            //border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            label: Text(widget.label ?? ''),
          ),
          focusNode: _focusNode,
          // validator: (value) => InputValidator.nullValidate(
          //   value,
          //   'Mật khẩu không được trống',
          // ),
        ),
        IgnorePointer(
          child: TextFormField(
            enabled: false,
            maxLength: 6,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              counterText: '',
              hintText: '●' * (widget.controller.text.length) +
                  '○' * (6 - widget.controller.text.length),
              hintStyle: const TextStyle(
                color: Pallete.primaryColor,
                // color:
                //     _focusNode.hasFocus ? Colors.black : Colors.grey.shade400,
                fontSize: 22,
              ),
              // enabledBorder: const OutlineInputBorder(),
              // focusedBorder: const OutlineInputBorder(),
              // border: const OutlineInputBorder(),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
