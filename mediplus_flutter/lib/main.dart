import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'ai_chat_screen.dart';
import 'emergency_screen.dart';
import 'data_models.dart';
import 'journal_screen.dart';
import 'meditation_screen.dart';
import 'settings_screen.dart';
import 'health_records_screen.dart';
import 'calendar_screen.dart';
import 'camera_scan_screen.dart';
import 'ai_service.dart';
import 'settings_controller.dart';
import 'registration_screen.dart';
import 'medication_screen.dart';
import 'database_helper.dart';

final settingsController = SettingsController();
final LocalAuthentication auth = LocalAuthentication();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MediPlusApp());
}

class MediPlusApp extends StatefulWidget {
  const MediPlusApp({super.key});

  @override
  State<MediPlusApp> createState() => _MediPlusAppState();
}

class _MediPlusAppState extends State<MediPlusApp> {
  String? _userName;
  HealthRecord? _userProfile;
  bool _isAuthenticated = false;
  String? _tempName;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    settingsController.addListener(_onSettingsChanged);
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final prefs = await SharedPreferences.getInstance();
    final useBiometrics = prefs.getBool('biometrics_enabled') ?? false;

    if (useBiometrics) {
      try {
        final authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to access your medical records',
          options: const AuthenticationOptions(stickyAuth: true),
        );
        setState(() => _isAuthenticated = authenticated);
      } catch (e) {
        setState(() => _isAuthenticated = true); // Fallback
      }
    } else {
      setState(() => _isAuthenticated = true);
    }

    final db = DatabaseHelper();
    final records = await db.getHealthRecords();
    if (records.isNotEmpty) {
      setState(() {
        _userProfile = records[0];
        _userName = records[0].personalInfo.name;
      });
    }
  }

  @override
  void dispose() {
    settingsController.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() => setState(() {});

  void _onLoginComplete(String name) {
    setState(() {
      _tempName = name;
      _isRegistering = true;
    });
  }

  void _onRegistrationComplete(HealthRecord record) async {
    final db = DatabaseHelper();
    await db.insertHealthRecord(record);
    setState(() {
      _userName = record.personalInfo.name;
      _userProfile = record;
      _isRegistering = false;
    });
  }

  void _onDebugLogin() {
    setState(() {
      final mock = MockData.getMockProfile();
      _userName = mock.personalInfo.name;
      _userProfile = mock;
      _isRegistering = false;
    });
  }

  void _onLogout() {
    setState(() {
      _userName = null;
      _userProfile = null;
      _isRegistering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF40C4FF)))),
      );
    }

    Widget home;
    if (_isRegistering) {
      home = RegistrationScreen(
        initialName: _tempName,
        onRegistrationComplete: _onRegistrationComplete,
      );
    } else if (_userName == null) {
      home = LoginScreen(
        onLoginComplete: _onLoginComplete,
        onDebugLogin: _onDebugLogin,
      );
    } else {
      home = MainNavigation(
        userName: _userName!,
        userProfile: _userProfile,
        onLogout: _onLogout,
        onProfileUpdated: (newProfile) {
          setState(() {
            _userProfile = newProfile;
            _userName = newProfile.personalInfo.name;
          });
        },
      );
    }

    return MaterialApp(
      title: 'MediPlus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF40C4FF),
          brightness: Brightness.dark,
          surface: const Color(0xFF1C1B1F),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
        ),
      ),
      home: AnimatedSwitcher(duration: 500.ms, child: home),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final Function(String) onLoginComplete;
  final VoidCallback onDebugLogin;
  const LoginScreen({super.key, required this.onLoginComplete, required this.onDebugLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoggingIn) {
      return Windows11Greeting(
        userName: _nameController.text,
        onAnimationComplete: () => widget.onLoginComplete(_nameController.text),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A242F), Color(0xFF1C1B1F)],
          ),
        ),
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const AppLogo(),
            const SizedBox(height: 24),
            Text("Welcome", style: GoogleFonts.plusJakartaSans(fontSize: 40, fontWeight: FontWeight.w800, color: const Color(0xFF40C4FF))),
            const SizedBox(height: 8),
            const Text("Enter your name to begin your wellness journey", textAlign: TextAlign.center, style: TextStyle(color: Colors.white60, fontSize: 16)),
            const SizedBox(height: 48),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Your Name",
                labelStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () { if (_nameController.text.isNotEmpty) setState(() => _isLoggingIn = true); },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF40C4FF), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text("Get Started", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: widget.onDebugLogin, child: const Text("DEBUG: Skip \u0026 Fill Mock Data", style: TextStyle(color: Color(0xFF40C4FF)))),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class Windows11Greeting extends StatefulWidget {
  final String userName;
  final VoidCallback onAnimationComplete;
  const Windows11Greeting({super.key, required this.userName, required this.onAnimationComplete});

  @override
  State<Windows11Greeting> createState() => _Windows11GreetingState();
}

