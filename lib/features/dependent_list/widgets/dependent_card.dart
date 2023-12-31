import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/features/dependent_list/controllers/dependent_controller.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/models/dependent_location_model.dart';

import 'package:goshare/models/dependent_model.dart';
import 'package:goshare/theme/pallet.dart';

class DependentCard extends ConsumerWidget {
  final DependentModel? dependentModel;
  final bool isGetLocation;
  final ValueNotifier<bool> isLoading;
  DependentCard({
    Key? key,
    this.dependentModel,
    this.isGetLocation = false,
    ValueNotifier<bool>? isLoading,
  })  : isLoading = isLoading ?? ValueNotifier<bool>(false),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: const Color(0xFFD9D9D9),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  dependentModel?.name ?? '',
                ),
                Text(
                  'Số điện thoại: ${dependentModel?.phone}',
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              DependentLocationModel? dependentLocationData;
              bool isGetForMySelf = true;
              if (isGetLocation) {
                if (dependentModel?.id !=
                    ref.watch(userProvider.notifier).state?.id) {
                  isLoading.value = true;
                  isGetForMySelf = false;
                  dependentLocationData = await ref
                      .watch(dependentControllerProvider.notifier)
                      .getDependentsLocation(
                        context,
                        dependentModel?.id ?? '',
                      );

                  isLoading.value = true;
                }
              }

              if (context.mounted) {
                context.pop({
                  'dependentModel':
                      (dependentLocationData == null && isGetForMySelf == false)
                          ? null
                          : dependentModel,
                  'dependentLocationData': dependentLocationData
                });
              }
            },
            splashColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              height: 60,
              width: 60, // Adjust the height as needed
              decoration: const BoxDecoration(
                color: Pallete.primaryColor,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
