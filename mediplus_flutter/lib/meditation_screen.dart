import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'main.dart';
import 'ai_service.dart';

class SessionItem {
  final String title;
  final String description;
  final int duration;
  final String icon;
  final List<String> steps;

  SessionItem(this.title, this.description, this.duration, this.icon, this.steps);
}

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = [
      SessionItem("Deep Breathing", "Calm your nervous system", 5, "💨", [
        "Find a comfortable seated position.",
        "Inhale slowly through your nose for 4 seconds.",
        "Hold your breath for 4 seconds.",
        "Exhale slowly through your mouth for 4 seconds.",
        "Repeat this cycle and focus on the air entering your lungs."
      ]),
      SessionItem("Morning Clarity", "Focused intent for your day", 10, "☀️", [
        "Close your eyes and take three deep breaths.",
        "Visualize your goals for today.",
        "Identify one thing you are truly grateful for.",
        "Set an intention to remain present and calm.",
        "Carry this clarity into your first task."
      ]),
      SessionItem("Stress Release", "Body scan and relaxation", 15, "🌿", [
        "Focus on your toes. Tense them, then release.",
        "Move your awareness up to your legs and hips. Relax.",
        "Notice any tension in your shoulders. Let it go.",
        "Unclench your jaw and soften your face.",
        "Feel the weight of your body being supported."
      ]),
      SessionItem("Sleep Guide", "Wind down for restful sleep", 20, "🌙", [
        "Lying down, place one hand on your belly.",
        "Feel your hand rise and fall with each breath.",
        "Imagine a peaceful place you love.",
        "Let every muscle in your body go limp.",
        "Count down slowly from 10 to 1."
      ]),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mental Resilience",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0),
                  const Text(
                    "Peace of mind starts here",
                    style: TextStyle(color: Colors.white60, fontSize: 16),
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _DailyInspirationCard(),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
          ),
          const SliverToBoxAdapter(
            child: _SectionHeader(title: "Calming Visuals"),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _CalmingVisualItem(
                    title: "Breathe",
                    colors: [const Color(0xFF40C4FF), const Color(0xFF00B0FF)],
                    isPulsing: true,
                    onTap: () => _navigateToVisual(context, "Breathe", [const Color(0xFF40C4FF), const Color(0xFF00B0FF)], true),
                  ),
                  _CalmingVisualItem(
                    title: "Ocean",
                    colors: [const Color(0xFF2196F3), const Color(0xFF00BCD4)],
                    onTap: () => _navigateToVisual(context, "Ocean", [const Color(0xFF2196F3), const Color(0xFF00BCD4)], false),
                  ),
                  _CalmingVisualItem(
                    title: "Forest",
                    colors: [const Color(0xFF4CAF50), const Color(0xFF8BC34A)],
                    onTap: () => _navigateToVisual(context, "Forest", [const Color(0xFF4CAF50), const Color(0xFF8BC34A)], false),
                  ),
                  _CalmingVisualItem(
                    title: "Sunset",
                    colors: [const Color(0xFFFF5722), const Color(0xFFFFC107)],
                    onTap: () => _navigateToVisual(context, "Sunset", [const Color(0xFFFF5722), const Color(0xFFFFC107)], false),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms),
          ),
          const SliverToBoxAdapter(
            child: _SectionHeader(title: "Guided Sessions"),
          ),
          if (settingsController.aiEnabled)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _AiMeditationCard(),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _SessionCard(
                  session: sessions[index],
                  onTap: () => _navigateToSession(context, sessions[index]),
                ),
                childCount: sessions.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToVisual(BuildContext context, String title, List<Color> colors, bool isPulsing) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullVisualScreen(title: title, colors: colors, isPulsing: isPulsing),
      ),
    );
  }

  void _navigateToSession(BuildContext context, SessionItem session) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GuidedSessionPlayer(session: session),
      ),
    );
  }
}

class FullVisualScreen extends StatelessWidget {
  final String title;
  final List<Color> colors;
  final bool isPulsing;

