import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/utils/utils.dart';
import 'package:goshare/features/feedback/feedback_repository.dart';

import 'package:goshare/features/login/repository/log_in_repository.dart';

final FeedbackControllerProvider =
    StateNotifierProvider<FeedbackController, bool>(
  (ref) => FeedbackController(
    feedbackRepository: ref.watch(feedbackRepositoryProvider),
  ),
);

class FeedbackController extends StateNotifier<bool> {
  final FeedbackRepository _feedbackRepository;
  FeedbackController({
    required FeedbackRepository feedbackRepository,
  })  : _feedbackRepository = feedbackRepository,
        super(false);
  Future<RatingResult> feedback(
    int rating,
    String feedbackText,
    BuildContext context,
  ) async {
    final result = await _feedbackRepository.feedback(5, 'hhee');
    return result;
  }
}
