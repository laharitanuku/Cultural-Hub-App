import 'package:flutter/material.dart';
import '../themes/workspace_theme.dart';

class WorkspaceSelector extends StatelessWidget {
  final WorkspaceTheme current;
  final Function(WorkspaceTheme) onSelect;

  const WorkspaceSelector({
    super.key,
    required this.current,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: current.glassColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text('Choose Your Workspace',
            style: TextStyle(color: current.textColor, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: WorkspaceTheme.all.length,
              itemBuilder: (context, index) {
                final theme = WorkspaceTheme.all[index];
                final isSelected = theme.type == current.type;
                return GestureDetector(
                  onTap: () { onSelect(theme); Navigator.pop(context); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? theme.accentColor : Colors.white24,
                        width: isSelected ? 2.5 : 1,
                      ),
                      boxShadow: isSelected ? [BoxShadow(color: theme.accentColor.withOpacity(0.4), blurRadius: 12)] : [],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(theme.backgroundImage, fit: BoxFit.cover),
                          Container(color: Colors.black.withOpacity(isSelected ? 0.2 : 0.4)),
                          Positioned(
                            bottom: 8, left: 0, right: 0,
                            child: Column(
                              children: [
                                Text(theme.emoji, style: const TextStyle(fontSize: 20)),
                                const SizedBox(height: 4),
                                Text(theme.name,
                                  style: const TextStyle(
                                    color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600,
                                    shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 8, right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(color: theme.accentColor, shape: BoxShape.circle),
                                child: const Icon(Icons.check, color: Colors.white, size: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}