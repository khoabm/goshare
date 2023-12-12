import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/app_text_field.dart';
import 'package:goshare/core/input_formatters.dart';
import 'package:goshare/core/input_validator.dart';
import 'package:goshare/features/dependent_mng/dependent_add/dependent_add_screen.dart';
import 'package:goshare/features/home/controller/home_controller.dart';
import 'package:goshare/models/user_profile_model.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  UserProfileModel? profile;
  final _profileFormKey = GlobalKey<FormState>();

  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _phoneNumberTextController =
      TextEditingController();
  final TextEditingController _birthDateTextController =
      TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameTextController.dispose();

    _phoneNumberTextController.dispose();
    _birthDateTextController.dispose();
  }

  void getUserData() async {
    profile = await ref.watch(homeControllerProvider.notifier).getUserProfile(
          context,
        );
    if (profile != null) {
      _nameTextController.text = profile!.name;
      _phoneNumberTextController.text = profile!.phone;
      _birthDateTextController.text = profile!.birth.toString();
    }
    setState(() {});
  }

  void _onSubmit(WidgetRef ref) async {
    if (_profileFormKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: const Text('Edit Profile'),
        elevation: 0,
      ),
      body: profile != null
          ? Form(
              key: _profileFormKey,
              child: Column(
                children: [
                  const Text(
                    'Thông tin người dùng',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(profile!.avatarUrl ?? ''),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Số điện thoại không được trống';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ngày sinh không được trống';
                      }
                      return null;
                    },
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
                        buttonText: 'Cập nhật',
                        onPressed: () => _onSubmit,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
