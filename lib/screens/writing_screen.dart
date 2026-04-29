import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../models/draft.dart';
import '../services/storage_service.dart';
import '../themes/workspace_theme.dart';
import 'workspace_selector.dart';
import 'ai_panel.dart';
import 'formatting_panel.dart';

class WritingScreen extends StatefulWidget {
  final Draft? existingDraft;
  const WritingScreen({super.key, this.existingDraft});

  @override
  State<WritingScreen> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _contentFocus = FocusNode();
  final _storage = StorageService();
  final _uuid = const Uuid();

  WorkspaceTheme _workspace = WorkspaceTheme.cozyCorner;
  FormattingOptions _fmt = const FormattingOptions();
  bool _isSaving = false;
  bool _hasUnsaved = false;
  bool _showToolbar = true;      // toggle the floating toolbar
  int _wordCount = 0;
  int _charCount = 0;
  late String _draftId;

  @override
  void initState() {
    super.initState();
    if (widget.existingDraft != null) {
      _draftId = widget.existingDraft!.id;
      _titleController.text = widget.existingDraft!.title;
      _contentController.text = widget.existingDraft!.content;
      _updateCounts(widget.existingDraft!.content);
    } else {
      _draftId = _uuid.v4();
    }
    _titleController.addListener(() => setState(() => _hasUnsaved = true));
    _contentController.addListener(() {
      setState(() => _hasUnsaved = true);
      _updateCounts(_contentController.text);
    });
  }

