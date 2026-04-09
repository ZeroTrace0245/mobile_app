import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'data_models.dart';
import 'database_helper.dart';
import 'ai_service.dart';
import 'main.dart';

class MedicationTrackerScreen extends StatefulWidget {
  const MedicationTrackerScreen({super.key});

  @override
  State<MedicationTrackerScreen> createState() => _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Medication> _medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    final meds = await _db.getMedications();
    setState(() {
      _medications = meds;
      _isLoading = false;
    });
  }

  void _addMedication() {
    _showMedDialog();
  }

  void _toggleTaken(Medication med) async {
    final updated = Medication(
      id: med.id,
      name: med.name,
      dosage: med.dosage,
      frequency: med.frequency,
      time: med.time,
      isTaken: !med.isTaken,
    );
    await _db.updateMedication(updated);
    _loadMedications();
  }

  void _deleteMed(int id) async {
    await _db.deleteMedication(id);
    _loadMedications();
  }

  void _showMedDialog({Medication? med}) {
    final nameController = TextEditingController(text: med?.name);
    final dosageController = TextEditingController(text: med?.dosage);
    final frequencyController = TextEditingController(text: med?.frequency);
    final timeController = TextEditingController(text: med?.time);
    final aiPromptController = TextEditingController();
    bool isAiLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1C1B1F),
          title: Text(med == null ? "Add Medication" : "Edit Medication", style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (med == null && settingsController.aiEnabled) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF40C4FF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF40C4FF).withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome, size: 16, color: Color(0xFF40C4FF)),
                            SizedBox(width: 8),
                            Text("AI Quick Fill", style: TextStyle(color: Color(0xFF40C4FF), fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                        TextField(
                          controller: aiPromptController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: "e.g. 'i took 2 cettracing'",
                            hintStyle: TextStyle(color: Colors.white24),
                            border: InputBorder.none,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: isAiLoading ? null : () async {
                              if (aiPromptController.text.isEmpty) return;
                              setDialogState(() => isAiLoading = true);
                              try {
                                final aiService = AiService();
                                final response = await aiService.getCompletion([
                                  ChatMessage.textOnly('system', 'You are a medical assistant. Parse the user prompt and extract the medication name and the most likely common dosage. Format your response as a valid JSON object with keys "name" and "dosage" only. No other text.'),
                                  ChatMessage.textOnly('user', aiPromptController.text),
                                ]);
                                // Extract JSON from response
                                String jsonStr = response.replaceAll('```json', '').replaceAll('```', '').trim();
                                final data = Map<String, dynamic>.from(json.decode(jsonStr));
                                setDialogState(() {
                                  nameController.text = data['name'] ?? "";
                                  dosageController.text = data['dosage'] ?? "";
                                  isAiLoading = false;
                                });
                              } catch (e) {
                                setDialogState(() => isAiLoading = false);
                              }
                            },
                            child: Text(isAiLoading ? "Parsing..." : "Fill with AI"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Medication Name", labelStyle: TextStyle(color: Colors.white60))),
                TextField(controller: dosageController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Dosage (e.g. 500mg)", labelStyle: TextStyle(color: Colors.white60))),
                TextField(controller: frequencyController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Frequency (e.g. Twice Daily)", labelStyle: TextStyle(color: Colors.white60))),
                TextField(controller: timeController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Time (e.g. 08:00 AM)", labelStyle: TextStyle(color: Colors.white60))),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) return;
                final newMed = Medication(
                  id: med?.id ?? 0,
                  name: nameController.text,
                  dosage: dosageController.text,
                  frequency: frequencyController.text,
                  time: timeController.text,
                  isTaken: med?.isTaken ?? false,
                );
                if (med == null) {
                  await _db.insertMedication(newMed);
                } else {
                  await _db.updateMedication(newMed);
                }
                _loadMedications();
                if (mounted) Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        title: Text("Medication Tracker", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (settingsController.aiEnabled && _medications.isNotEmpty)
                  _AiMedicationAnalysis(meds: _medications),
                Expanded(
                  child: _medications.isEmpty
                      ? const Center(child: Text("No medications added yet.", style: TextStyle(color: Colors.white54)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _medications.length,
                          itemBuilder: (context, index) {
                            final med = _medications[index];
                            return _MedicationTile(
                              med: med,
                              onToggle: () => _toggleTaken(med),
                              onDelete: () => _deleteMed(med.id),
                              onEdit: () => _showMedDialog(med: med),
                            ).animate().fadeIn(delay: (index * 100).ms).slideX();
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMedication,
        backgroundColor: const Color(0xFF40C4FF),
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MedicationTile extends StatelessWidget {
  final Medication med;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _MedicationTile({required this.med, required this.onToggle, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: med.isTaken ? Border.all(color: Colors.green.withValues(alpha: 0.3)) : null,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              med.isTaken ? Icons.check_circle : Icons.radio_button_unchecked,
              color: med.isTaken ? Colors.green : Colors.white38,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text("${med.dosage} • ${med.frequency}", style: const TextStyle(color: Colors.white54, fontSize: 14)),
                Text(med.time, style: const TextStyle(color: Color(0xFF40C4FF), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, color: Colors.white24, size: 20)),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)),
        ],
      ),
    );
  }
}

class _AiMedicationAnalysis extends StatefulWidget {
  final List<Medication> meds;
  const _AiMedicationAnalysis({required this.meds});

  @override
  State<_AiMedicationAnalysis> createState() => _AiMedicationAnalysisState();
}

class _AiMedicationAnalysisState extends State<_AiMedicationAnalysis> {
  String? _analysis;
  bool _isAnalyzing = false;

  void _analyze() async {
    setState(() => _isAnalyzing = true);
    try {
      final aiService = AiService();
      final medList = widget.meds.map((m) => "${m.name} (${m.dosage}, ${m.frequency})").join(', ');
      final response = await aiService.getCompletion([
        ChatMessage.textOnly('system', 'You are a medical assistant. Analyze the following list of medications for potential interactions or general wellness advice. Keep it to 2-3 sentences and always advise consulting a doctor.'),
        ChatMessage.textOnly('user', medList),
      ]);
      setState(() {
        _analysis = response;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _analysis = "Unable to analyze interactions at this time.";
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF40C4FF).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF40C4FF).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF40C4FF), size: 20),
              const SizedBox(width: 12),
              const Text("AI Med Interaction Check", style: TextStyle(color: Color(0xFF40C4FF), fontWeight: FontWeight.bold)),
              const Spacer(),
              if (_analysis == null)
                TextButton(
                  onPressed: _isAnalyzing ? null : _analyze,
                  child: Text(_isAnalyzing ? "Checking..." : "Analyze"),
                ),
            ],
          ),
          if (_analysis != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_analysis!, style: const TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic)),
            ),
        ],
      ),
    );
  }
}
