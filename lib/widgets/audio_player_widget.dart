
// widgets/audio_player_widget.dart
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../services/services.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String? audioUrl;
  final String? text;
  final Color? iconColor;
  final double iconSize;

  const AudioPlayerWidget({
    Key? key,
    this.audioUrl,
    this.text,
    this.iconColor,
    this.iconSize = 40,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: widget.audioUrl != null ? _playAudio : null,
            icon: Icon(
              isPlaying ? Icons.pause : Icons.volume_up,
              color: widget.iconColor ?? AppColors.primary,
              size: widget.iconSize,
            ),
          ),
        ),
        if (widget.text != null) ...[
          const SizedBox(width: 12),
          Text(
            widget.text!,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ],
    );
  }

  Future<void> _playAudio() async {
    if (widget.audioUrl == null) return;

    setState(() => isPlaying = true);

    try {
      await AudioService.playAudio(widget.audioUrl!);
      if (mounted) {
        Helpers.showSnackBar(
          context,
          AppStrings.playingAudio,
          backgroundColor: AppColors.primary,
        );
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(
          context,
          AppStrings.audioError,
          backgroundColor: AppColors.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => isPlaying = false);
      }
    }
  }
}
