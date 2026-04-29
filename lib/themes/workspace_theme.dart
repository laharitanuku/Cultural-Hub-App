import 'package:flutter/material.dart';

enum WorkspaceType { cozyCorner, underTheStars, vibrant, forestHarmony }

class WorkspaceTheme {
  final WorkspaceType type;
  final String name;
  final String emoji;
  final String backgroundImage;
  final Color textColor;
  final Color hintColor;
  final Color accentColor;
  final Color glassColor;
  final String fontFamily;

  const WorkspaceTheme({
    required this.type,
    required this.name,
    required this.emoji,
    required this.backgroundImage,
    required this.textColor,
    required this.hintColor,
    required this.accentColor,
    required this.glassColor,
    required this.fontFamily,
  });

  static const cozyCorner = WorkspaceTheme(
    type: WorkspaceType.cozyCorner,
    name: 'Cozy Corner',
    emoji: '🛋️',
    backgroundImage: 'assets/images/cozy_corner.png',
    textColor: Color(0xFF3E2723),
    hintColor: Color(0xFF8D6E63),
    accentColor: Color(0xFFBF6B3A),
    glassColor: Color(0x99FDF6E3),
    fontFamily: 'Georgia',
  );

  static const underTheStars = WorkspaceTheme(
    type: WorkspaceType.underTheStars,
    name: 'Under The Stars',
    emoji: '⭐',
    backgroundImage: 'assets/images/under_the_stars.png',
    textColor: Color(0xFFE8F0FF),
    hintColor: Color(0xFF9BA8C0),
    accentColor: Color(0xFF7B9CFF),
    glassColor: Color(0x990A0E1A),
    fontFamily: 'Courier New',
  );

  static const vibrant = WorkspaceTheme(
    type: WorkspaceType.vibrant,
    name: 'Vibrant',
    emoji: '✨',
    backgroundImage: 'assets/images/vibrant.png',
    textColor: Color(0xFF2C1A00),
    hintColor: Color(0xFF7A5C2E),
    accentColor: Color(0xFFD4860A),
    glassColor: Color(0x99FFFBF0),
    fontFamily: 'Palatino',
  );

  static const forestHarmony = WorkspaceTheme(
    type: WorkspaceType.forestHarmony,
    name: 'Forest Harmony',
    emoji: '🌲',
    backgroundImage: 'assets/images/forest_harmony.png',
    textColor: Color(0xFFF5F0E8),
    hintColor: Color(0xFFB0A898),
    accentColor: Color(0xFFFF8C42),
    glassColor: Color(0x991A1208),
    fontFamily: 'Georgia',
  );

  static List<WorkspaceTheme> get all =>
      [cozyCorner, underTheStars, vibrant, forestHarmony];
}