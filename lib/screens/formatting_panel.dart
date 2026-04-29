import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themes/workspace_theme.dart';

// ── Data model ────────────────────────────────────────────────────────────────

class FormattingOptions {
  final String fontKey;
  final double fontSize;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final double lineHeight;
  final TextAlign textAlign;

  const FormattingOptions({
    this.fontKey = 'merriweather',
    this.fontSize = 16,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.lineHeight = 1.8,
    this.textAlign = TextAlign.left,
  });

  FormattingOptions copyWith({
    String? fontKey,
    double? fontSize,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    double? lineHeight,
    TextAlign? textAlign,
  }) {
    return FormattingOptions(
      fontKey: fontKey ?? this.fontKey,
      fontSize: fontSize ?? this.fontSize,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      lineHeight: lineHeight ?? this.lineHeight,
      textAlign: textAlign ?? this.textAlign,
    );
  }
}

// ── Font helper (call from anywhere) ─────────────────────────────────────────

TextStyle googleFontStyle(
  String key, {
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.normal,
  FontStyle fontStyle = FontStyle.normal,
  Color color = Colors.white,
  double height = 1.8,
}) {
  final base = TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    color: color,
    height: height,
  );
  switch (key) {
    case 'merriweather':  return GoogleFonts.merriweather(textStyle: base);
    case 'lora':          return GoogleFonts.lora(textStyle: base);
    case 'playfair':      return GoogleFonts.playfairDisplay(textStyle: base);
    case 'sourceSerif':   return GoogleFonts.sourceSerif4(textStyle: base);
    case 'crimsonPro':    return GoogleFonts.crimsonPro(textStyle: base);
    case 'inter':         return GoogleFonts.inter(textStyle: base);
    case 'robotoMono':    return GoogleFonts.robotoMono(textStyle: base);
    case 'ptSans':        return GoogleFonts.ptSans(textStyle: base);
    default:              return GoogleFonts.merriweather(textStyle: base);
  }
}

// ── Font catalogue ────────────────────────────────────────────────────────────

const _fonts = [
  {
    'key': 'merriweather',
    'label': 'Merriweather',
    'preview': 'Best readability for long writing',
    'tag': 'Serif',
  },
  {
    'key': 'lora',
    'label': 'Lora',
    'preview': 'Elegant brushed strokes, literary feel',
    'tag': 'Serif',
  },
  {
    'key': 'playfair',
    'label': 'Playfair Display',
    'preview': 'High-contrast editorial headlines',
    'tag': 'Serif',
  },
  {
    'key': 'sourceSerif',
    'label': 'Source Serif 4',
    'preview': 'Clean newspaper-style body text',
    'tag': 'Serif',
  },
  {
    'key': 'crimsonPro',
    'label': 'Crimson Pro',
    'preview': 'Classic book-print manuscript style',
    'tag': 'Serif',
  },
  {
    'key': 'inter',
    'label': 'Inter',
    'preview': 'Modern sans-serif, like Google Docs',
    'tag': 'Sans',
  },
  {
    'key': 'ptSans',
    'label': 'PT Sans',
    'preview': 'Clean and neutral, great for notes',
    'tag': 'Sans',
  },
  {
    'key': 'robotoMono',
    'label': 'Roboto Mono',
    'preview': 'Monospace typewriter character',
    'tag': 'Mono',
  },
];

const _fontSizes = [11.0, 12.0, 14.0, 16.0, 18.0, 20.0, 22.0, 24.0];
const _lineHeights = [1.2, 1.5, 1.8, 2.0, 2.5];
const _lineHeightLabels = ['1.2×', '1.5×', '1.8×', '2.0×', '2.5×'];

// ── Widget ────────────────────────────────────────────────────────────────────

class FormattingPanel extends StatefulWidget {
  final WorkspaceTheme workspace;
  final FormattingOptions current;
  final ValueChanged<FormattingOptions> onChanged;

  const FormattingPanel({
    super.key,
    required this.workspace,
    required this.current,
    required this.onChanged,
  });

  @override
  State<FormattingPanel> createState() => _FormattingPanelState();
}

