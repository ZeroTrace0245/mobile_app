import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SessionItem {
  final String title;
  final String description;
  final int duration;
  final String icon;

  SessionItem(this.title, this.description, this.duration, this.icon);
}

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = [
      SessionItem("Deep Breathing", "Calm your nervous system", 5, "💨"),
      SessionItem("Morning Clarity", "Focused intent for your day", 10, "☀️"),
      SessionItem("Stress Release", "Body scan and relaxation", 15, "🌿"),
      SessionItem("Sleep Guide", "Wind down for restful sleep", 20, "🌙"),
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
                  _CalmingVisualItem(title: "Breathe", colors: [Color(0xFF40C4FF), Color(0xFF00B0FF)], isPulsing: true),
                  _CalmingVisualItem(title: "Ocean", colors: [Color(0xFF2196F3), Color(0xFF00BCD4)]),
                  _CalmingVisualItem(title: "Forest", colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)]),
                  _CalmingVisualItem(title: "Sunset", colors: [Color(0xFFFF5722), Color(0xFFFFC107)]),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms),
          ),
          const SliverToBoxAdapter(
            child: _SectionHeader(title: "Guided Sessions"),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _SessionCard(session: sessions[index]),
                childCount: sessions.length,
              ),
            ),
          ),
        ],
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

  const _CalmingVisualItem({required this.title, required this.colors, this.isPulsing = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            child: isPulsing ? _PulsingCircle() : null,
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PulsingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .scale(begin: const Offset(0.6, 0.6), end: const Offset(1.0, 1.0), duration: 2.seconds, curve: Curves.easeInOut);
  }
}

class _SessionCard extends StatelessWidget {
  final SessionItem session;
  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
