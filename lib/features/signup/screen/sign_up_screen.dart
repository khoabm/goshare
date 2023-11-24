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
import 'package:goshare/features/signup/controller/sign_up_controller.dart';
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

  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _nameTextController.dispose();
    _passwordTextController.dispose();
    _phoneNumberTextController.dispose();
    _birthDateTextController.dispose();
  }

  void _onSubmit(WidgetRef ref) async {
    if (_signUpFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String name = _nameTextController.text;
      String phone = _phoneNumberTextController.text;
      DateTime birth =
          DateTimeFormatters.convertStringToDate(_birthDateTextController.text);
      int gender = 1;

      final result =
          await ref.read(signUpControllerProvider.notifier).registerUser(
                name,
                phone,
                gender,
                birth,
                context,
              );
      setState(() {
        _isLoading = false;
      });
      if (result) {
        navigateToOtpScreen(phone);
      } else {}
    }
  }

  void navigateToOtpScreen(String phone) {
    context.goNamed(RouteConstants.otp, pathParameters: {
      'phone': phone,
    });
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
                            validator: (value) => InputValidator.nullValidate(
                              value,
                              'Tên không được trống',
                            ),
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
                            title: 'Ngày sinh',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            hintText: 'dd/MM/yyyy',
                            prefixIcons: const Icon(Icons.calendar_today),
                            inputType: TextInputType.phone,
                            controller: _birthDateTextController,
                            formatters: [
                              DateTextFormatter(),
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.singleLineFormatter,
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            width: MediaQuery.of(context).size.width * .9,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              child: AppButton(
                                buttonText: 'Đăng ký',
                                onPressed: () => _onSubmit(ref),
                              ),
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
