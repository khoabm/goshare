import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goshare/common/app_button.dart';
import 'package:goshare/common/app_text_field.dart';
import 'package:goshare/common/home_center_container.dart';
import 'package:goshare/common/loader.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/features/feedback/feedback_controller.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  final String idTrip;
  const FeedbackScreen({super.key, required this.idTrip});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  int? _rating = null;
  // String? _feedbackText = null;
  bool _isLoading = false;
  final TextEditingController _feedbackText = TextEditingController();

  void _submitFeedback(WidgetRef ref) async {
    String feedbackText = _feedbackText.text;
    if (_rating != null && feedbackText != null) {
      print('Rating: $_rating');
      print('Feedback Text: $feedbackText');

      final result = await ref
          .read(FeedbackControllerProvider.notifier)
          .feedback(widget.idTrip, _rating!, feedbackText, context);
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
                        RatingStars(
                          rating: _rating,
                          onRatingSelected: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          controller: _feedbackText,
                          hintText: 'Nhập đánh giá của bạn',
                          maxLines: 10,
                        ),
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

class RatingStars extends StatelessWidget {
  final int? rating;
  final Function(int) onRatingSelected;

  const RatingStars({
    Key? key,
    required this.rating,
    required this.onRatingSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 1; i <= 5; i++)
          GestureDetector(
            onTap: () => onRatingSelected(i),
            child: Icon(
              Icons.star,
              size: 30,
              color: (rating != null && rating! >= i)
                  ? const Color(0xffffc107)
                  : Colors.grey,
            ),
          ),
      ],
    );
  }
}

// class FeedbackTextInput extends StatefulWidget {
//   final String? feedbackText;
//   final Function(String) onFeedbackTextChange;

//   const FeedbackTextInput({
//     Key? key,
//     required this.feedbackText,
//     required this.onFeedbackTextChange,
//   }) : super(key: key);

//   @override
//   State<FeedbackTextInput> createState() => _FeedbackTextInputState();
// }

// class _FeedbackTextInputState extends State<FeedbackTextInput> {
//   String _feedbackText = '';

//   @override
//   void initState() {
//     super.initState();
//     _feedbackText = widget.feedbackText ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         hintText: 'Nhập phản hồi của bạn',
//         border: OutlineInputBorder(),
//       ),
//       maxLines: 5, // Set the maximum number of lines for the text field
//       controller: TextEditingController(text: _feedbackText),
//       onChanged: (text) {
//         _feedbackText = text;
//         widget.onFeedbackTextChange(_feedbackText);
//       },
//     );
//   }
// }
