// lib/shared/widgets/loova_widgets.dart

/// Barrel file pour tous les widgets réutilisables LOOVA
///
/// Ce fichier permet d'importer tous les widgets LOOVA en une seule ligne :
///
/// ```dart
/// import 'package:lova/shared/widgets/loova_widgets.dart';
/// ```
///
/// Au lieu de :
///
/// ```dart
/// import 'package:lova/shared/widgets/cards/loova_card.dart';
/// import 'package:lova/shared/widgets/cards/loova_loading_card.dart';
/// import 'package:lova/shared/widgets/buttons/loova_quick_action.dart';
/// // etc...
/// ```
///
/// Note : Pour de meilleures performances, préférez les imports spécifiques
/// quand vous n'utilisez qu'un seul widget.

// Cards
export 'cards/loova_card.dart';
export 'cards/loova_loading_card.dart';

// Buttons
export 'buttons/loova_quick_action.dart';

// States
export 'states/loova_empty_state.dart';

// Layouts
export 'layouts/loova_icon_container.dart';