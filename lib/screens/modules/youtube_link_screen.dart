// screens/modules/youtube_link_screen.dart
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class YouTubeLinkScreen extends StatelessWidget {
const YouTubeLinkScreen({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
final videoLessons = [
{
'title': 'Türkçe Dilbilgisi Temelleri',
'description': 'Temel dilbilgisi kurallarını öğrenin',
'thumbnail': '📚',
'url': 'https://youtube.com/watch?v=example1',
'duration': '15:30',
},
{
'title': 'Kelime Öğrenme Teknikleri',
'description': 'Etkili kelime öğrenme yöntemleri',
'thumbnail': '🧠',
'url': 'https://youtube.com/watch?v=example2',
'duration': '12:45',
},
{
'title': 'Telaffuz Geliştirme',
'description': 'Doğru telaffuz için ipuçları',
'thumbnail': '🎤',
'url': 'https://youtube.com/watch?v=example3',
'duration': '18:20',
},
];

return Scaffold(
appBar: AppBar(
title: Text(AppStrings.youtubeLink),
backgroundColor: AppColors.youtubeModule,
foregroundColor: Colors.white,
),
body: Padding(
padding: EdgeInsets.all(AppConstants.mediumPadding),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
padding: EdgeInsets.all(AppConstants.mediumPadding),
decoration: BoxDecoration(
color: AppColors.info.withOpacity(0.1),
borderRadius: BorderRadius.circular(AppConstants.mediumRadius),
),
child: Row(
children: [
Icon(Icons.video_library, color: AppColors.youtubeModule, size: 30),
SizedBox(width: AppConstants.mediumPadding),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Ünite Tekrarı',
style: AppTextStyles.cardTitle,
),
Text(
'Aşağıdaki videolarla konuları pekiştirin',
style: AppTextStyles.bodyMedium,
),
],
),
),
],
),
),
SizedBox(height: AppConstants.largePadding),
Expanded(
child: ListView.builder(
itemCount: videoLessons.length,
itemBuilder: (context, index) {
final video = videoLessons[index];
return Card(
margin: EdgeInsets.only(bottom: AppConstants.mediumPadding),
child: ListTile(
leading: Container(
width: 60,
height: 60,
decoration: BoxDecoration(
color: AppColors.youtubeModule.withOpacity(0.1),
borderRadius: BorderRadius.circular(AppConstants.smallRadius),
),
child: Center(
child: Text(
video['thumbnail'] as String,
style: const TextStyle(fontSize: 30),
),
),
),
title: Text(
video['title'] as String,
style: AppTextStyles.cardTitle,
),
subtitle: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
video['description'] as String,
style: AppTextStyles.bodySmall,
),
SizedBox(height: AppConstants.smallPadding),
Row(
children: [
Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
SizedBox(width: AppConstants.smallPadding),
Text(
video['duration'] as String,
style: AppTextStyles.caption,
),
],
),
],
),
trailing: Icon(
Icons.play_circle_filled,
color: AppColors.youtubeModule,
size: 40,
),
onTap: () => _openYouTubeVideo(context, video['url'] as String),
),
);
},
),
),
],
),
),
);
}

void _openYouTubeVideo(BuildContext context, String url) {
// Here you would typically use url_launcher to open the YouTube video
// For now, we'll show a dialog
showDialog(
context: context,
builder: (context) => AlertDialog(
title: const Text('Video Açılıyor'),
content: Text('YouTube videosu açılacak:\n$url'),
actions: [
TextButton(
onPressed: () => Navigator.pop(context),
child: const Text('Tamam'),
),
],
),
);
}
}
