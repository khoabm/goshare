import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/feedback/controller/feedback_controller.dart';
import 'package:goshare/theme/pallet.dart';

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
    // Get the selected rating and feedback text
    final int? rating = ref.read(ratingProvider.notifier).state;
    final String? feedbackText = ref.read(feedbackTextProvider.notifier).state;

    if (rating != null && feedbackText != null) {
      // You can perform any additional logic or send the feedback to the server
      // For now, print the values
      print('Rating: $rating');
      print('Feedback Text: $feedbackText');
    } else {
      // Handle the case where either rating or feedback text is not provided
      // This could be displayed as an error message to the user
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
                  // Your header/banner here
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .3,
                    // Replace with your image or SVG
                    // child: Image.asset(Constants.feedbackBanner),
                  ),
                  HomeCenterContainer(
                    width: MediaQuery.of(context).size.width * .9,
                    child: Column(
                      children: [
                        const Text(
                          'Feedback',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Rating Stars
                        RatingStars(),
                        const SizedBox(height: 20),
                        // Feedback Text Input
                        FeedbackTextInput(),
                        const SizedBox(height: 20),
                        // Submit Button
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width * .9,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: AppButton(
                              buttonText: 'Submit Feedback',
                              onPressed: () => _submitFeedback(ref),
                            ),
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

class RatingStars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement your star rating UI here
    // Use Riverpod to manage the selected rating
    return Container(
        // Your star rating UI implementation here
        // Example: A row of stars that the user can tap to select the rating
        );
  }
}

class FeedbackTextInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement your feedback text input UI here
    // Use Riverpod to manage the entered feedback text
    return Container(
        // Your feedback text input UI implementation here
        // Example: A TextFormField where users can enter feedback
        );
  }
}