class _Windows11GreetingState extends State<Windows11Greeting> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) widget.onAnimationComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(size: 60),
            const SizedBox(height: 32),
            Text("Hello, ${widget.userName}", style: GoogleFonts.plusJakartaSans(fontSize: 48, fontWeight: FontWeight.w200, color: Colors.white)),
            const SizedBox(height: 8),
            const Text("welcome back", style: TextStyle(color: Colors.white54, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final String userName;
  final HealthRecord? userProfile;
  final VoidCallback onLogout;
  final Function(HealthRecord) onProfileUpdated;
  const MainNavigation({super.key, required this.userName, this.userProfile, required this.onLogout, required this.onProfileUpdated});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _showCamera = false;
  late AnimationController _navAnimationController;
  late Animation<Offset> _navSlideAnimation;

  @override
  void initState() {
    super.initState();
    _navAnimationController = AnimationController(vsync: this, duration: 300.ms);
    _navSlideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(parent: _navAnimationController, curve: Curves.easeOut));
    if (settingsController.alwaysShowNav) _navAnimationController.value = 1.0;
    settingsController.addListener(_updateNavVisibility);
  }

  @override
  void dispose() {
    settingsController.removeListener(_updateNavVisibility);
    _navAnimationController.dispose();
    super.dispose();
  }

  void _updateNavVisibility() {
    settingsController.alwaysShowNav ? _navAnimationController.forward() : _navAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (_showCamera) return CameraScanScreen(aiService: AiService(), onBack: () => setState(() => _showCamera = false));

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _navSlideAnimation,
            builder: (context, child) => Padding(padding: EdgeInsets.only(bottom: (1 - _navSlideAnimation.value.dy) * 80), child: child),
            child: IndexedStack(
              index: _currentIndex,
              children: [
                HomeScreen(userName: widget.userName, userProfile: widget.userProfile, onLaunchCamera: () => setState(() => _showCamera = true)),
                const CalendarScreen(),
                HealthRecordsScreen(initialProfile: widget.userProfile, onProfileUpdated: widget.onProfileUpdated),
                const MeditationScreen(),
                const JournalScreen(),
                SettingsScreen(onLogout: widget.onLogout),
              ],
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: SlideTransition(
              position: _navSlideAnimation,
              child: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) async {
                  if (index == 4 || index == 2) { // Journal or Health protected
                    bool auth = await authenticateSection(context);
                    if (auth) setState(() => _currentIndex = index);
                  } else {
                    setState(() => _currentIndex = index);
                  }
                },
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: "Home"),
                  NavigationDestination(icon: Icon(Icons.calendar_month), label: "Calendar"),
                  NavigationDestination(icon: Icon(Icons.medical_services), label: "Health"),
                  NavigationDestination(icon: Icon(Icons.favorite_border), label: "Meditate"),
                  NavigationDestination(icon: Icon(Icons.notes), label: "Journal"),
                  NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
                ],
              ),
            ),
          ),
          if (!settingsController.alwaysShowNav)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (d) {
                  if (d.delta.dy < -10) {
                    _navAnimationController.forward();
                  } else if (d.delta.dy > 10) {
                    _navAnimationController.reverse();
                  }
                },
                child: Container(height: 20, color: Colors.transparent),
              ),
            ),
        ],
      ),
    );
  }
}

