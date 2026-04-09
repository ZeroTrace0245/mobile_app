import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        title: Text("Privacy & Security", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section("Your Privacy Matters", "At MediPlus, we believe your medical data should be private and secure. This screen explains how your data is handled."),
            _section("Local Storage", "All your health records, family profiles, journals, and medication lists are stored ONLY on your device using a local database. We do not upload your personal medical information to any cloud server."),
            _section("Biometric Protection", "We offer optional Biometric (Fingerprint/FaceID) protection. When enabled, your data is only accessible after successful authentication. This authentication is handled by your device's operating system."),
            _section("AI Features", "Our AI features use industry-standard models to provide insights. When you use AI chat or analysis, only the specific text or image you provide is sent to the AI service. No identifiable profile information is shared unless you explicitly include it in your prompts."),
            _section("Data Ownership", "You own your data. You can delete your profile, journals, or any other information at any time from within the app. Uninstalling the app will remove all locally stored data permanently."),
            const SizedBox(height: 48),
            Center(
              child: Text("MediPlus Version 1.0.0", style: TextStyle(color: Colors.white24, fontSize: 12)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF40C4FF), fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }
}
