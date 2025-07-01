// screens/modules/dialog_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../utils/app_theme.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class DialogScreen extends StatefulWidget {
  const DialogScreen({Key? key}) : super(key: key);

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _messageController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _messageSlideAnimation;

  int currentDialogIndex = 0;
  int currentMessageIndex = 0;
  bool showOptions = false;
  bool dialogCompleted = false;
  int score = 0;

  final List<Map<String, dynamic>> dialogs = [
    {
      'title': 'Restoranda',
      'scenario': 'Bir restoranda yemek sipariş ediyorsunuz.',
      'messages': [
        {
          'speaker': 'Garson',
          'text': 'Hoş geldiniz! Buyurun, ne alırdınız?',
          'isUser': false,
        },
        {
          'speaker': 'Siz',
          'text': '',
          'isUser': true,
          'options': [
            'Merhaba, menüyü görebilir miyim?',
            'Bir kahve lütfen.',
            'Hesap lütfen.',
            'Teşekkür ederim.',
          ],
          'correct': 'Merhaba, menüyü görebilir miyim?',
          'explanation': 'Restoranda ilk önce menüyü görmek isteriz.',
        },
        {
          'speaker': 'Garson',
          'text': 'Tabii, buyurun menümüz. Size ne önerebilirim?',
          'isUser': false,
        },
        {
          'speaker': 'Siz',
          'text': '',
          'isUser': true,
          'options': [
            'Bugünün yemeği nedir?',
            'Hesap lütfen.',
            'Tuvalet nerede?',
            'Kapıyı kapatın.',
          ],
          'correct': 'Bugünün yemeği nedir?',
          'explanation': 'Menüye baktıktan sonra özel teklifler hakkında soru sormak doğaldır.',
        },
        {
          'speaker': 'Garson',
          'text': 'Bugün özel olarak kuzu tandır var. Çok lezzetli!',
          'isUser': false,
        },
        {
          'speaker': 'Siz',
          'text': '',
          'isUser': true,
          'options': [
            'O zaman kuzu tandır lütfen.',
            'Hayır, teşekkürler.',
            'Çok pahalı.',
            'Anlayamadım.',
          ],
          'correct': 'O zaman kuzu tandır lütfen.',
          'explanation': 'Önerilen yemeği beğendiysek sipariş veririz.',
        },
      ],
    },
    {
      'title': 'Mağazada',
      'scenario': 'Bir giyim mağazasında alışveriş yapıyorsunuz.',
      'messages': [
        {
          'speaker': 'Satış Danışmanı',
          'text': 'Merhaba, size nasıl yardımcı olabilirim?',
          'isUser': false,
        },
        {
          'speaker': 'Siz',
          'text': '',
          'isUser': true,
          'options': [
            'Bir tişört arıyorum.',
            'Hesap lütfen.',
            'Çok güzel.',
            'Hayır, teşekkürler.',
          ],
          'correct': 'Bir tişört arıyorum.',
          'explanation': 'Mağazada aradığımız ürünü söyleriz.',
        },
        {
          'speaker': 'Satış Danışmanı',
          'text': 'Hangi renk ve beden istiyorsunuz?',
          'isUser': false,
        },
        {
          'speaker': 'Siz',
          'text': '',
          'isUser': true,
          'options': [
            'Mavi, medium beden.',
            'Çok pahalı.',
            'Bilmiyorum.',
            'Evet, lütfen.',
          ],
          'correct': 'Mavi, medium beden.',
          'explanation': 'Renk ve beden tercihleri söyleriz.',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _messageController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _messageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _messageController,
      curve: Curves.easeOut,
    ));

    _fadeController.forward();
    _messageController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('Diyalog Pratiği'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing12,
              vertical: AppTheme.spacing8,
            ),
            margin: const EdgeInsets.only(right: AppTheme.spacing16),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: Text(
              'Skor: $score',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: dialogCompleted ? _buildCompletionScreen() : _buildDialogScreen(),
      ),
    );
  }

  Widget _buildDialogScreen() {
    final dialog = dialogs[currentDialogIndex];
    final messages = dialog['messages'] as List<Map<String, dynamic>>;

    return Column(
      children: [
        // Dialog Header
        Container(
          margin: const EdgeInsets.all(AppTheme.spacing20),
          padding: const EdgeInsets.all(AppTheme.spacing20),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            boxShadow: AppTheme.primaryShadow,
          ),
          child: Column(
            children: [
              Text(
                dialog['title'],
                style: AppTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                dialog['scenario'],
                style: AppTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // Messages
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: [
                // Messages List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacing16),
                    itemCount: currentMessageIndex + 1,
                    itemBuilder: (context, index) {
                      if (index < messages.length) {
                        return _buildMessage(messages[index], index);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                // Options or Continue Button
                if (showOptions && currentMessageIndex < messages.length)
                  _buildOptionsSection()
                else if (!showOptions && currentMessageIndex < messages.length - 1)
                  _buildContinueButton(),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppTheme.spacing20),
      ],
    );
  }

  Widget _buildMessage(Map<String, dynamic> message, int index) {
    final isUser = message['isUser'] as bool;
    final hasOptions = message.containsKey('options');

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              radius: 20,
              child: const Icon(
                Icons.person,
                color: AppTheme.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spacing8),
          ],

          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isUser)
                  Text(
                    message['speaker'],
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                const SizedBox(height: AppTheme.spacing4),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(AppTheme.spacing12),
                  decoration: BoxDecoration(
                    color: isUser ? AppTheme.accentRed : AppTheme.lightGrey,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: message['text'].isEmpty && hasOptions
                      ? Text(
                    'Seçenek belirleyin...',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: isUser ? AppTheme.white.withOpacity(0.7) : AppTheme.mediumGrey,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                      : Text(
                    message['text'],
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: isUser ? AppTheme.white : AppTheme.darkGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (isUser) ...[
            const SizedBox(width: AppTheme.spacing8),
            CircleAvatar(
              backgroundColor: AppTheme.accentRed,
              radius: 20,
              child: const Icon(
                Icons.person_outline,
                color: AppTheme.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionsSection() {
    final dialog = dialogs[currentDialogIndex];
    final messages = dialog['messages'] as List<Map<String, dynamic>>;
    final currentMessage = messages[currentMessageIndex];
    final options = currentMessage['options'] as List<String>;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppTheme.radiusLarge),
          bottomRight: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ne söylersiniz?',
            style: AppTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),

          ...options.map((option) => _buildOptionButton(option)).toList(),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      child: GestureDetector(
        onTap: () => _selectOption(option),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacing12),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: AppTheme.borderGrey),
            boxShadow: [
              BoxShadow(
                color: AppTheme.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            option,
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkGrey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: CustomButton.primary(
        text: 'Devam Et',
        onPressed: _continueDialog,
        isFullWidth: true,
        size: ButtonSize.medium,
        icon: const Icon(Icons.arrow_forward, size: 20),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    final percentage = (score / (dialogs.length * 20) * 100).round();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: percentage >= 70 ? AppTheme.accentGradient : AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                boxShadow: percentage >= 70 ? AppTheme.accentShadow : AppTheme.primaryShadow,
              ),
              child: Icon(
                percentage >= 70 ? Icons.emoji_events : Icons.chat_bubble_outline,
                size: 60,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),

            Text(
              percentage >= 70 ? 'Harika Konuşma!' : 'İyi İş!',
              style: AppTheme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppTheme.spacing16),

            Container(
              padding: const EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                children: [
                  Text(
                    'Diyalog Tamamlandı',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$score',
                            style: AppTheme.textTheme.headlineMedium?.copyWith(
                              color: AppTheme.accentRed,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Skor',
                            style: AppTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${dialogs.length}',
                            style: AppTheme.textTheme.headlineMedium?.copyWith(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Diyalog',
                            style: AppTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '%$percentage',
                            style: AppTheme.textTheme.headlineMedium?.copyWith(
                              color: AppTheme.accentRed,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Başarı',
                            style: AppTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing40),

            Column(
              children: [
                CustomButton.primary(
                  text: 'Tekrar Başla',
                  onPressed: _restartDialog,
                  isFullWidth: true,
                  size: ButtonSize.large,
                  icon: const Icon(Icons.refresh, size: 24),
                ),
                const SizedBox(height: AppTheme.spacing16),
                CustomButton.outline(
                  text: 'Ana Menüye Dön',
                  onPressed: () => Navigator.pop(context),
                  isFullWidth: true,
                  size: ButtonSize.large,
                  icon: const Icon(Icons.home, size: 24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectOption(String option) {
    final dialog = dialogs[currentDialogIndex];
    final messages = dialog['messages'] as List<Map<String, dynamic>>;
    final currentMessage = messages[currentMessageIndex];
    final correctAnswer = currentMessage['correct'] as String;
    final isCorrect = option == correctAnswer;

    setState(() {
      messages[currentMessageIndex]['text'] = option;
      showOptions = false;
    });

    if (isCorrect) {
      score += 10;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Doğru seçim! 🎉'),
          backgroundColor: AppTheme.accentRed,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1000),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Doğru cevap: $correctAnswer'),
          backgroundColor: AppTheme.primaryBlue,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 2000),
        ),
      );
    }

    HapticFeedback.lightImpact();

    // Auto continue after option selection
    Future.delayed(const Duration(milliseconds: 1500), () {
      _continueDialog();
    });
  }

  void _continueDialog() {
    final dialog = dialogs[currentDialogIndex];
    final messages = dialog['messages'] as List<Map<String, dynamic>>;

    if (currentMessageIndex < messages.length - 1) {
      setState(() {
        currentMessageIndex++;

        // Check if next message needs options
        if (currentMessageIndex < messages.length &&
            messages[currentMessageIndex]['isUser'] == true &&
            messages[currentMessageIndex].containsKey('options')) {
          showOptions = true;
        }
      });

      _messageController.reset();
      _messageController.forward();
    } else {
      // Move to next dialog or complete
      if (currentDialogIndex < dialogs.length - 1) {
        setState(() {
          currentDialogIndex++;
          currentMessageIndex = 0;
          showOptions = false;
        });
      } else {
        setState(() {
          dialogCompleted = true;
        });
      }
    }

    HapticFeedback.lightImpact();
  }

  void _restartDialog() {
    setState(() {
      currentDialogIndex = 0;
      currentMessageIndex = 0;
      showOptions = false;
      dialogCompleted = false;
      score = 0;

      // Reset all message texts
      for (var dialog in dialogs) {
        final messages = dialog['messages'] as List<Map<String, dynamic>>;
        for (var message in messages) {
          if (message['isUser'] == true) {
            message['text'] = '';
          }
        }
      }
    });

    _fadeController.reset();
    _fadeController.forward();
  }
}