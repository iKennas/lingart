// screens/modules/text_reading_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';  // Add this import for TapGestureRecognizer
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class TextReadingScreen extends StatefulWidget {
  const TextReadingScreen({Key? key}) : super(key: key);

  @override
  State<TextReadingScreen> createState() => _TextReadingScreenState();
}

class _TextReadingScreenState extends State<TextReadingScreen> {
  final Map<String, String> wordMeanings = {
    'kitap': 'book - Sayfalarda yazılı bilgilerin yer aldığı basılı eser',
    'masa': 'table - Üzerinde yemek yenen veya çalışılan düz yüzeyli mobilya',
    'pencere': 'window - Odaya ışık ve hava girmesini sağlayan açıklık',
    'bahçe': 'garden - Çiçek, ağaç ve sebze yetiştirilen alan',
  };

  String selectedWord = '';
  String? wordMeaning;

  @override
  Widget build(BuildContext context) {
    const text = 'Bu güzel bahçede büyük bir masa var. Masanın üzerinde açık bir kitap duruyor. Pencere açık ve hafif bir rüzgar esiyor.';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.textReading),
        backgroundColor: AppColors.textReadingModule,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Container(
              padding: EdgeInsets.all(AppConstants.mediumPadding),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: AppColors.info),
                  SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Text(
                      'Anlamını öğrenmek istediğiniz kelimelere dokunun',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppConstants.largePadding),

            // Audio Control
            Row(
              children: [
                AudioPlayerWidget(
                  audioUrl: 'text_reading_audio',
                  text: 'Metni dinle',
                ),
              ],
            ),
            SizedBox(height: AppConstants.mediumPadding),

            // Text with clickable words
            Container(
              padding: EdgeInsets.all(AppConstants.mediumPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyLarge.copyWith(height: 1.8),
                  children: _buildClickableText(text),
                ),
              ),
            ),
            SizedBox(height: AppConstants.mediumPadding),

            // Word meaning display
            if (wordMeaning != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppConstants.mediumPadding),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
                  border: Border.all(color: AppColors.success),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seçilen kelime: $selectedWord',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    SizedBox(height: AppConstants.smallPadding),
                    Text(
                      wordMeaning!,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],

            const Spacer(),
            Center(
              child: CustomButton(
                text: 'Metni Tamamla',
                onPressed: () => Navigator.pop(context),
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildClickableText(String text) {
    final words = text.split(' ');
    final List<TextSpan> spans = [];

    for (int i = 0; i < words.length; i++) {
      final word = words[i].replaceAll(RegExp(r'[.,!?]'), '').toLowerCase();
      final isClickable = wordMeanings.containsKey(word);

      spans.add(
        TextSpan(
          text: words[i] + (i < words.length - 1 ? ' ' : ''),
          style: TextStyle(
            color: isClickable ? AppColors.primary : AppColors.textPrimary,
            decoration: isClickable ? TextDecoration.underline : null,
            fontWeight: isClickable ? FontWeight.bold : FontWeight.normal,
          ),
          recognizer: isClickable ? (TapGestureRecognizer()
            ..onTap = () {
              setState(() {
                selectedWord = word;
                wordMeaning = wordMeanings[word];
              });
            }) : null,
        ),
      );
    }

    return spans;
  }
}