Future<bool> authenticateSection(BuildContext context) async {
  if (settingsController.biometricsEnabled) {
    try {
      return await auth.authenticate(localizedReason: 'Authenticate to access private health data', options: const AuthenticationOptions(stickyAuth: true));
    } catch (e) { return true; }
  }
  return true;
}

class HomeScreen extends StatelessWidget {
  final String userName;
  final HealthRecord? userProfile;
  final VoidCallback onLaunchCamera;
  HomeScreen({super.key, required this.userName, this.userProfile, required this.onLaunchCamera});

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final record = userProfile ?? MockData.getMockProfile();
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, $userName", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text("Stay prepared and mindful today.", style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 32),
            if (settingsController.aiEnabled) ...[_buildAiHubCard(context), const SizedBox(height: 24), _buildAiInsightsCard(), const SizedBox(height: 24)],
            GestureDetector(
              onTap: () async {
                final canProceed = await authenticateSection(context);
                if (canProceed && context.mounted) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) => EmergencyScreen(record: userProfile)));
                }
              },
              child: _buildEmergencyCard().animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 1200.ms, curve: Curves.easeInOut),
            ),
            const SizedBox(height: 24),
            _buildMedicationsCard(context),
            const SizedBox(height: 24),
            Screenshot(controller: _screenshotController, child: _buildMedicalIDCard(record)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _exportButton(Icons.image, "PNG", () => _exportAsPNG(context)),
                _exportButton(Icons.nfc, "NFC", () => _exportToNFC(context, record)),
                _exportButton(Icons.picture_as_pdf, "PDF", () => _exportAsPDF(record)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _exportButton(IconData icon, String label, VoidCallback onTap) {
    return Column(children: [IconButton(onPressed: onTap, icon: Icon(icon, color: const Color(0xFF40C4FF)), style: IconButton.styleFrom(backgroundColor: Colors.white10)), Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10))]);
  }

  Future<void> _exportAsPNG(BuildContext context) async {
    final image = await _screenshotController.capture();
    if (image != null) {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/medical_id.png';
      await File(path).writeAsBytes(image);
      if (context.mounted) await Share.shareXFiles([XFile(path)], text: 'My Medical ID');
    }
  }

  Future<void> _exportToNFC(BuildContext context, HealthRecord record) async {
    if (!await NfcManager.instance.isAvailable()) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(ApiResponseSnackBar(message: "NFC unavailable"));
      return;
    }
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(ApiResponseSnackBar(message: "Hold phone near NFC tag..."));
    NfcManager.instance.startSession(onDiscovered: (tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) { await NfcManager.instance.stopSession(errorMessage: "Not writable"); return; }
      String data = "NAME: ${record.personalInfo.name}\nBLOOD: ${record.bloodType}\nALLERGIES: ${record.allergies.join(', ')}";
      try {
        await ndef.write(NdefMessage([NdefRecord.createText(data)]));
        await NfcManager.instance.stopSession();
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(ApiResponseSnackBar(message: "Written to NFC!"));
      }
      catch (e) { await NfcManager.instance.stopSession(errorMessage: e.toString()); }
    });
  }

  Future<void> _exportAsPDF(HealthRecord record) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (c) => pw.Column(children: [pw.Header(text: "MediPlus Medical ID"), pw.Text("Name: ${record.personalInfo.name}"), pw.Text("Blood: ${record.bloodType}")]), pageFormat: PdfPageFormat.a4));
    await Printing.layoutPdf(onLayout: (f) async => pdf.save());
  }

  Widget _buildAiInsightsCard() {
    return Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(28), border: Border.all(color: const Color(0xFF40C4FF).withValues(alpha: 0.1))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Icon(Icons.lightbulb_outline, color: Color(0xFF40C4FF), size: 20), const SizedBox(width: 12), Text("AI Health Insights", style: GoogleFonts.plusJakartaSans(color: const Color(0xFF40C4FF), fontWeight: FontWeight.bold, fontSize: 16))]), const SizedBox(height: 16), const Text("Based on your profile, stay hydrated and monitor sugar levels.", style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5))]));
  }

  Widget _buildMedicationsCard(BuildContext context) {
    return InkWell(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (c) => const MedicationTrackerScreen())), borderRadius: BorderRadius.circular(28), child: Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(28), border: Border.all(color: Colors.white.withValues(alpha: 0.1))), child: const Row(children: [Icon(Icons.medication, color: Color(0xFF40C4FF), size: 32), SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Medication Tracker", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), Text("Manage daily doses", style: TextStyle(color: Colors.white54, fontSize: 13))])), Icon(Icons.chevron_right, color: Colors.white24)])));
  }

  Widget _buildAiHubCard(BuildContext context) {
    return Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF00B0FF), Color(0xFF0081CB)]), borderRadius: BorderRadius.circular(28)), child: Column(children: [const Row(children: [Icon(Icons.auto_awesome, color: Colors.white), SizedBox(width: 12), Text("MediPlus AI Hub", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]), const SizedBox(height: 20), Row(children: [Expanded(child: InkWell(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (c) => const AiChatScreen())), child: _hubButton("AI Chat", Icons.chat))), const SizedBox(width: 12), Expanded(child: InkWell(onTap: onLaunchCamera, child: _hubButton("Scanner", Icons.qr_code_scanner)))])]));
  }

  Widget _buildEmergencyCard() {
    return Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF44336), Color(0xFFFF8A80)]), borderRadius: BorderRadius.circular(28)), child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.emergency, color: Colors.white), SizedBox(height: 12), Text("Emergency Access", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Text("QR Code \u0026 Critical Info", style: TextStyle(color: Colors.white70, fontSize: 14))]), Icon(Icons.chevron_right, color: Colors.white, size: 28)]));
  }

  Widget _buildMedicalIDCard(HealthRecord record) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(settingsController.cardColor), Color(settingsController.cardColor).withValues(alpha: 0.8)]), borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Medical ID", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)), Text("BLOOD: ${record.bloodType}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), const SizedBox(height: 20), Text(record.personalInfo.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text("DOB: ${record.personalInfo.dateOfBirth}", style: const TextStyle(color: Colors.white70)), const SizedBox(height: 20), const Divider(color: Colors.white24), const SizedBox(height: 12), Text("Allergies: ${record.allergies.join(', ')}", style: const TextStyle(color: Colors.white, fontSize: 14))]));
  }

  Widget _hubButton(String label, IconData icon) {
    return Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(16)), child: Column(children: [Icon(icon, color: Colors.white), Text(label, style: const TextStyle(color: Colors.white, fontSize: 12))]));
  }
}

class ApiResponseSnackBar extends SnackBar {
  final String message;
  ApiResponseSnackBar({super.key, required this.message}) : super(content: Text(message), behavior: SnackBarBehavior.floating, backgroundColor: const Color(0xFF1C1B1F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)));
}

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 80});
  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size, decoration: BoxDecoration(color: const Color(0xFF40C4FF), borderRadius: BorderRadius.circular(size * 0.3), boxShadow: [BoxShadow(color: const Color(0xFF40C4FF).withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2)]), child: Icon(Icons.medical_services_rounded, size: size * 0.6, color: Colors.black)).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).rotate(begin: -0.1, end: 0);
  }
}

extension AnimationExtensions on Animate {
  Animate expandVertical({Duration? duration}) {
    return custom(duration: duration, builder: (context, value, child) { return ClipRect(child: Align(alignment: Alignment.topCenter, heightFactor: value, child: child)); });
  }
}
