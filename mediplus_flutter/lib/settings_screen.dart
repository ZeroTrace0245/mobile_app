import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'privacy_screen.dart';
import 'analytics_screen.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onLogout;
  const SettingsScreen({super.key, required this.onLogout});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    settingsController.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    settingsController.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      0xFF1E3C72, // Default Blue
      0xFF1B5E20, // Green
      0xFFB71C1C, // Red
      0xFF4A148C, // Purple
      0xFFE65100, // Orange
      0xFF263238, // Grey/Dark
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        title: Text("Settings", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _SettingsSection(
              title: "Health & Analytics",
              icon: Icons.analytics_outlined,
              children: [
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AnalyticsScreen())),
                  icon: const Icon(Icons.pie_chart, size: 18),
                  label: const Text("View Mood Analytics"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF40C4FF),
                    side: const BorderSide(color: Color(0xFF40C4FF)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SettingsSection(
              title: "AI Features",
              icon: Icons.auto_awesome,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Enable MediPlus AI", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text("Dashboard tips and healthy living chat", style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Switch(
                      value: settingsController.aiEnabled,
                      onChanged: (val) => settingsController.setAiEnabled(val),
                      activeTrackColor: const Color(0xFF40C4FF),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _showTokenDialog,
                  icon: const Icon(Icons.key, size: 18),
                  label: Text(settingsController.githubToken.isEmpty ? "Set GitHub Token" : "Update GitHub Token"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF40C4FF),
                    side: const BorderSide(color: Color(0xFF40C4FF)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            /* _SettingsSection(
              title: "Security",
              icon: Icons.security,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Biometric Authentication", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          Text("Fingerprint or FaceID on startup", style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Switch(
                      value: settingsController.biometricsEnabled,
                      onChanged: (val) => settingsController.setBiometricsEnabled(val),
                      activeTrackColor: const Color(0xFF40C4FF),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24), */
            _SettingsSection(
              title: "Customization",
              icon: Icons.palette,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Always Show Navigation Bar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text("If disabled, swipe up from bottom to show", style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Switch(
                      value: settingsController.alwaysShowNav,
                      onChanged: (val) => settingsController.setAlwaysShowNav(val),
                      activeTrackColor: const Color(0xFF40C4FF),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text("Medical ID Card Color", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      final color = colors[index];
                      final isSelected = settingsController.cardColor == color;
                      return GestureDetector(
                        onTap: () => settingsController.setCardColor(color),
                        child: Container(
                          width: 48,
                          height: 48,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Color(color),
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: const Color(0xFF40C4FF), width: 3) : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SettingsSection(
              title: "Privacy",
              icon: Icons.shield,
              children: [
                const Text("Permissions", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                const Text(
                  "You can manage camera and NFC permissions in your system settings. MediPlus only uses these when you explicitly trigger a scan or export.",
                  style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.5),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen())),
                  child: const Text("Read Privacy Policy", style: TextStyle(color: Color(0xFF40C4FF))),
                ),
              ],
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: widget.onLogout,
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                foregroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showTokenDialog() {
    final controller = TextEditingController(text: settingsController.githubToken);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1B1F),
        title: const Text("Set GitHub Token", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter your GitHub PAT",
            hintStyle: TextStyle(color: Colors.white24),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              settingsController.setGithubToken(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF40C4FF), size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(color: Color(0xFF40C4FF), fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
