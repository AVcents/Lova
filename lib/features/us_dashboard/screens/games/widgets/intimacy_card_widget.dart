import 'package:flutter/material.dart';
import 'package:lova/features/us_dashboard/models/intimacy_question.dart';

class IntimacyCardWidget extends StatefulWidget {
  final IntimacyQuestion question;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  const IntimacyCardWidget({
    Key? key,
    required this.question,
    this.onSwipeLeft,
    this.onSwipeRight,
  }) : super(key: key);

  @override
  State<IntimacyCardWidget> createState() => _IntimacyCardWidgetState();
}

class _IntimacyCardWidgetState extends State<IntimacyCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(IntimacyCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _controller.reset();
      _controller.forward();
      setState(() {
        _dragOffset = Offset.zero;
        _isDragging = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onPanStart: (_) => setState(() => _isDragging = true),
      onPanUpdate: (details) {
        setState(() {
          _dragOffset += details.delta;
        });
      },
      onPanEnd: (details) {
        setState(() => _isDragging = false);

        // Swipe detection
        if (_dragOffset.dx.abs() > 100) {
          if (_dragOffset.dx > 0) {
            widget.onSwipeRight?.call();
          } else {
            widget.onSwipeLeft?.call();
          }
        }

        setState(() => _dragOffset = Offset.zero);
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Transform.translate(
          offset: _dragOffset,
          child: Transform.rotate(
            angle: _dragOffset.dx / screenWidth * 0.3,
            child: Container(
              width: screenWidth * 0.85,
              height: 500,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.question.isSpicy
                      ? [const Color(0xFFFF6B9D), const Color(0xFFFF9068)]
                      : [const Color(0xFFE91E63), const Color(0xFF9C27B0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Badge catégorie
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getCategoryLabel(widget.question.category),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Badge épicé
                  if (widget.question.isSpicy)
                    const Positioned(
                      top: 20,
                      left: 20,
                      child: Text(
                        '🌶️',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),

                  // Contenu principal
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icône format
                        Text(
                          _getFormatIcon(widget.question.format),
                          style: const TextStyle(fontSize: 48),
                        ),

                        const SizedBox(height: 32),

                        // Question
                        Text(
                          widget.question.question,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // Subtitle
                        if (widget.question.subtitle != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            widget.question.subtitle!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],

                        // Choix multiples
                        if (widget.question.choices != null) ...[
                          const SizedBox(height: 32),
                          ...widget.question.choices!.map((choice) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                choice,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }),
                        ],

                        // Tip
                        if (widget.question.tip != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Text('💡', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    widget.question.tip!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Instructions swipe (si en train de drag)
                  if (_isDragging)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _dragOffset.dx > 0
                                ? 'Question suivante →'
                                : '← Passer',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getCategoryLabel(QuestionCategory category) {
    switch (category) {
      case QuestionCategory.intimacy:
        return 'Intimité';
      case QuestionCategory.emotional:
        return 'Émotionnel';
      case QuestionCategory.fantasy:
        return 'Fantasmes';
      case QuestionCategory.past:
        return 'Souvenirs';
      case QuestionCategory.future:
        return 'Avenir';
      case QuestionCategory.preferences:
        return 'Préférences';
    }
  }

  String _getFormatIcon(QuestionFormat format) {
    switch (format) {
      case QuestionFormat.openEnded:
        return '💬';
      case QuestionFormat.yesNo:
        return '✅';
      case QuestionFormat.scale:
        return '📊';
      case QuestionFormat.choice:
        return '🎯';
      case QuestionFormat.both:
        return '👥';
    }
  }
}