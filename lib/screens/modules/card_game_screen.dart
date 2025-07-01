// screens/modules/card_game_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import '../../utils/app_theme.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class CardGameScreen extends StatefulWidget {
  const CardGameScreen({Key? key}) : super(key: key);

  @override
  State<CardGameScreen> createState() => _CardGameScreenState();
}

class _CardGameScreenState extends State<CardGameScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late List<AnimationController> _cardControllers;

  bool gameStarted = false;
  bool gameEnded = false;
  int score = 0;
  int moves = 0;
  int matchedPairs = 0;
  List<GameCard> cards = [];
  List<int> flippedCardIndices = [];
  bool canFlip = true;
  late Timer _gameTimer;
  int gameTimeElapsed = 0;

  final List<Map<String, String>> cardPairs = [
    {'turkish': 'elma', 'english': 'apple'},
    {'turkish': 'kitap', 'english': 'book'},
    {'turkish': 'araba', 'english': 'car'},
    {'turkish': 'ev', 'english': 'house'},
    {'turkish': 'okul', 'english': 'school'},
    {'turkish': 'su', 'english': 'water'},
    {'turkish': 'güneş', 'english': 'sun'},
    {'turkish': 'ay', 'english': 'moon'},
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _cardControllers = [];
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    if (gameStarted && !gameEnded) {
      _gameTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('Kart Eşleştirme Oyunu'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (gameStarted && !gameEnded)
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
                'Hamle: $moves',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeController,
        child: !gameStarted
            ? _buildStartScreen()
            : gameEnded
            ? _buildEndScreen()
            : _buildGameScreen(),
      ),
    );
  }

  Widget _buildStartScreen() {
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
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                boxShadow: AppTheme.primaryShadow,
              ),
              child: const Icon(
                Icons.style,
                size: 60,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),

            Text(
              'Kart Eşleştirme Oyunu',
              style: AppTheme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
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
                    'Nasıl Oynanır?',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing12),
                  Text(
                    '🃏 Kartlara tıklayarak çevirin\n'
                        '🔍 Türkçe kelime ile İngilizce çevirisini eşleştirin\n'
                        '✨ En az hamle ile tüm çiftleri bulun\n'
                        '🏆 Yüksek skor için hızlı olun!',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing40),

            CustomButton.primary(
              text: 'Oyunu Başlat',
              onPressed: _startGame,
              isFullWidth: true,
              size: ButtonSize.large,
              icon: const Icon(Icons.play_arrow, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing20),
      child: Column(
        children: [
          // Game Stats
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Eşleşen', '$matchedPairs/${cardPairs.length}', Icons.check_circle),
                _buildStatItem('Hamle', '$moves', Icons.touch_app),
                _buildStatItem('Skor', '$score', Icons.emoji_events),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Progress Bar
          Container(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'İlerleme',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    Text(
                      '${(matchedPairs / cardPairs.length * 100).round()}%',
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing8),
                LinearProgressIndicator(
                  value: matchedPairs / cardPairs.length,
                  backgroundColor: AppTheme.lightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                  minHeight: 8,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacing24),

          // Cards Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              crossAxisSpacing: AppTheme.spacing12,
              mainAxisSpacing: AppTheme.spacing12,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return _buildCard(cards[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(GameCard card, int index) {
    return GestureDetector(
      onTap: canFlip && !card.isFlipped && !card.isMatched ? () => _flipCard(index) : null,
      child: AnimatedBuilder(
        animation: card.controller,
        builder: (context, child) {
          final isShowingFront = card.controller.value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(card.controller.value * 3.14159),
            child: Container(
              decoration: BoxDecoration(
                color: card.isMatched
                    ? AppTheme.success.withOpacity(0.1)
                    : isShowingFront
                    ? AppTheme.primaryBlue
                    : AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: card.isMatched
                      ? AppTheme.success
                      : card.isFlipped
                      ? AppTheme.accentRed
                      : AppTheme.primaryBlue,
                  width: 2,
                ),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Center(
                child: isShowingFront
                    ? const Icon(
                  Icons.quiz,
                  color: AppTheme.white,
                  size: 32,
                )
                    : Text(
                  card.content,
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: card.isMatched ? AppTheme.success : AppTheme.darkGrey,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacing8),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryBlue,
            size: 24,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          value,
          style: AppTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.primaryBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.mediumGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildEndScreen() {
    final isExcellent = score >= 80;

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
                gradient: isExcellent ? AppTheme.accentGradient : AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                boxShadow: isExcellent ? AppTheme.accentShadow : AppTheme.primaryShadow,
              ),
              child: Icon(
                isExcellent ? Icons.emoji_events : Icons.thumb_up,
                size: 60,
                color: AppTheme.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacing32),

            Text(
              isExcellent ? 'Mükemmel!' : 'Tebrikler!',
              style: AppTheme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
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
                    'Oyun Sonuçları',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildResultItem('Skor', '$score', AppTheme.accentRed),
                      _buildResultItem('Hamle', '$moves', AppTheme.primaryBlue),
                      _buildResultItem('Süre', '${gameTimeElapsed}s', AppTheme.mediumGrey),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing40),

            CustomButton.primary(
              text: 'Tekrar Oyna',
              onPressed: _restartGame,
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
      ),
    );
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing12,
            vertical: AppTheme.spacing8,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Text(
            value,
            style: AppTheme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          label,
          style: AppTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.mediumGrey,
          ),
        ),
      ],
    );
  }

  void _startGame() {
    setState(() {
      gameStarted = true;
      gameTimeElapsed = 0;
    });

    _setupCards();
    _startTimer();
    HapticFeedback.lightImpact();
  }

  void _setupCards() {
    cards.clear();
    _cardControllers.clear();

    // Create pairs of cards
    for (var pair in cardPairs) {
      // Turkish card
      final turkishController = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
      _cardControllers.add(turkishController);

      cards.add(GameCard(
        id: '${pair['turkish']}_tr',
        content: pair['turkish']!,
        pairId: pair['turkish']!,
        controller: turkishController,
      ));

      // English card
      final englishController = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
      _cardControllers.add(englishController);

      cards.add(GameCard(
        id: '${pair['turkish']}_en',
        content: pair['english']!,
        pairId: pair['turkish']!,
        controller: englishController,
      ));
    }

    // Shuffle cards
    cards.shuffle();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        gameTimeElapsed++;
      });
    });
  }

  void _flipCard(int index) {
    if (!canFlip || cards[index].isFlipped || cards[index].isMatched) return;

    setState(() {
      cards[index].isFlipped = true;
      flippedCardIndices.add(index);
      moves++;
    });

    cards[index].controller.forward();

    if (flippedCardIndices.length == 2) {
      canFlip = false;
      _checkForMatch();
    }

    HapticFeedback.lightImpact();
  }

  void _checkForMatch() {
    final firstCard = cards[flippedCardIndices[0]];
    final secondCard = cards[flippedCardIndices[1]];

    if (firstCard.pairId == secondCard.pairId) {
      // Match found!
      setState(() {
        firstCard.isMatched = true;
        secondCard.isMatched = true;
        matchedPairs++;
        score += 10;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Eşleşme bulundu! +10 puan 🎉'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1000),
        ),
      );

      _resetFlippedCards();

      // Check if game is complete
      if (matchedPairs == cardPairs.length) {
        _endGame();
      }
    } else {
      // No match, flip cards back after delay
      Timer(const Duration(milliseconds: 1000), () {
        for (int index in flippedCardIndices) {
          cards[index].controller.reverse();
          setState(() {
            cards[index].isFlipped = false;
          });
        }
        _resetFlippedCards();
      });
    }
  }

  void _resetFlippedCards() {
    setState(() {
      flippedCardIndices.clear();
      canFlip = true;
    });
  }

  void _endGame() {
    _gameTimer.cancel();

    // Calculate bonus score based on moves and time
    final moveBonus = (100 - moves).clamp(0, 50);
    final timeBonus = (300 - gameTimeElapsed).clamp(0, 50);

    setState(() {
      score += moveBonus + timeBonus;
      gameEnded = true;
    });
  }

  void _restartGame() {
    // Dispose existing controllers
    for (var controller in _cardControllers) {
      controller.dispose();
    }

    setState(() {
      gameStarted = false;
      gameEnded = false;
      score = 0;
      moves = 0;
      matchedPairs = 0;
      cards.clear();
      flippedCardIndices.clear();
      canFlip = true;
      gameTimeElapsed = 0;
    });

    _cardControllers.clear();
    _fadeController.reset();
    _fadeController.forward();
    HapticFeedback.lightImpact();
  }
}

class GameCard {
  final String id;
  final String content;
  final String pairId;
  final AnimationController controller;
  bool isFlipped;
  bool isMatched;

  GameCard({
    required this.id,
    required this.content,
    required this.pairId,
    required this.controller,
    this.isFlipped = false,
    this.isMatched = false,
  });
}