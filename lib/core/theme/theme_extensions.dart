// lib/theme/theme_extensions.dart

import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════
// SPACING EXTENSION
// ═══════════════════════════════════════════════════════════════════════════

/// Extension personnalisée pour les espacements (système 8pt)
///
/// Usage:
/// ```dart
/// final spacing = Theme.of(context).extension<AppSpacing>()!;
/// Container(
///   padding: EdgeInsets.all(spacing.lg), // 20px
///   child: Column(
///     children: [
///       Widget1(),
///       SizedBox(height: spacing.xl), // 24px
///       Widget2(),
///     ],
///   ),
/// )
/// ```
class AppSpacing extends ThemeExtension<AppSpacing> {
  final double none;
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;

  // Padding tokens
  final EdgeInsets screenPadding;
  final EdgeInsets cardPaddingSm;
  final EdgeInsets cardPaddingMd;
  final EdgeInsets cardPaddingLg;
  final EdgeInsets buttonPadding;
  final EdgeInsets buttonIconPadding;

  const AppSpacing({
    required this.none,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.screenPadding,
    required this.cardPaddingSm,
    required this.cardPaddingMd,
    required this.cardPaddingLg,
    required this.buttonPadding,
    required this.buttonIconPadding,
  });

  const AppSpacing.light()
      : none = 0,
        xxs = 4,
        xs = 8,
        sm = 12,
        md = 16,
        lg = 20,
        xl = 24,
        xxl = 32,
        xxxl = 40,
        screenPadding = const EdgeInsets.all(20),
        cardPaddingSm = const EdgeInsets.all(16),
        cardPaddingMd = const EdgeInsets.all(20),
        cardPaddingLg = const EdgeInsets.all(24),
        buttonPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        buttonIconPadding = const EdgeInsets.all(16);

  @override
  ThemeExtension<AppSpacing> copyWith({
    double? none,
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    EdgeInsets? screenPadding,
    EdgeInsets? cardPaddingSm,
    EdgeInsets? cardPaddingMd,
    EdgeInsets? cardPaddingLg,
    EdgeInsets? buttonPadding,
    EdgeInsets? buttonIconPadding,
  }) {
    return AppSpacing(
      none: none ?? this.none,
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      screenPadding: screenPadding ?? this.screenPadding,
      cardPaddingSm: cardPaddingSm ?? this.cardPaddingSm,
      cardPaddingMd: cardPaddingMd ?? this.cardPaddingMd,
      cardPaddingLg: cardPaddingLg ?? this.cardPaddingLg,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      buttonIconPadding: buttonIconPadding ?? this.buttonIconPadding,
    );
  }

