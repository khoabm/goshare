import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/feedback/controller/feedback_controller.dart';

final ratingProvider = StateProvider<int?>((ref) => null);
final feedbackTextProvider = StateProvider<String?>((ref) => null);

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  bool _isLoading = false;

  void _submitFeedback(WidgetRef ref) {
    final int? rating = ref.read(ratingProvider.notifier).state;
    final String? feedbackText = ref.read(feedbackTextProvider.notifier).state;

    if (rating != null && feedbackText != null) {
      print('Rating: $rating');
      print('Feedback Text: $feedbackText');
    } else {
      print('Please provide both rating and feedback text.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(top: 100),
                  ),
                  HomeCenterContainer(
                    width: MediaQuery.of(context).size.width * .9,
                    child: Column(
                      children: [
                        const Text(
                          'Đánh giá tài xế',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 20),
                        RatingStars(),
                        const SizedBox(height: 20),
                        FeedbackTextInput(),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width * .9,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: AppButton(
                              buttonText: 'Gửi đánh giá',
                              onPressed: () => _submitFeedback(ref),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(
                            8.0,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .3,
                          child: SvgPicture.asset(
                            Constants.carBanner,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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

class RatingStars extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rating = ref.watch(ratingProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 1; i <= 5; i++)
          GestureDetector(
            onTap: () => ref.read(ratingProvider.notifier).state = i,
            child: Icon(
              Icons.star,
              size: 30,
              color: (rating != null && rating >= i)
                  ? const Color(0xffffc107)
                  : Colors.grey,
            ),
          ),
      ],
    );
  }
}

class FeedbackTextInput extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbackText = ref.watch(feedbackTextProvider);

    return TextField(
      decoration: InputDecoration(
        hintText: 'Nhập phản hồi của bạn',
        border: OutlineInputBorder(),
      ),
      maxLines: 5, // Set the maximum number of lines for the text field
      onChanged: (text) => ref.read(feedbackTextProvider.notifier).state = text,
    );
  }
}
