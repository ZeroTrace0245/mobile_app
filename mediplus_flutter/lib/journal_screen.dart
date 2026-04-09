import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'ai_service.dart';
import 'database_helper.dart';

class JournalEntry {
  final int id;
  final String title;
  final String content;
  final String mood;
  final DateTime date;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.date,
  });
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<JournalEntry> _entries = [];
  bool _showEditor = false;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await _db.getJournalEntries();
    setState(() {
      _entries = entries;
    });
  }

  void _addEntry(String title, String content, String mood) async {
    final entry = JournalEntry(
      id: 0,
      title: title,
      content: content,
      mood: mood,
      date: DateTime.now(),
    );
    await _db.insertJournalEntry(entry);
    _loadEntries();
    setState(() => _showEditor = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showEditor) {
      return JournalEntryEditor(
        onSave: _addEntry,
        onCancel: () => setState(() => _showEditor = false),
      );
    }

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
                    "Journal",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0),
                  const Text(
                    "Record your journey",
                    style: TextStyle(color: Colors.white60, fontSize: 16),
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _ReflectionPromptCard(onTap: () => setState(() => _showEditor = true)),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                "Recent Thoughts",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          if (_entries.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyJournalState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _JournalEntryCard(entry: _entries[index]),
                  childCount: _entries.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _showEditor = true),
        backgroundColor: const Color(0xFF40C4FF),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ReflectionPromptCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ReflectionPromptCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF40C4FF).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF40C4FF).withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daily Reflection",
              style: TextStyle(color: Color(0xFF40C4FF), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "What is one thing you are grateful for today?",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Tap to write your response",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;
  const _JournalEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEEE, MMM d').format(entry.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
              _MoodEmoji(mood: entry.mood),
            ],
          ),
          const Divider(height: 32, color: Colors.white10),
          Text(
            entry.content,
            style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          if (settingsController.aiEnabled) ...[
            const SizedBox(height: 16),
            _AiAnalysisButton(content: entry.content),
          ],
        ],
      ),
    );
  }
}

class _AiAnalysisButton extends StatefulWidget {
  final String content;
  const _AiAnalysisButton({required this.content});

  @override
  State<_AiAnalysisButton> createState() => _AiAnalysisButtonState();
}

class _AiAnalysisButtonState extends State<_AiAnalysisButton> {
  bool _isLoading = false;
  String? _analysis;

  void _analyze() async {
    setState(() => _isLoading = true);
    try {
      final aiService = AiService();
      final response = await aiService.getCompletion([
        ChatMessage.textOnly('system', 'You are a wellness assistant. Analyze the following journal entry and provide a brief (1-2 sentence) supportive insight or suggestion.'),
        ChatMessage.textOnly('user', widget.content),
      ]);
      setState(() {
        _analysis = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _analysis = "Could not analyze at this time.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_analysis != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF40C4FF).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF40C4FF).withValues(alpha: 0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFF40C4FF), size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _analysis!,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ).animate().fadeIn();
    }

    return TextButton.icon(
      onPressed: _isLoading ? null : _analyze,
      icon: _isLoading
          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF40C4FF)))
          : const Icon(Icons.auto_awesome, size: 16, color: Color(0xFF40C4FF)),
      label: Text(
        _isLoading ? "Analyzing..." : "AI Analysis",
        style: const TextStyle(color: Color(0xFF40C4FF), fontSize: 13, fontWeight: FontWeight.bold),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _MoodEmoji extends StatelessWidget {
  final String mood;
  const _MoodEmoji({required this.mood});

  @override
  Widget build(BuildContext context) {
    String emoji = switch (mood) {
      "happy" => "😊",
      "good" => "🙂",
      "neutral" => "😐",
      "sad" => "😔",
      "very_sad" => "😢",
      _ => "😐",
    };

    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white10,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }
}

class _EmptyJournalState extends StatelessWidget {
  const _EmptyJournalState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 64, color: Colors.white24),
          const SizedBox(height: 16),
          const Text(
            "Your journey begins",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white54),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap the + button to write your first entry",
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class JournalEntryEditor extends StatefulWidget {
  final Function(String, String, String) onSave;
  final VoidCallback onCancel;
  const JournalEntryEditor({super.key, required this.onSave, required this.onCancel});

  @override
  State<JournalEntryEditor> createState() => _JournalEntryEditorState();
}

class _JournalEntryEditorState extends State<JournalEntryEditor> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedMood = "neutral";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "New Entry",
                    style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "How are you feeling?",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white60),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _moodButton("happy", "😊"),
                  _moodButton("good", "🙂"),
                  _moodButton("neutral", "😐"),
                  _moodButton("sad", "😔"),
                  _moodButton("very_sad", "😢"),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
                  decoration: const InputDecoration(
                    hintText: "Write your thoughts here...",
                    hintStyle: TextStyle(color: Colors.white24),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
                      widget.onSave(_titleController.text, _contentController.text, _selectedMood);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40C4FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Save Entry", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moodButton(String mood, String emoji) {
    final isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF40C4FF) : Colors.white10,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}
