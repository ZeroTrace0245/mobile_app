import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  Map<String, int> _moodCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final entries = await _db.getJournalEntries();
    Map<String, int> counts = {
      'happy': 0,
      'good': 0,
      'neutral': 0,
      'sad': 0,
      'very_sad': 0,
    };
    for (var entry in entries) {
      if (counts.containsKey(entry.mood)) {
        counts[entry.mood] = counts[entry.mood]! + 1;
      }
    }
    setState(() {
      _moodCounts = counts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        title: Text("Health Analytics", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mood Trends", style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text("Based on your recent journal entries", style: TextStyle(color: Colors.white54)),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sections: _buildPieSections(),
                        centerSpaceRadius: 60,
                        sectionsSpace: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildLegend(),
                ],
              ),
            ),
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    final total = _moodCounts.values.fold(0, (sum, val) => sum + val);
    if (total == 0) return [];

    return [
      PieChartSectionData(value: _moodCounts['happy']!.toDouble(), color: Colors.greenAccent, title: 'Happy', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      PieChartSectionData(value: _moodCounts['good']!.toDouble(), color: Colors.lightGreen, title: 'Good', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      PieChartSectionData(value: _moodCounts['neutral']!.toDouble(), color: Colors.blueAccent, title: 'Neutral', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      PieChartSectionData(value: _moodCounts['sad']!.toDouble(), color: Colors.orangeAccent, title: 'Sad', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      PieChartSectionData(value: _moodCounts['very_sad']!.toDouble(), color: Colors.redAccent, title: 'Very Sad', radius: 50, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    ].where((section) => section.value > 0).toList();
  }

  Widget _buildLegend() {
    return Column(
      children: [
        _legendItem("Happy", Colors.greenAccent, "😊"),
        _legendItem("Good", Colors.lightGreen, "🙂"),
        _legendItem("Neutral", Colors.blueAccent, "😐"),
        _legendItem("Sad", Colors.orangeAccent, "😔"),
        _legendItem("Very Sad", Colors.redAccent, "😢"),
      ],
    );
  }

  Widget _legendItem(String label, Color color, String emoji) {
    final count = _moodCounts[label.toLowerCase().replaceAll(' ', '_')] ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          const Spacer(),
          Text("$count entries", style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }
}
