import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../themes/workspace_theme.dart';

enum AIFeature { suggestions, grammar, summarize, paraphrase }

class AIPanel extends StatefulWidget {
  final String currentText;
  final WorkspaceTheme workspace;
  final Function(String) onApply;

  const AIPanel({
    super.key,
    required this.currentText,
    required this.workspace,
    required this.onApply,
  });

  @override
  State<AIPanel> createState() => _AIPanelState();
}

class _AIPanelState extends State<AIPanel> {
  final _ai = AIService();
  AIFeature? _selected;
  String _result = '';
  bool _loading = false;

  final features = [
    {
      'type': AIFeature.suggestions,
      'label': 'AI Suggestions',
      'icon': '💡',
      'desc': 'Get creative ideas to continue'
    },
    {
      'type': AIFeature.grammar,
      'label': 'Grammar Check',
      'icon': '✏️',
      'desc': 'Fix grammar & spelling'
    },
    {
      'type': AIFeature.summarize,
      'label': 'Summarizer',
      'icon': '📝',
      'desc': 'Condense your text'
    },
    {
      'type': AIFeature.paraphrase,
      'label': 'Paraphraser',
      'icon': '🔄',
      'desc': 'Rewrite more eloquently'
    },
  ];

  Future<void> _run(AIFeature feature) async {
    if (widget.currentText.trim().isEmpty) {
      setState(() => _result = 'Please write something first!');
      return;
    }
    setState(() {
      _loading = true;
      _selected = feature;
      _result = '';
    });

    String res;
    switch (feature) {
      case AIFeature.suggestions:
        res = await _ai.getSuggestions(widget.currentText);
        break;
      case AIFeature.grammar:
        res = await _ai.checkGrammar(widget.currentText);
        break;
      case AIFeature.summarize:
        res = await _ai.summarize(widget.currentText);
        break;
      case AIFeature.paraphrase:
        res = await _ai.paraphrase(widget.currentText);
        break;
    }

    setState(() {
      _loading = false;
      _result = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: widget.workspace.glassColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          // Handle bar
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('✨', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text('AI Assistant',
                style: TextStyle(
                  color: widget.workspace.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Feature buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: features.map((f) {
                final type = f['type'] as AIFeature;
                final isSelected = _selected == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _run(type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? widget.workspace.accentColor
                            : Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? widget.workspace.accentColor
                              : Colors.white24,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(f['icon'] as String,
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 4),
                          Text(f['label'] as String,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : widget.workspace.textColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Result area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: _loading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: widget.workspace.accentColor,
                            ),
                            const SizedBox(height: 16),
                            Text('AI is thinking...',
                              style: TextStyle(
                                color: widget.workspace.hintColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _result.isEmpty
                        ? Center(
                            child: Text(
                              'Tap a feature above\nto get AI assistance',
                              style: TextStyle(
                                color: widget.workspace.hintColor,
                                fontSize: 14,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : SingleChildScrollView(
                            child: Text(
                              _result,
                              style: TextStyle(
                                color: widget.workspace.textColor,
                                fontSize: 14,
                                height: 1.7,
                              ),
                            ),
                          ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Apply button (only show for grammar/summarize/paraphrase)
          if (_result.isNotEmpty &&
              _selected != AIFeature.suggestions &&
              !_loading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  widget.onApply(_result);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: widget.workspace.accentColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Apply to my text ✓',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}