  const FullVisualScreen({super.key, required this.title, required this.colors, required this.isPulsing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: isPulsing
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _PulsingCircle(size: 200),
                        const SizedBox(height: 48),
                        Text(
                          "Focus on your breath",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w200,
                          ),
                        ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 2.seconds),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(backgroundColor: Colors.black26),
            ),
          ),
          Positioned(
            top: 65,
            right: 20,
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GuidedSessionPlayer extends StatefulWidget {
  final SessionItem session;
  const GuidedSessionPlayer({super.key, required this.session});

  @override
  State<GuidedSessionPlayer> createState() => _GuidedSessionPlayerState();
}

class _GuidedSessionPlayerState extends State<GuidedSessionPlayer> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.session.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF40C4FF).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.session.icon,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2.seconds),
            const SizedBox(height: 64),
            SizedBox(
              height: 200,
              child: AnimatedSwitcher(
                duration: 500.ms,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  key: ValueKey<int>(_currentStep),
                  children: [
                    Text(
                      "Step ${_currentStep + 1} of ${widget.session.steps.length}",
                      style: const TextStyle(color: Color(0xFF40C4FF), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.session.steps[_currentStep],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 22,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  TextButton(
                    onPressed: () => setState(() => _currentStep--),
                    child: const Text("Previous", style: TextStyle(color: Colors.white54)),
                  )
                else
                  const SizedBox(width: 80),
                ElevatedButton(
                  onPressed: () {
                    if (_currentStep < widget.session.steps.length - 1) {
                      setState(() => _currentStep++);
                    } else {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Session completed. Feel the peace.")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40C4FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(_currentStep < widget.session.steps.length - 1 ? "Next Step" : "Finish"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AiMeditationCard extends StatefulWidget {
  @override
  State<_AiMeditationCard> createState() => _AiMeditationCardState();
}

class _AiMeditationCardState extends State<_AiMeditationCard> {
  bool _isGenerating = false;

  void _generateSession() async {
    setState(() => _isGenerating = true);
    try {
      final aiService = AiService();
      final response = await aiService.getCompletion([
        ChatMessage.textOnly('system', 'You are a meditation guide. Generate a 5-step personalized meditation session. Format the output as a JSON list of strings only.'),
        ChatMessage.textOnly('user', 'I am feeling a bit stressed today.'),
      ]);

      // Clean up response if it has markdown or extra text
      String cleaned = response.replaceAll('```json', '').replaceAll('```', '').trim();
      List<String> steps;
      try {
        final decoded = List<dynamic>.from(json.decode(cleaned));
        steps = decoded.map((e) => e.toString()).toList();
      } catch (e) {
        // Fallback if parsing fails
        steps = [
          "Take a deep breath and close your eyes.",
          "Feel the weight of your body on the chair.",
          "Listen to the sounds around you without judgment.",
          "Visualize a calm blue light surrounding you.",
          "Gently open your eyes when you feel ready."
        ];
      }

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GuidedSessionPlayer(
              session: SessionItem("AI Personalized", "Custom session generated for you", 5, "✨", steps),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to generate AI session.")));
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isGenerating ? null : _generateSession,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF40C4FF), Color(0xFF00B0FF)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: const Color(0xFF40C4FF).withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 1),
          ],
        ),
        child: Row(
          children: [
            _isGenerating
                ? const SizedBox(width: 32, height: 32, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                : const Icon(Icons.auto_awesome, color: Colors.black, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("AI Personalized Session", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(
                    _isGenerating ? "Creating your journey..." : "Generate a custom meditation based on your current state",
                    style: const TextStyle(color: Colors.black87, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class _DailyInspirationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF40C4FF).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Inspiration",
            style: TextStyle(color: Color(0xFF40C4FF), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            "\"The best way to capture moments is to pay attention. This is how we cultivate mindfulness.\"",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              "— Jon Kabat-Zinn",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalmingVisualItem extends StatelessWidget {
  final String title;
  final List<Color> colors;
  final bool isPulsing;
  final VoidCallback onTap;

  const _CalmingVisualItem({required this.title, required this.colors, this.isPulsing = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: isPulsing ? const _PulsingCircle(size: 40) : null,
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _PulsingCircle extends StatelessWidget {
  final double size;
  const _PulsingCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .scale(begin: const Offset(0.6, 0.6), end: const Offset(1.0, 1.0), duration: 4.seconds, curve: Curves.easeInOut);
  }
}

class _SessionCard extends StatelessWidget {
  final SessionItem session;
  final VoidCallback onTap;
  const _SessionCard({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(session.icon, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(session.description, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.timer, color: Color(0xFF40C4FF), size: 16),
                const SizedBox(width: 4),
                Text(
                  "${session.duration}m",
                  style: const TextStyle(color: Color(0xFF40C4FF), fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
