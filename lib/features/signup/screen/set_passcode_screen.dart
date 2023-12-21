import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/signup/controller/sign_up_controller.dart';
import 'package:goshare/features/signup/widgets/passcode_input.dart';

class SetPassCodeScreen extends ConsumerStatefulWidget {
  final String setToken;
  final String phone;
  final String isFor;
  const SetPassCodeScreen({
    super.key,
    required this.setToken,
    required this.phone,
    required this.isFor,
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
      print("isFor");
      print(widget.isFor);

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
        if (context.mounted) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Center(
                  child: Text(
                    'Thành công',
                  ),
                ),
                content: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Cảm ơn bạn đã sử dụng dịch vụ. Bây giờ bạn có thể đăng nhập vào hệ thống',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      GoRouter.of(context).goNamed(
                          widget.isFor == RouteConstants.dependentAdd
                              ? RouteConstants.dashBoard
                              : RouteConstants.login);
                      //context.go(RouteConstants.loginUrl);
                    },
                    child: const Text(
                      'Xác nhận',
                    ),
                  ),
                ],
              );
            },
          );
        }
      } else {
        print('Set that bai');
        if (context.mounted) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext abcContext) {
              return AlertDialog(
                title: const Center(
                  child: Text(
                    'Thất bại',
                  ),
                ),
                content: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Có lỗi xảy ra. Vui lòng kiểm tra lại mật khẩu hoặc thử lại trong giây lát',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      //abcContext.pop();
                      Navigator.of(abcContext).pop();
                      //context.go(RouteConstants.loginUrl);
                    },
                    child: const Text(
                      'Xác nhận',
                    ),
                  ),
                ],
              );
            },
          );
        }
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
