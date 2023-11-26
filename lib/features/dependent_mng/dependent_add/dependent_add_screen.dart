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
import 'package:goshare/features/dependent_mng/dependent_add/dependent_add_controller.dart';
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
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DependentAddScreenState();
}

class _DependentAddScreenState extends ConsumerState<DependentAddScreen> {
  // final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberTextController =
      TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _birthDateTextController =
      TextEditingController();
  String? _gender;

  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _phoneNumberTextController.dispose();
    _nameTextController.dispose();
  }

  void _onSubmit(WidgetRef ref) async {
    String phone = _phoneNumberTextController.text;
    String name = _nameTextController.text;
    DateTime birth =
        DateTimeFormatters.convertStringToDate(_birthDateTextController.text);

    final result = await ref
        .read(DependentAddControllerProvider.notifier)
        .dependentAdd(phone, name, _gender!, birth, context);
    // print("resultAdd" + result.toString());
    if (result) {
      context.goNamed(RouteConstants.otp, pathParameters: {
        'phone': phone,
        'isFor': RouteConstants.dependentAdd,
      });
    }
  }

  void navigateToDashBoardScreen() {
    context.goNamed(RouteConstants.dashBoard);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Thêm người phụ thuộc'),
        ),
        //resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // color: Pallete.red,
                    height: MediaQuery.of(context).size.height * .15,
                    // child: SvgPicture.asset(
                    //   Constants.carBanner,
                    //   fit: BoxFit.contain,
                    // ),
                  ),
                  HomeCenterContainer(
                    width: MediaQuery.of(context).size.width * .9,
                    child: Form(
                      // key: _loginFormKey,
                      child: Column(
                        children: [
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
                            title: 'Tên',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            controller: _nameTextController,
                            hintText: 'Nguyễn Văn A',
                            prefixIcons: const Icon(
                              Icons.abc,
                            ),
                            inputType: TextInputType.phone,
                            formatters: [
                              LengthLimitingTextInputFormatter(6),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const LeftSideText(
                            title: 'Giới tính',
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  title: const Text('Nam'),
                                  selectedColor: Pallete.primaryColor,
                                  leading: Radio<String>(
                                    value: 'Nam',
                                    groupValue: _gender,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _gender = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text('Nữ'),
                                  selectedColor: Pallete.primaryColor,
                                  leading: Radio<String>(
                                    value: 'Nữ',
                                    groupValue: _gender,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _gender = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          const LeftSideText(
                            title: 'Ngày tháng năm sinh',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AppTextField(
                            hintText: 'dd/MM/yyyy',
                            inputType: TextInputType.phone,
                            prefixIcons: const Icon(
                              Icons.calendar_today,
                            ),
                            controller: _birthDateTextController,
                            formatters: [
                              DateTextFormatter(),
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.singleLineFormatter,
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
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
