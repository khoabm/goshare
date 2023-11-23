import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the stages
enum Stage { stage0, stage1, stage2, stage3 }

// Create a StateNotifier
class StageNotifier extends StateNotifier<Stage> {
  StageNotifier(Stage initialStage) : super(initialStage);

  void setStage(Stage newStage) {
    state = newStage;
  }
}

// Create a provider
final stageProvider = StateNotifierProvider<StageNotifier, Stage>(
  (ref) => StageNotifier(Stage.stage0),
);
