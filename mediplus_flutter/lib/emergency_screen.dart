import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'data_models.dart';

class EmergencyScreen extends StatefulWidget {
  final HealthRecord? record;
  const EmergencyScreen({super.key, this.record});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  late List<EmergencyContact> _contacts;

  @override
  void initState() {
    super.initState();
    final initialRecord = widget.record ?? MockData.getMockProfile();
    _contacts = [initialRecord.emergencyContact];
  }

  void _addContact() {
    _showContactDialog();
  }

  void _editContact(int index) {
    _showContactDialog(contact: _contacts[index], index: index);
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  void _showContactDialog({EmergencyContact? contact, int? index}) {
    final nameController = TextEditingController(text: contact?.name);
    final relationController = TextEditingController(text: contact?.relationship);
    final phoneController = TextEditingController(text: contact?.phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1B1F),
        title: Text(contact == null ? "Add Contact" : "Edit Contact", style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Name", labelStyle: TextStyle(color: Colors.white60))),
            TextField(controller: relationController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Relationship", labelStyle: TextStyle(color: Colors.white60))),
            TextField(controller: phoneController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Phone", labelStyle: TextStyle(color: Colors.white60))),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final newContact = EmergencyContact(
                name: nameController.text,
                relationship: relationController.text,
                phone: phoneController.text,
              );
              setState(() {
                if (index == null) {
                  _contacts.add(newContact);
                } else {
                  _contacts[index] = newContact;
                }
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayRecord = widget.record ?? MockData.getMockProfile();
    final qrData = "NAME: ${displayRecord.personalInfo.name}, BLOOD: ${displayRecord.bloodType}, ALLERGIES: ${displayRecord.allergies.join(', ')}, CONTACTS: ${_contacts.map((c) => "${c.name} (${c.phone})").join('; ')}";

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        title: Text("Emergency Access", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.emergency, color: Colors.red, size: 64),
            const SizedBox(height: 24),
            Text(
              "Medical ID Quick Access",
              style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Show this to emergency responders for critical health info.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250.0,
              ),
            ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
            const SizedBox(height: 48),
            _buildCriticalInfoTile("Blood Type", displayRecord.bloodType, Icons.bloodtype),
            _buildCriticalInfoTile("Allergies", displayRecord.allergies.join(', '), Icons.warning),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Emergency Contacts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                IconButton(onPressed: _addContact, icon: const Icon(Icons.add_circle, color: Color(0xFF40C4FF))),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(_contacts.length, (index) {
              final contact = _contacts[index];
              return _buildContactTile(contact, index);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCriticalInfoTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white60, fontSize: 12)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(EmergencyContact contact, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.contact_phone, color: Color(0xFF40C4FF)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("${contact.relationship} • ${contact.phone}", style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          IconButton(onPressed: () => _editContact(index), icon: const Icon(Icons.edit, size: 20, color: Colors.white38)),
          IconButton(onPressed: () => _deleteContact(index), icon: Icon(Icons.delete, size: 20, color: Colors.redAccent.withValues(alpha: 0.5))),
        ],
      ),
    );
  }
}
