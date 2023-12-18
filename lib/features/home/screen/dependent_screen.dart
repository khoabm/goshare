import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/home/controller/home_controller.dart';
import 'package:goshare/features/home/widgets/dependent_widgets/broadcast_location_card.dart';
import 'package:goshare/features/home/widgets/dependent_widgets/matching_card.dart';
import 'package:goshare/features/home/widgets/dependent_widgets/trip_history_card.dart';
import 'package:goshare/features/home/widgets/dependent_widgets/trip_information_card.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/models/trip_model.dart';
import 'package:goshare/models/user_data_model.dart';
import 'package:goshare/providers/current_on_trip_provider.dart';
import 'package:goshare/providers/dependent_booking_stage_provider.dart';
import 'package:goshare/providers/dependent_trip_provider.dart';
import 'package:goshare/providers/guardian_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/dependent_widgets/greeting.dart';

class DependentHomeScreen extends ConsumerStatefulWidget {
  const DependentHomeScreen({super.key});

  @override
  ConsumerState<DependentHomeScreen> createState() =>
      _DependentHomeScreenState();
}

class _DependentHomeScreenState extends ConsumerState<DependentHomeScreen> {
  Widget navigateToTripNotificationOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.pushNamed(RouteConstants.dependentTripNotification);
    });
    return const TripInformationCardWidget(
      tripStatus: 0,
    );
  }

  late final String? tripId;
  late final TripModel? trip;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.mounted) {
        final u = await ref
            .watch(homeControllerProvider.notifier)
            .getGuardianProfile(context);
        ref.watch(guardianProfileProvider.notifier).setGuardianDataWithModel(u);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        tripId = ref.watch(currentOnTripIdProvider.notifier).currentTripId;
        print('tripId:${tripId}');
        if (tripId != null) {
          trip = await ref
              .watch(tripControllerProvider.notifier)
              .getTripInfo(context, tripId!);
          if (trip != null) {
            ref.watch(tripProvider.notifier).setTripDataWithModel(trip);
            print(ref.watch(tripProvider.notifier).tripData);
            //print(trip?.toJson());
            if (trip!.status == 0) {
              ref.watch(stageProvider.notifier).setStage(Stage.stage1);
            }
            if (trip!.status == 1) {
              ref.watch(stageProvider.notifier).setStage(Stage.stage2);
            }
            if (trip!.status == 2) {
              ref.watch(stageProvider.notifier).setStage(Stage.stage3);
            }
          }
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(color: Color(0xFF05204A)),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 41),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GreetingWidget(
                                  name: ref.watch(userProvider)?.name ??
                                      'Người dùng'),
                              const SizedBox(height: 15),
                              ref.watch(stageProvider) == Stage.stage0
                                  ? const BroadCastLocationWidget()
                                  : const SizedBox.shrink(),
                              ref.watch(stageProvider) == Stage.stage1
                                  ? const MatchingCardWidget()
                                  : const SizedBox.shrink(),
                              ref.watch(stageProvider) == Stage.stage2
                                  ? navigateToTripNotificationOverlay()
                                  : const SizedBox.shrink(),
                              ref.watch(stageProvider) == Stage.stage3
                                  ? const TripInformationCardWidget(
                                      tripStatus: 1,
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(height: 30),
                              const Divider(
                                color: Color.fromARGB(255, 201, 201, 201),
                                thickness: 0.5,
                                indent: 30,
                                endIndent: 30,
                              ),
                              const SizedBox(height: 30),
                              const TripHistoryWidget(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        backgroundColor: const Color.fromARGB(255, 60, 188, 60),
                        onPressed: () async {
                          // Add your action for the first button
                          print('First Button Pressed');
                          final guardianPhone = ref
                                  .watch(guardianProfileProvider.notifier)
                                  .guardianData
                                  ?.phone ??
                              "";
                          final call = Uri.parse(
                              'tel:${convertPhoneNumber(guardianPhone)}');
                          if (await canLaunchUrl(call)) {
                            launchUrl(call);
                          } else {
                            throw 'Could not launch $call';
                          }
                        },
                        child: const Icon(Icons.call),
                      ), // Add some spacing between the buttons
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