  void _updateCounts(String text) {
    final words = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    setState(() { _wordCount = words; _charCount = text.length; });
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _saveDraft() async {
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      _showSnack('Nothing to save yet...');
      return;
    }
    setState(() => _isSaving = true);
    final draft = Draft(
      id: _draftId,
      title: _titleController.text.trim().isEmpty
          ? 'Untitled'
          : _titleController.text.trim(),
      content: _contentController.text,
      createdAt: widget.existingDraft?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _storage.saveDraft(draft);
    setState(() { _isSaving = false; _hasUnsaved = false; });
    _showSnack('Draft saved ✓', success: true);
  }

  void _showSnack(String msg, {bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.inter(color: Colors.white)),
      backgroundColor: success ? _workspace.accentColor : Colors.grey[700],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }

  // ── Panels ────────────────────────────────────────────────────────────────

  void _showWorkspaceSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => WorkspaceSelector(
        current: _workspace,
        onSelect: (t) => setState(() => _workspace = t),
      ),
    );
  }

  void _showAIPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AIPanel(
        currentText: _contentController.text,
        workspace: _workspace,
        onApply: (result) => setState(() => _contentController.text = result),
      ),
    );
  }

  void _showFormattingPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FormattingPanel(
        workspace: _workspace,
        current: _fmt,
        onChanged: (opts) => setState(() => _fmt = opts),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: Image.asset(
              _workspace.backgroundImage,
              key: ValueKey(_workspace.type),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.28)),
          // Content
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                _buildWordCountBar(),
                if (_showToolbar) _buildFormattingToolbar(),
                Expanded(child: _buildWritingArea()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Top bar (nav + workspace + save) ─────────────────────────────────────

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      color: Colors.black.withOpacity(0.35),
      child: Row(
        children: [
          // Back
          _topBarButton(
            onTap: () async {
              if (_hasUnsaved) await _saveDraft();
              if (mounted) Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          // Workspace selector
          GestureDetector(
            onTap: _showWorkspaceSelector,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_workspace.emoji, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 5),
                  Text(_workspace.name,
                    style: GoogleFonts.inter(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white60, size: 14),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Toggle toolbar
          _topBarButton(
            onTap: () => setState(() => _showToolbar = !_showToolbar),
            tooltip: 'Toggle toolbar',
            child: Icon(
              _showToolbar ? Icons.text_format : Icons.text_format_outlined,
              color: _showToolbar ? _workspace.accentColor : Colors.white70,
              size: 18,
            ),
          ),
          const SizedBox(width: 6),
          // AI
          GestureDetector(
            onTap: _showAIPanel,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.65),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purpleAccent.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('✨', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text('AI',
                    style: GoogleFonts.inter(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Save
          GestureDetector(
            onTap: _isSaving ? null : _saveDraft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _hasUnsaved
                    ? _workspace.accentColor
                    : Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _isSaving
                  ? const SizedBox(width: 14, height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(
                      _hasUnsaved ? 'Save ●' : 'Saved ✓',
                      style: GoogleFonts.inter(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBarButton({required VoidCallback onTap, required Widget child, String? tooltip}) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip ?? '',
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  // ── Word count bar ────────────────────────────────────────────────────────

  Widget _buildWordCountBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      color: Colors.black.withOpacity(0.18),
      child: Row(
        children: [
          _statChip(Icons.article_outlined, '$_wordCount words'),
          const SizedBox(width: 12),
          _statChip(Icons.text_fields, '$_charCount chars'),
          const Spacer(),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: GoogleFonts.inter(
              color: _hasUnsaved ? _workspace.accentColor : Colors.white38,
              fontSize: 11,
            ),
            child: Text(_hasUnsaved ? '● Unsaved' : '✓ Saved'),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white38, size: 13),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
      ],
    );
  }

  // ── MS-Word-style formatting toolbar ─────────────────────────────────────

  Widget _buildFormattingToolbar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: _workspace.glassColor,
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          // Font name button
          _toolbarTextButton(
            label: _fontLabel(_fmt.fontKey),
            onTap: _showFormattingPanel,
            minWidth: 100,
          ),
          _toolbarDivider(),
          // Font size
          _toolbarTextButton(
            label: '${_fmt.fontSize.toInt()}',
            onTap: _showFormattingPanel,
            minWidth: 36,
          ),
          _toolbarDivider(),
          // Bold
          _toolbarIconToggle('B', _fmt.isBold,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white),
            onTap: () => setState(() => _fmt = _fmt.copyWith(isBold: !_fmt.isBold)),
          ),
          // Italic
          _toolbarIconToggle('I', _fmt.isItalic,
            style: GoogleFonts.lora(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white),
            onTap: () => setState(() => _fmt = _fmt.copyWith(isItalic: !_fmt.isItalic)),
          ),
          // Underline
          _toolbarIconToggle('U', _fmt.isUnderline,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white,
              decoration: TextDecoration.underline, decorationColor: Colors.white),
            onTap: () => setState(() => _fmt = _fmt.copyWith(isUnderline: !_fmt.isUnderline)),
          ),
          _toolbarDivider(),
          // Align left
          _toolbarIconToggle2(Icons.format_align_left, _fmt.textAlign == TextAlign.left,
            onTap: () => setState(() => _fmt = _fmt.copyWith(textAlign: TextAlign.left)),
          ),
          _toolbarIconToggle2(Icons.format_align_center, _fmt.textAlign == TextAlign.center,
            onTap: () => setState(() => _fmt = _fmt.copyWith(textAlign: TextAlign.center)),
          ),
          _toolbarIconToggle2(Icons.format_align_right, _fmt.textAlign == TextAlign.right,
            onTap: () => setState(() => _fmt = _fmt.copyWith(textAlign: TextAlign.right)),
          ),
          _toolbarIconToggle2(Icons.format_align_justify, _fmt.textAlign == TextAlign.justify,
            onTap: () => setState(() => _fmt = _fmt.copyWith(textAlign: TextAlign.justify)),
          ),
          _toolbarDivider(),
          // Line height shortcut
          _toolbarTextButton(
            label: '≡ ${_fmt.lineHeight}×',
            onTap: _showFormattingPanel,
          ),
          _toolbarDivider(),
          // More (open full panel)
          _toolbarIconToggle2(Icons.more_horiz, false, onTap: _showFormattingPanel),
        ],
      ),
    );
  }

  String _fontLabel(String key) {
    const labels = {
      'merriweather': 'Merriweather',
      'lora': 'Lora',
      'playfair': 'Playfair',
      'sourceSerif': 'Source Serif',
      'crimsonPro': 'Crimson Pro',
      'inter': 'Inter',
      'ptSans': 'PT Sans',
      'robotoMono': 'Roboto Mono',
    };
    return labels[key] ?? key;
  }

  Widget _toolbarDivider() => Center(
    child: Container(
      width: 1, height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Colors.white.withOpacity(0.15),
    ),
  );

  Widget _toolbarTextButton({
    required String label,
    required VoidCallback onTap,
    double minWidth = 60,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: minWidth),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Text(label,
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
        ),
      ),
    );
  }

  Widget _toolbarIconToggle(String label, bool isActive,
      {required TextStyle style, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 36, height: 36,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        decoration: BoxDecoration(
          color: isActive
              ? _workspace.accentColor.withOpacity(0.7)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(child: Text(label, style: style)),
      ),
    );
  }

  Widget _toolbarIconToggle2(IconData icon, bool isActive, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 36, height: 36,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        decoration: BoxDecoration(
          color: isActive
              ? _workspace.accentColor.withOpacity(0.7)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
    );
  }

  // ── Writing area ──────────────────────────────────────────────────────────

  Widget _buildWritingArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          // Title field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: _workspace.glassColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
              boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 4))],
            ),
            child: TextField(
              controller: _titleController,
              textAlign: _fmt.textAlign,
              style: googleFontStyle(
                _fmt.fontKey,
                fontSize: _fmt.fontSize + 6,
                fontWeight: FontWeight.bold,
                color: _workspace.textColor,
                height: 1.4,
              ),
              decoration: InputDecoration(
                hintText: 'Title your story...',
                hintStyle: googleFontStyle(
                  _fmt.fontKey,
                  fontSize: _fmt.fontSize + 6,
                  color: _workspace.hintColor.withOpacity(0.5),
                  height: 1.4,
                ),
                border: InputBorder.none,
              ),
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          const SizedBox(height: 10),
          // Content field
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _workspace.glassColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 4))],
              ),
              child: TextField(
                controller: _contentController,
                focusNode: _contentFocus,
                textAlign: _fmt.textAlign,
                style: googleFontStyle(
                  _fmt.fontKey,
                  fontSize: _fmt.fontSize,
                  fontWeight: _fmt.isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _fmt.isItalic ? FontStyle.italic : FontStyle.normal,
                  color: _workspace.textColor,
                  height: _fmt.lineHeight,
                ).copyWith(
                  decoration: _fmt.isUnderline
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: _workspace.textColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Begin your story here...\n\nLet the words flow.',
                  hintStyle: googleFontStyle(
                    _fmt.fontKey,
                    fontSize: _fmt.fontSize,
                    color: _workspace.hintColor.withOpacity(0.45),
                    height: _fmt.lineHeight,
                  ),
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
