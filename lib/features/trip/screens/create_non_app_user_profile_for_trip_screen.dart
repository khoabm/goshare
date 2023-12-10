import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/app_text_field.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/dependent_mng/dependent_add/dependent_add_screen.dart';
import 'package:goshare/models/dependent_model.dart';
import 'package:goshare/models/non_app_user_pick_up_location_model.dart';

class CreateNonAppUserProfileForTripScreen extends ConsumerStatefulWidget {
  final String endLatitude;
  final String endLongitude;
  final int paymentMethod;
  final int capacity;
  //final String bookerId;
  final String carTypeId;
  final String driverNote;

  const CreateNonAppUserProfileForTripScreen({
    super.key,
    required this.endLatitude,
    required this.endLongitude,
    required this.paymentMethod,
    required this.capacity,
    required this.carTypeId,
    required this.driverNote,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNonAppUserProfileForTripScreenState();
}

class _CreateNonAppUserProfileForTripScreenState
    extends ConsumerState<CreateNonAppUserProfileForTripScreen> {
  final userNameTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  NonAppUserPickUpLocation? nonAppUserPickUpLocation;
  DependentModel? passenger;
  final _formKey = GlobalKey<FormState>();
  void navigateToNonAppUserPickUpLocationScreen() {
    context.pushNamed(RouteConstants.searchNonAppUserPickUpLocation);
  }

  void navigateToRouteConfirmScreen(
    BuildContext context,
    String startLatitude,
    String startLongitude,
    String endLatitude,
    String endLongitude,
    int paymentMethod,
    String bookerId,
    String carTypeId,
    String? driverNote,
    int capacity,
  ) {
    context.replaceNamed(RouteConstants.routeConfirm, extra: {
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'paymentMethod': paymentMethod.toString(),
      'bookerId': bookerId,
      'carTypeId': carTypeId,
      'driverNote': driverNote,
      'capacity': capacity,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: HomeCenterContainer(
        verticalPadding: 15,
        horizontalPadding: 15,
        height: MediaQuery.of(context).size.height * .6,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Điền thông tin người đi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Địa chỉ',
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final result = await context.pushNamed(
                            RouteConstants.searchNonAppUserPickUpLocation,
                          );
                          setState(() {
                            nonAppUserPickUpLocation =
                                result as NonAppUserPickUpLocation?;
                          });
                        },
                        child: Text(
                          nonAppUserPickUpLocation?.address ??
                              'Bấm vào đây để chọn điểm đón',
                          maxLines: null,
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tên người đi (* Bắt buộc)',
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      // Wrap TextField with Expanded
                      child: AppTextField(
                        controller: userNameTextController,
                        hintText: 'Tên người đi',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên người đi';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Số điện thoại',
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      // Wrap TextField with Expanded
                      child: AppTextField(
                        controller: phoneTextController,
                        hintText: '0987654321',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  child: AppButton(
                    buttonText: 'Xác nhận',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                      navigateToRouteConfirmScreen(
                        context,
                        nonAppUserPickUpLocation!.latitude.toString(),
                        nonAppUserPickUpLocation!.longitude.toString(),
                        widget.endLatitude,
                        widget.endLongitude,
                        widget.paymentMethod,
                        ref.watch(userProvider.notifier).state!.id,
                        widget.carTypeId,
                        widget.driverNote,
                        widget.capacity,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