  @override
  ThemeExtension<AppSpacing> lerp(
    covariant ThemeExtension<AppSpacing>? other,
    double t,
  ) {
    if (other is! AppSpacing) return this;
    return AppSpacing(
      none: none,
      xxs: xxs,
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      xxl: xxl,
      xxxl: xxxl,
      screenPadding: EdgeInsets.lerp(screenPadding, other.screenPadding, t)!,
      cardPaddingSm: EdgeInsets.lerp(cardPaddingSm, other.cardPaddingSm, t)!,
      cardPaddingMd: EdgeInsets.lerp(cardPaddingMd, other.cardPaddingMd, t)!,
      cardPaddingLg: EdgeInsets.lerp(cardPaddingLg, other.cardPaddingLg, t)!,
      buttonPadding: EdgeInsets.lerp(buttonPadding, other.buttonPadding, t)!,
      buttonIconPadding: EdgeInsets.lerp(buttonIconPadding, other.buttonIconPadding, t)!,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// RADII EXTENSION
// ═══════════════════════════════════════════════════════════════════════════

/// Extension personnalisée pour les border radius
///
/// Usage:
/// ```dart
/// final radii = Theme.of(context).extension<AppRadii>()!;
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: BorderRadius.circular(radii.lg), // 20px
///   ),
/// )
/// ```
class AppRadii extends ThemeExtension<AppRadii> {
  final double none;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double full;

  const AppRadii({
    required this.none,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.full,
  });

  const AppRadii.standard()
      : none = 0,
        xs = 8,
        sm = 12,
        md = 16,
        lg = 20,
        xl = 24,
        full = 9999;

  @override
  ThemeExtension<AppRadii> copyWith({
    double? none,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? full,
  }) {
    return AppRadii(
      none: none ?? this.none,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      full: full ?? this.full,
    );
  }

  @override
  ThemeExtension<AppRadii> lerp(
    covariant ThemeExtension<AppRadii>? other,
    double t,
  ) {
    if (other is! AppRadii) return this;
    return AppRadii(
      none: none,
      xs: xs,
      sm: sm,
      md: md,
      lg: lg,
      xl: xl,
      full: full,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SHADOWS EXTENSION
// ═══════════════════════════════════════════════════════════════════════════

/// Extension personnalisée pour les ombres
///
/// Usage:
/// ```dart
/// final shadows = Theme.of(context).extension<AppShadows>()!;
/// Container(
///   decoration: BoxDecoration(
///     boxShadow: shadows.md, // Ombre moyenne
///   ),
/// )
/// ```
class AppShadows extends ThemeExtension<AppShadows> {
  final List<BoxShadow> none;
  final List<BoxShadow> sm;
  final List<BoxShadow> md;
  final List<BoxShadow> lg;
  final List<BoxShadow> xl;

  const AppShadows({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  const AppShadows.light()
      : none = const [],
        sm = const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: Color(0x0D000000), // rgba(0,0,0,0.05)
          ),
        ],
        md = const [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
            color: Color(0x14000000), // rgba(0,0,0,0.08)
          ),
        ],
        lg = const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 16,
            spreadRadius: 0,
            color: Color(0x1F000000), // rgba(0,0,0,0.12)
          ),
        ],
        xl = const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 24,
            spreadRadius: 0,
            color: Color(0x29000000), // rgba(0,0,0,0.16)
          ),
        ];

  const AppShadows.dark()
      : none = const [],
        sm = const [],
        md = const [],
        lg = const [],
        xl = const [];

  @override
  ThemeExtension<AppShadows> copyWith({
    List<BoxShadow>? none,
    List<BoxShadow>? sm,
    List<BoxShadow>? md,
    List<BoxShadow>? lg,
    List<BoxShadow>? xl,
  }) {
    return AppShadows(
      none: none ?? this.none,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  ThemeExtension<AppShadows> lerp(
    covariant ThemeExtension<AppShadows>? other,
    double t,
  ) {
    if (other is! AppShadows) return this;
    return AppShadows(
      none: BoxShadow.lerpList(none, other.none, t) ?? none,
      sm: BoxShadow.lerpList(sm, other.sm, t) ?? sm,
      md: BoxShadow.lerpList(md, other.md, t) ?? md,
      lg: BoxShadow.lerpList(lg, other.lg, t) ?? lg,
      xl: BoxShadow.lerpList(xl, other.xl, t) ?? xl,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DURATIONS EXTENSION
// ═══════════════════════════════════════════════════════════════════════════

/// Extension personnalisée pour les durées d'animation
///
/// Usage:
/// ```dart
/// final durations = Theme.of(context).extension<AppDurations>()!;
/// AnimatedContainer(
///   duration: durations.normal, // 200ms
///   curve: Curves.easeInOut,
///   ...
/// )
/// ```
class AppDurations extends ThemeExtension<AppDurations> {
  final Duration instant;
  final Duration fast;
  final Duration normal;
  final Duration slow;
  final Duration slower;
  final Duration slowest;

  const AppDurations({
    required this.instant,
    required this.fast,
    required this.normal,
    required this.slow,
    required this.slower,
    required this.slowest,
  });

  const AppDurations.standard()
      : instant = Duration.zero,
        fast = const Duration(milliseconds: 100),
        normal = const Duration(milliseconds: 200),
        slow = const Duration(milliseconds: 300),
        slower = const Duration(milliseconds: 500),
        slowest = const Duration(milliseconds: 700);

  @override
  ThemeExtension<AppDurations> copyWith({
    Duration? instant,
    Duration? fast,
    Duration? normal,
    Duration? slow,
    Duration? slower,
    Duration? slowest,
  }) {
    return AppDurations(
      instant: instant ?? this.instant,
      fast: fast ?? this.fast,
      normal: normal ?? this.normal,
      slow: slow ?? this.slow,
      slower: slower ?? this.slower,
      slowest: slowest ?? this.slowest,
    );
  }

  @override
  ThemeExtension<AppDurations> lerp(
    covariant ThemeExtension<AppDurations>? other,
    double t,
  ) {
    if (other is! AppDurations) return this;
    return AppDurations(
      instant: instant,
      fast: fast,
      normal: normal,
      slow: slow,
      slower: slower,
      slowest: slowest,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MOTION EXTENSION
// ═══════════════════════════════════════════════════════════════════════════

/// Extension personnalisée pour les courbes d'animation (easing)
///
/// Usage:
/// ```dart
/// final motion = Theme.of(context).extension<AppMotion>()!;
/// AnimatedContainer(
///   duration: Duration(milliseconds: 200),
///   curve: motion.easeInOut, // Standard
///   ...
/// )
/// ```
class AppMotion extends ThemeExtension<AppMotion> {
  final Curve linear;
  final Curve easeIn;
  final Curve easeOut;
  final Curve easeInOut;
  final Curve fastOutSlowIn;

  const AppMotion({
    required this.linear,
    required this.easeIn,
    required this.easeOut,
    required this.easeInOut,
    required this.fastOutSlowIn,
  });

  const AppMotion.standard()
      : linear = Curves.linear,
        easeIn = Curves.easeIn,
        easeOut = Curves.easeOut,
        easeInOut = Curves.easeInOut,
        fastOutSlowIn = Curves.fastOutSlowIn;

  @override
  ThemeExtension<AppMotion> copyWith({
    Curve? linear,
    Curve? easeIn,
    Curve? easeOut,
    Curve? easeInOut,
    Curve? fastOutSlowIn,
  }) {
    return AppMotion(
      linear: linear ?? this.linear,
      easeIn: easeIn ?? this.easeIn,
      easeOut: easeOut ?? this.easeOut,
      easeInOut: easeInOut ?? this.easeInOut,
      fastOutSlowIn: fastOutSlowIn ?? this.fastOutSlowIn,
    );
  }

  @override
  ThemeExtension<AppMotion> lerp(
    covariant ThemeExtension<AppMotion>? other,
    double t,
  ) {
    if (other is! AppMotion) return this;
    return AppMotion(
      linear: linear,
      easeIn: easeIn,
      easeOut: easeOut,
      easeInOut: easeInOut,
      fastOutSlowIn: fastOutSlowIn,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HELPER EXTENSION SUR BUILDCONTEXT
// ═══════════════════════════════════════════════════════════════════════════

/// Extension pour accéder rapidement aux ThemeExtensions depuis le BuildContext
///
/// Usage:
/// ```dart
/// final spacing = context.spacing;
/// final radii = context.radii;
/// final shadows = context.shadows;
/// final durations = context.durations;
/// final motion = context.motion;
/// ```
extension ThemeExtensionGetter on BuildContext {
  AppSpacing get spacing => Theme.of(this).extension<AppSpacing>()!;
  AppRadii get radii => Theme.of(this).extension<AppRadii>()!;
  AppShadows get shadows => Theme.of(this).extension<AppShadows>()!;
  AppDurations get durations => Theme.of(this).extension<AppDurations>()!;
  AppMotion get motion => Theme.of(this).extension<AppMotion>()!;
}
