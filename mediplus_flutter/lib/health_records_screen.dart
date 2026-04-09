import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data_models.dart';
import 'registration_screen.dart';

import 'database_helper.dart';

class HealthRecordsScreen extends StatefulWidget {
  final HealthRecord? initialProfile;
  final Function(HealthRecord) onProfileUpdated;
  const HealthRecordsScreen({super.key, this.initialProfile, required this.onProfileUpdated});

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<HealthRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final records = await _db.getHealthRecords();
    setState(() {
      if (records.isEmpty && widget.initialProfile != null) {
        _records = [widget.initialProfile!];
      } else {
        _records = records;
      }
    });
  }

  void _addFamilyMember() {
    if (_records.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maximum of 5 family members reached.")),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistrationScreen(
          initialName: "",
          onRegistrationComplete: (record) async {
            await _db.insertHealthRecord(record);
            _loadRecords();
            if (mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _editRecord(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistrationScreen(
          initialRecord: _records[index],
          onRegistrationComplete: (record) async {
            await _db.updateHealthRecord(record);
            _loadRecords();
            if (index == 0) {
              widget.onProfileUpdated(record);
            }
            if (mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _deleteRecord(int index) async {
    if (index == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot delete primary profile.")),
      );
      return;
    }
    await _db.deleteHealthRecord(_records[index].id);
    _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
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
                    "Health Profiles",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 8),
                  const Text(
                    "Manage your and your family's health information.",
                    style: TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _HealthProfileItem(
                  record: _records[index],
                  isPrimary: index == 0,
                  onEdit: () => _editRecord(index),
                  onDelete: () => _deleteRecord(index),
                ),
                childCount: _records.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addFamilyMember,
        backgroundColor: const Color(0xFF40C4FF),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.group_add),
        label: const Text("Add Family"),
      ),
    );
  }
}

class _HealthProfileItem extends StatelessWidget {
  final HealthRecord record;
  final bool isPrimary;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HealthProfileItem({
    required this.record,
    required this.isPrimary,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: isPrimary ? Border.all(color: const Color(0xFF40C4FF).withValues(alpha: 0.3)) : null,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isPrimary ? const Color(0xFF40C4FF) : Colors.white10,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPrimary ? Icons.person : Icons.family_restroom,
            color: isPrimary ? Colors.black : Colors.white70,
            size: 28,
          ),
        ),
        title: Row(
          children: [
            Text(
              record.personalInfo.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            if (isPrimary)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF40C4FF).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("YOU", style: TextStyle(color: Color(0xFF40C4FF), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        subtitle: Text(
          "${record.bloodType} • ${record.personalInfo.age} yrs",
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.white38), onPressed: onEdit),
            if (!isPrimary)
              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: onDelete),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                const Divider(color: Colors.white10),
                const SizedBox(height: 12),
                _DetailRow(label: "Allergies", value: record.allergies.isEmpty ? "None" : record.allergies.join(", ")),
                _DetailRow(label: "Conditions", value: record.medicalConditions.isEmpty ? "None" : record.medicalConditions.join(", ")),
                _DetailRow(label: "DOB", value: record.personalInfo.dateOfBirth),
                _DetailRow(label: "Phone", value: record.personalInfo.mobileNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF40C4FF)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
