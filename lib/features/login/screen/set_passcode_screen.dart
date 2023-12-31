import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/features/signup/controller/sign_up_controller.dart';
import 'package:goshare/features/signup/widgets/passcode_input.dart';

class SetPassCodeScreen extends ConsumerStatefulWidget {
  final String setToken;
  final String phone;
  const SetPassCodeScreen({
    super.key,
    required this.setToken,
    required this.phone,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetPassCodeScreenState();
}

class _SetPassCodeScreenState extends ConsumerState<SetPassCodeScreen> {
  final _passCodeTextController = TextEditingController();
  final _rePassCodeTextController = TextEditingController();
  final _passCodeFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void dispose() {
    _passCodeTextController.dispose();
    _rePassCodeTextController.dispose();
    super.dispose();
  }

  void _onSubmit(WidgetRef ref) async {
    if (_passCodeFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      print(
          '${_passCodeTextController.text} ${_rePassCodeTextController.text}');
      final passcode = _passCodeTextController.text;
      final phone = widget.phone;
      final setToken = widget.setToken;

      final result =
          await ref.read(signUpControllerProvider.notifier).setPasscode(
                phone,
                setToken,
                passcode,
                context,
              );
      setState(() {
        _isLoading = false;
      });
      if (result) {
        print('Set thanh cong');
      } else {
        print('Set that bai');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: HomeCenterContainer(
                  verticalPadding: 30,
                  horizontalPadding: 30,
                  child: Form(
                    key: _passCodeFormKey,
                    child: Column(
                      children: [
                        //Text('${widget.setToken} ${widget.phone}'),

                        const Text(
                          'Tạo mật khẩu',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Mật khẩu',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        PasscodeField(
                          controller: _passCodeTextController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Nhập lại mật khẩu',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        PasscodeField(
                          controller: _rePassCodeTextController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(
                            8.0,
                          ),
                          width: MediaQuery.of(context).size.width * .95,
                          child: ElevatedButton(
                            onPressed: () => _onSubmit(ref),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Xác nhận',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Loader(),
          ),
      ],
    );
  }
}
