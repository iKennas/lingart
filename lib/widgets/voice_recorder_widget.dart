
// widgets/voice_recorder_widget.dart
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../services/services.dart';

class VoiceRecorderWidget extends StatefulWidget {
  final String targetText;
  final Function(double accuracy) onRecordingComplete;

  const VoiceRecorderWidget({
    Key? key,
    required this.targetText,
    required this.onRecordingComplete,
  }) : super(key: key);

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget>
    with SingleTickerProviderStateMixin {
  bool isListening = false;
  String spokenText = '';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Hedef: "${widget.targetText}"',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: isListening ? _stopListening : _startListening,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                width: 80 + (_animationController.value * 20),
                height: 80 + (_animationController.value * 20),
                decoration: BoxDecoration(
                  color: isListening
                      ? AppColors.secondary.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isListening ? AppColors.secondary : AppColors.primary,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isListening ? Icons.mic : Icons.mic_none,
                  color: isListening ? AppColors.secondary : AppColors.primary,
                  size: 40,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isListening ? AppStrings.speakNow : 'Mikrofona dokunun',
          style: AppTextStyles.bodyMedium,
        ),
        if (spokenText.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Söylediğiniz: "$spokenText"',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Future<void> _startListening() async {
    final initialized = await AudioService.initializeSpeechRecognition();
    if (!initialized) {
      if (mounted) {
        Helpers.showSnackBar(
          context,
          AppStrings.microphoneError,
          backgroundColor: AppColors.error,
        );
      }
      return;
    }

    setState(() => isListening = true);
    _animationController.repeat(reverse: true);

    await AudioService.startListening(
      onResult: (result) {
        setState(() => spokenText = result);
      },
    );

    // Auto-stop after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (isListening) _stopListening();
    });
  }

  Future<void> _stopListening() async {
    await AudioService.stopListening();
    setState(() => isListening = false);
    _animationController.stop();
    _animationController.reset();

    if (spokenText.isNotEmpty) {
      final accuracy = AudioService.calculateAccuracy(
        spokenText,
        widget.targetText,
      );
      widget.onRecordingComplete(accuracy);
    }
  }
}
