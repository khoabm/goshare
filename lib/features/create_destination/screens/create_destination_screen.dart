import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/app_text_field.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/dependent_list/controllers/dependent_controller.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/models/dependent_model.dart';
import 'package:goshare/providers/user_locations_provider.dart';

class CreateDestinationScreen extends ConsumerStatefulWidget {
  final String destinationAddress;
  final double latitude;
  final double longitude;
  const CreateDestinationScreen({
    super.key,
    required this.destinationAddress,
    required this.latitude,
    required this.longitude,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateDestinationScreenState();
}

class _CreateDestinationScreenState
    extends ConsumerState<CreateDestinationScreen> {
  final locationNameTextController = TextEditingController();
  DependentModel? passenger;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Tạo điểm đến mới',
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
                    child: Text(
                      widget.destinationAddress,
                      maxLines: null,
                      softWrap: true,
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
                    'Tên gợi nhớ ',
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    // Wrap TextField with Expanded
                    child: AppTextField(
                      controller: locationNameTextController,
                      hintText: 'Đặt tên cho địa điểm,',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ref.watch(userProvider.notifier).state?.role.toLowerCase() ==
                      'dependent'
                  ? const SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tài khoản',
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: Container(
                            width: 181,
                            height: 42,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: const Color.fromARGB(255, 237, 224, 224),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.person_2_outlined,
                                      ),
                                      Text(
                                        passenger?.name ?? 'Tôi',
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            final result = await context.pushNamed(
                                RouteConstants.dependentList,
                                extra: {
                                  'isGetLocation': false,
                                });
                            if (result != null) {
                              Map<String, dynamic> resultMap =
                                  result as Map<String, dynamic>;
                              var dependentModel = resultMap['dependentModel'];
                              setState(() {
                                passenger = (dependentModel as DependentModel?);
                              });
                            }

                            print(result);
                          },
                        ),
                      ],
                    ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: AppButton(
                  buttonText: 'Tạo',
                  onPressed: () async {
                    final check = await ref
                        .watch(dependentControllerProvider.notifier)
                        .createDestination(
                          context,
                          widget.latitude,
                          widget.longitude,
                          widget.destinationAddress,
                          locationNameTextController.text,
                          passenger?.id,
                        );
                    if (check != null) {
                      if (check.id.isNotEmpty) {
                        if (check.userId ==
                            ref.watch(userProvider.notifier).state?.id) {
                          ref
                              .watch(userLocationProvider.notifier)
                              .addLocation(check);
                        }
                      }
                    }
                    if (context.mounted) {
                      context.goNamed(RouteConstants.dashBoard);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