class _FormattingPanelState extends State<FormattingPanel>
    with SingleTickerProviderStateMixin {
  late FormattingOptions _opts;
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _opts = widget.current;
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _update(FormattingOptions updated) {
    setState(() => _opts = updated);
    widget.onChanged(updated);
  }

  Color get _accent => widget.workspace.accentColor;
  Color get _text => widget.workspace.textColor;
  Color get _hint => widget.workspace.hintColor;
  Color get _glass => widget.workspace.glassColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: _glass,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildTitle(),
          _buildStyleBar(),        // Bold / Italic / Underline / Align — always visible
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _buildFontsTab(),
                _buildSpacingTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Handle + title ────────────────────────────────────────────────────────

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 40, height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          Icon(Icons.text_format, color: _accent, size: 20),
          const SizedBox(width: 8),
          Text('Format Text',
            style: GoogleFonts.inter(
              color: _text, fontSize: 17, fontWeight: FontWeight.bold)),
          const Spacer(),
          // Live preview badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Preview',
              style: GoogleFonts.inter(color: _accent, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ── Live preview strip ────────────────────────────────────────────────────

  Widget _buildPreviewStrip() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Text(
        'The quick brown fox jumps over the lazy dog.',
        textAlign: _opts.textAlign,
        style: googleFontStyle(
          _opts.fontKey,
          fontSize: _opts.fontSize,
          fontWeight: _opts.isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: _opts.isItalic ? FontStyle.italic : FontStyle.normal,
          color: _text,
          height: 1.5,
        ).copyWith(
          decoration: _opts.isUnderline ? TextDecoration.underline : TextDecoration.none,
          decorationColor: _text,
        ),
      ),
    );
  }

  // ── Style bar (B / I / U / align) ────────────────────────────────────────

  Widget _buildStyleBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          // Bold
          _iconToggle(
            label: 'B',
            isActive: _opts.isBold,
            style: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white),
            onTap: () => _update(_opts.copyWith(isBold: !_opts.isBold)),
          ),
          const SizedBox(width: 8),
          // Italic
          _iconToggle(
            label: 'I',
            isActive: _opts.isItalic,
            style: GoogleFonts.lora(
              fontSize: 15, fontStyle: FontStyle.italic, color: Colors.white),
            onTap: () => _update(_opts.copyWith(isItalic: !_opts.isItalic)),
          ),
          const SizedBox(width: 8),
          // Underline
          _iconToggle(
            label: 'U',
            isActive: _opts.isUnderline,
            style: GoogleFonts.inter(fontSize: 15, color: Colors.white,
              decoration: TextDecoration.underline, decorationColor: Colors.white),
            onTap: () => _update(_opts.copyWith(isUnderline: !_opts.isUnderline)),
          ),
          const SizedBox(width: 16),
          // Divider
          Container(width: 1, height: 32, color: Colors.white24),
          const SizedBox(width: 16),
          // Alignment
          _alignToggle(Icons.format_align_left, TextAlign.left),
          const SizedBox(width: 8),
          _alignToggle(Icons.format_align_center, TextAlign.center),
          const SizedBox(width: 8),
          _alignToggle(Icons.format_align_right, TextAlign.right),
          const SizedBox(width: 8),
          _alignToggle(Icons.format_align_justify, TextAlign.justify),
        ],
      ),
    );
  }

  Widget _iconToggle({
    required String label,
    required bool isActive,
    required TextStyle style,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: isActive ? _accent : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? _accent : Colors.white24),
        ),
        child: Center(child: Text(label, style: style)),
      ),
    );
  }

  Widget _alignToggle(IconData icon, TextAlign align) {
    final isActive = _opts.textAlign == align;
    return GestureDetector(
      onTap: () => _update(_opts.copyWith(textAlign: align)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: isActive ? _accent : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? _accent : Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  // ── Tab bar ───────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabs,
          indicator: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
          labelColor: Colors.white,
          unselectedLabelColor: _hint,
          tabs: const [
            Tab(text: 'Font'),
            Tab(text: 'Spacing'),
          ],
        ),
      ),
    );
  }

  // ── Fonts tab ─────────────────────────────────────────────────────────────

  Widget _buildFontsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPreviewStrip(),
          const SizedBox(height: 16),
          _sectionLabel('FONT SIZE'),
          const SizedBox(height: 10),
          _buildFontSizes(),
          const SizedBox(height: 20),
          _sectionLabel('TYPEFACE'),
          const SizedBox(height: 10),
          ..._fonts.map(_buildFontRow),
        ],
      ),
    );
  }

  Widget _buildFontSizes() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _fontSizes.map((size) {
        final isSelected = _opts.fontSize == size;
        return GestureDetector(
          onTap: () => _update(_opts.copyWith(fontSize: size)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 52, height: 44,
            decoration: BoxDecoration(
              color: isSelected ? _accent : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSelected ? _accent : Colors.white24),
            ),
            child: Center(
              child: Text('${size.toInt()}',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFontRow(Map<String, String> font) {
    final key = font['key']!;
    final isSelected = _opts.fontKey == key;
    return GestureDetector(
      onTap: () => _update(_opts.copyWith(fontKey: key)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _accent.withOpacity(0.25) : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _accent : Colors.white.withOpacity(0.15),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(font['label']!,
                        style: googleFontStyle(key,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _text,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(font['tag']!,
                          style: GoogleFonts.inter(
                            fontSize: 9, color: _hint, fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(font['preview']!,
                    style: GoogleFonts.inter(fontSize: 11, color: _hint),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: _accent, size: 20),
          ],
        ),
      ),
    );
  }

  // ── Spacing tab ───────────────────────────────────────────────────────────

  Widget _buildSpacingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPreviewStrip(),
          const SizedBox(height: 20),
          _sectionLabel('LINE SPACING'),
          const SizedBox(height: 12),
          Row(
            children: List.generate(_lineHeights.length, (i) {
              final h = _lineHeights[i];
              final isSelected = _opts.lineHeight == h;
              return GestureDetector(
                onTap: () => _update(_opts.copyWith(lineHeight: h)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? _accent : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? _accent : Colors.white24),
                  ),
                  child: Column(
                    children: [
                      // Mini line-spacing icon
                      Icon(Icons.format_line_spacing, color: Colors.white, size: 16),
                      const SizedBox(height: 4),
                      Text(_lineHeightLabels[i],
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          _sectionLabel('QUICK PRESETS'),
          const SizedBox(height: 12),
          _buildPresets(),
        ],
      ),
    );
  }

  Widget _buildPresets() {
    final presets = [
      {'label': 'Novel', 'icon': '📖', 'fontKey': 'lora', 'fontSize': 16.0, 'lineHeight': 1.8},
      {'label': 'Academic', 'icon': '🎓', 'fontKey': 'sourceSerif', 'fontSize': 12.0, 'lineHeight': 2.0},
      {'label': 'Screenplay', 'icon': '🎬', 'fontKey': 'robotoMono', 'fontSize': 12.0, 'lineHeight': 1.5},
      {'label': 'Blog', 'icon': '✍️', 'fontKey': 'inter', 'fontSize': 16.0, 'lineHeight': 1.8},
      {'label': 'Poetry', 'icon': '🌸', 'fontKey': 'playfair', 'fontSize': 18.0, 'lineHeight': 2.5},
      {'label': 'Journal', 'icon': '📔', 'fontKey': 'merriweather', 'fontSize': 14.0, 'lineHeight': 1.8},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: presets.length,
      itemBuilder: (_, i) {
        final p = presets[i];
        return GestureDetector(
          onTap: () => _update(_opts.copyWith(
            fontKey: p['fontKey'] as String,
            fontSize: p['fontSize'] as double,
            lineHeight: p['lineHeight'] as double,
          )),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(p['icon'] as String, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(p['label'] as String,
                  style: GoogleFonts.inter(
                    color: _text, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Helper ────────────────────────────────────────────────────────────────

  Widget _sectionLabel(String label) {
    return Text(label,
      style: GoogleFonts.inter(
        color: _hint, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2),
    );
  }
}
