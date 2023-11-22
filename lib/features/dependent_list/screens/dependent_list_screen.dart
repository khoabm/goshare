import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:goshare/common/loader.dart';
import 'package:goshare/features/dependent_list/controllers/dependent_controller.dart';
import 'package:goshare/features/dependent_list/widgets/dependent_card.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/models/dependent_model.dart';

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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list == null
          ? const Loader()
          : Stack(
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
                            itemCount: list?.items.length,
                            itemBuilder: (context, index) => DependentCard(
                                dependentModel: list?.items[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Loading indicator
                // ValueListenableBuilder<bool>(
                //   valueListenable: isLoading,
                //   builder: (context, isLoading, child) {
                //     if (isLoading) {
                //       return Container(
                //         color:
                //             Colors.black.withOpacity(0.5), // Opacity background
                //         child: const Center(
                //           child:
                //               CircularProgressIndicator(), // Loading indicator
                //         ),
                //       );
                //     } else {
                //       return const SizedBox
                //           .shrink(); // Empty widget when not loading
                //     }
                //   },
                // ),
              ],
            ),
    );
  }
}
