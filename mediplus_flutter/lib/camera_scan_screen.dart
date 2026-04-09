import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:io';
import 'ai_service.dart';

enum ScanMode {
  food("Food", Icons.restaurant, "Scan fruits & vegetables"),
  document("Document", Icons.description, "Scan prescriptions & reports"),
  insurance("ID/Insurance", Icons.badge, "Scan insurance cards & IDs"),
  symptom("Symptom", Icons.healing, "Track rashes or injuries"),
  barcode("Barcode", Icons.qr_code_scanner, "Scan medication barcodes");

  final String label;
  final IconData icon;
  final String description;
  const ScanMode(this.label, this.icon, this.description);
}

class CameraScanScreen extends StatefulWidget {
  final AiService aiService;
  final VoidCallback onBack;
  const CameraScanScreen({super.key, required this.aiService, required this.onBack});

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> {
  ScanMode _selectedMode = ScanMode.food;
  String? _resultText;
  bool _isAnalyzing = false;
  CameraController? _controller;
  bool _isCameraInitialized = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _requestPermissionAndInitCamera();
  }

  Future<void> _requestPermissionAndInitCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _initCamera();
    } else {
      setState(() {
        _errorMessage = "Camera permission is required to use this feature.";
      });
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = "No cameras found on device.");
        return;
      }

      _controller = CameraController(
        cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      setState(() => _errorMessage = "Failed to initialize camera: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _captureAndAnalyze() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      _isAnalyzing = true;
      _errorMessage = "";
    });

    try {
      final XFile image = await _controller!.takePicture();
      final bytes = await File(image.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      final result = await widget.aiService.analyzeImage(base64Image, _selectedMode.label);

      setState(() {
        _resultText = result;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error: ${e.toString()}";
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          _buildCameraPreview(),

          // Top Bar
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: Colors.black54),
            ),
          ),

          // Bottom Controls
          if (_resultText == null && !_isAnalyzing)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: ScanMode.values.length,
                      itemBuilder: (context, index) {
                        final mode = ScanMode.values[index];
                        final isSelected = _selectedMode == mode;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedMode = mode),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF40C4FF) : Colors.black54,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Icon(mode.icon, color: isSelected ? Colors.black : Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text(mode.label, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(_selectedMode.description, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _isCameraInitialized ? _captureAndAnalyze : null,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _isCameraInitialized ? const Color(0xFF40C4FF) : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera, size: 40, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

          // Analyzing Overlay
          if (_isAnalyzing)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Color(0xFF40C4FF)),
                    const SizedBox(height: 24),
                    Text("MediPlus AI is analyzing...", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

          // Result Card
          if (_resultText != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1B1F),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_selectedMode.icon, color: const Color(0xFF40C4FF)),
                        const SizedBox(width: 12),
                        Text("${_selectedMode.label} Analysis", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: Text(_resultText!, style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _resultText = null),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF40C4FF),
                              side: const BorderSide(color: Color(0xFF40C4FF)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text("Scan Again"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF40C4FF),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text("Save Record"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          if (_errorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_isCameraInitialized && _controller != null) {
      return SizedBox.expand(
        child: CameraPreview(_controller!),
      );
    } else if (_errorMessage.isEmpty) {
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF40C4FF)),
        ),
      );
    } else {
      return Container(color: Colors.black);
    }
  }
}
