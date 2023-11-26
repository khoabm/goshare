import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/app_text_field.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/date_time_formatters.dart';
import 'package:goshare/core/input_formatters.dart';
import 'package:goshare/core/input_validator.dart';
import 'package:goshare/features/login/controller/log_in_controller.dart';
import 'package:goshare/features/login/repository/log_in_repository.dart';

import 'package:goshare/theme/pallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

final accessTokenProvider = StateProvider<String?>((ref) => null);
final userProvider = StateProvider<User?>((ref) => null);

class User {
  String id;
  String phone;
  String name;
  String role;

  User({
    required this.id,
    required this.phone,
    required this.name,
    required this.role,
  });
}

final tabProvider = StateProvider<int>(
  (ref) => 0,
);

class LeftSideText extends StatelessWidget {
  final String title;
  const LeftSideText({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 3.0,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Pallete.primaryColor,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

class DependentAddScreen extends ConsumerStatefulWidget {
  const DependentAddScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DependentAddScreenState();
}

class _DependentAddScreenState extends ConsumerState<DependentAddScreen> {
  // final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberTextController =
      TextEditingController();
  final TextEditingController _passcodeTextController = TextEditingController();

  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _phoneNumberTextController.dispose();
    _passcodeTextController.dispose();
  }

  void _onSubmit(WidgetRef ref) async {
    // if (_loginFormKey.currentState!.validate()) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   String phone = _phoneNumberTextController.text;
    //   String passcode = _passcodeTextController.text;

    //   final result = await ref
    //       .read(LoginControllerProvider.notifier)
    //       .login(phone, passcode, context);

    //   setState(() {
    //     _isLoading = false;
    //   });

    //   if (result.error != null) {
    //     print('Error: ${result.error}');
    //   } else {
    //     final SharedPreferences prefs = await SharedPreferences.getInstance();
    //     prefs.setString('accessToken', result.accessToken!);
    //     prefs.setString('refreshToken', result.refreshToken!);
    //     ref.read(userProvider.notifier).state = result.user;
    //     navigateToDashBoardScreen();
    //   }
    // }
  }

  void navigateToDashBoardScreen() {
    context.goNamed(RouteConstants.dashBoard);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                      8.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .3,
                    child: SvgPicture.asset(
                      Constants.carBanner,
                      fit: BoxFit.fill,
                    ),
                  ),
                  HomeCenterContainer(
                    width: MediaQuery.of(context).size.width * .9,
                    child: Form(
                      // key: _loginFormKey,
                      child: Column(
                        children: [
                          const Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const LeftSideText(
                            title: 'Số điện thoại',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            prefixIcons: const Icon(Icons.phone),
                            controller: _phoneNumberTextController,
                            hintText: '0987654321',
                            inputType: TextInputType.phone,
                            formatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const LeftSideText(
                            title: 'Mật khẩu 6 số',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            controller: _passcodeTextController,
                            hintText: '123456',
                            prefixIcons: const Icon(
                              Icons.password,
                            ),
                            isObscure: true,
                            inputType: TextInputType.phone,
                            formatters: [
                              LengthLimitingTextInputFormatter(6),
                            ],
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        context.pushNamed(
                                          RouteConstants.signupUrl,
                                        );
                                      },
                                      child: const Text('Chưa có tài khoản?'),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text('Quên mật khẩu?'),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(
                                  8.0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: AppButton(
                                    buttonText: 'Thêm người ',
                                    onPressed: () => _onSubmit(ref),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Loader(),
              ),
          ],
        ),
      ),
    );
  }
}
