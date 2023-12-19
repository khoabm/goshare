import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:goshare/common/loader.dart';
// import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/dependent_list/controllers/dependent_controller.dart';
import 'package:goshare/features/dependent_list/widgets/dependent_card.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/models/dependent_model.dart';
import 'package:goshare/theme/pallet.dart';

class DependentList extends ConsumerStatefulWidget {
  final bool isGetLocation;
  const DependentList({
    super.key,
    this.isGetLocation = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DependentListState();
}

class _DependentListState extends ConsumerState<DependentList> {
  DependentListResponseModel? list;
  late DependentModel nonAppDependentModel;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  @override
  void initState() {
    if (!mounted) return;
    initialize();
    super.initState();
  }

  void initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      list =
          await ref.watch(dependentControllerProvider.notifier).getDependents(
                context,
                '',
                1,
                100,
              );
      final user = ref.watch(userProvider.notifier).state;
      list?.items.add(
        DependentModel(
          id: user?.id ?? '',
          name: 'Tôi',
          phone: user?.phone ?? '',
          status: 0,
          gender: 1,
        ),
      );
      nonAppDependentModel = DependentModel(
        id: 'NonAppUser',
        name: 'Non App User',
        phone: '0987654321',
        status: 0,
        gender: 1,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list == null
          ? const Loader()
          : ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, isLoadingValue, child) {
                return Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).viewInsets.top + 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.pop();
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 60,
                            ),
                            const Text(
                              'Danh sách người quen',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height * .85,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              50,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Danh sách các người mà bạn có liên hệ',
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12.0,
                                ),
                                itemCount: (list?.items.length ?? 0) +
                                    1, // Increase the itemCount by 1
                                itemBuilder: (context, index) {
                                  // Check if this is the last item
                                  if (index == 0) {
                                    // Return your InkWell wrapped custom card here
                                    return InkWell(
                                      onTap: () {
                                        if (context.mounted) {
                                          context.pop({
                                            'dependentModel':
                                                nonAppDependentModel,
                                            'dependentLocationData': null,
                                          });
                                        }
                                      },
                                      child: Card(
                                        color: const Color(0xFFD9D9D9),
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Column(
                                                children: [
                                                  Text('Chọn điểm đón'),
                                                  Text(
                                                    'Chọn điểm đón',
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (context.mounted) {
                                                  context.pop({
                                                    'dependentModel':
                                                        nonAppDependentModel,
                                                    'dependentLocationData':
                                                        null,
                                                  });
                                                }
                                                // context.goNamed(
                                                //   RouteConstants
                                                //       .nonAppUserProfileForTrip,
                                                //   extra: {},
                                                // );
                                              },
                                              splashColor: Colors.white,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                height: 60,
                                                width:
                                                    60, // Adjust the height as needed
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
                                      ),
                                    );
                                  } else {
                                    return DependentCard(
                                      dependentModel: list?.items[index - 1],
                                      isGetLocation: widget.isGetLocation,
                                      isLoading: isLoading,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isLoadingValue)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                );
              }),
    );
  }
}
