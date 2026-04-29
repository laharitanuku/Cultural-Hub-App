import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/writing_screen.dart';
import 'screens/books_screen.dart';

void main() {
  runApp(const CulturalApp());
}

class CulturalApp extends StatelessWidget {
  const CulturalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cultural Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFBF8040)),
      ),
      home: const LaunchScreen(),
    );
  }
}

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const WebIntroScreen();
    }

    return const HomeScreen();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/forest_harmony.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.55)),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📖', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text('Cultural Hub',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Write where your heart feels',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                    ),
                  ),
                  const SizedBox(height: 48),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WritingScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white38),
                      ),
                      child: const Text('Start Writing',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BooksScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white38),
                      ),
                      child: const Text('Browse Books',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WebIntroScreen extends StatelessWidget {
  const WebIntroScreen({super.key});

  static const _backgroundUrl =
      'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?auto=format&fit=crop&w=1600&q=80';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            _backgroundUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF241A12), Color(0xFF493225), Color(0xFF0E0B08)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.18),
                  Colors.black.withOpacity(0.52),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white.withOpacity(0.18)),
                        ),
                        child: const Center(
                          child: Text('📚', style: TextStyle(fontSize: 42)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Cultural Hub',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bridging Minds, Crafting Culture',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white.withOpacity(0.16)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.22),
                              blurRadius: 30,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Text(
                          'Where Stories, Knowledge, and Culture Come Alive.\n\n'
                          'We’re thrilled to have you join a vibrant community of authors, educators, historians, and creators dedicated to shaping culturally significant content. Together, we’re building bridges across time, sharing diverse perspectives, and preserving the essence of our shared heritage. With AI-driven tools, we’re taking creativity and collaboration to the next level. Whether you’re here to tell a story, contribute your expertise, or collaborate on educational resources, this is your space to co-create, connect, and inspire.\n\n'
                          'Let’s make history together - one story at a time.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Colors.white.withOpacity(0.95),
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const WritingScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3047C9),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                'Writing',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const BooksScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.14),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                side: BorderSide(color: Colors.white.withOpacity(0.35)),
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                'Browse Books',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}