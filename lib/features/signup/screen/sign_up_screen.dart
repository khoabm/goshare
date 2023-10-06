import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/app_text_field.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/theme/pallet.dart';

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

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _phoneNumberTextController =
      TextEditingController();
  final TextEditingController _birthDateTextController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameTextController.dispose();
    _passwordTextController.dispose();
    _phoneNumberTextController.dispose();
    _birthDateTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
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
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      const Text(
                        'Đăng ký',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const LeftSideText(
                        title: 'Họ và tên',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextField(
                        prefixIcons: const Icon(Icons.abc),
                        controller: _nameTextController,
                        hintText: 'Nhập tên của bạn',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const LeftSideText(
                        title: 'Mật khẩu',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextField(
                        prefixIcons: const Icon(Icons.key),
                        controller: _passwordTextController,
                        hintText: 'Nhập mật khẩu',
                        isObscure: true,
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
                        inputType: TextInputType.number,
                        maxLength: 10,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const LeftSideText(
                        title: 'Ngày sinh',
                      ),
                      SizedBox(
                        height: 200,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime(1999, 1, 1),
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(
                              () {
                                _birthDateTextController.text =
                                    newDateTime.toString();
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: const EdgeInsets.all(
                          8.0,
                        ),
                        width: MediaQuery.of(context).size.width * .9,
                        child: AppButton(
                          buttonText: 'Sign up',
                          onPressed: () {},
                        ),
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
      ),
    );
  }
}
