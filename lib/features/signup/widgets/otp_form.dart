import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goshare/theme/pallet.dart';

class OtpInputField extends StatelessWidget {
  const OtpInputField({
    Key? key,
    required this.focusNode,
    required this.onNext,
    required this.controller,
    required this.onBackspace,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final VoidCallback onNext;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textAlign: TextAlign.center,
      enableSuggestions: false,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Pallete.primaryColor, // Customize the border color if needed
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Pallete.primaryColor, // Customize the border color if needed
          ),
        ),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        if (value.isEmpty) {
          onBackspace();
        } else if (value.length == 1) {
          onNext();
        }
      },
    );
  }
}

class OtpForm extends StatefulWidget {
  final void Function(String otpValue) onFinish;
  final VoidCallback onChange;
  const OtpForm({
    Key? key,
    required this.onFinish,
    required this.onChange,
  }) : super(key: key);

  @override
  OtpFormState createState() => OtpFormState();
}

class OtpFormState extends State<OtpForm> {
  late List<FocusNode> focusNodes;
  late List<TextEditingController> _controllers;
  void _onFieldChanged() {
    widget.onChange();
  }

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(6, (index) => FocusNode());
    _controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSubmit() {
    final List<String> otpValues =
        _controllers.map((controller) => controller.text).toList();
    final String otpValue = otpValues.join();
    widget.onFinish(otpValue);
  }

  void _onBackspace(int currentIndex) {
    if (currentIndex > 0) {
      // Move focus to the previous input
      focusNodes[currentIndex - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Form(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (index) {
              return SizedBox(
                height: 48,
                width: 44,
                child: OtpInputField(
                  controller: _controllers[index],
                  focusNode: focusNodes[index],
                  onNext: index < 5
                      ? () => focusNodes[index + 1].requestFocus()
                      : _onSubmit,
                  onBackspace: () => _onBackspace(index),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
