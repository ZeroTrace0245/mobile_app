import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data_models.dart';

class RegistrationScreen extends StatefulWidget {
  final String? initialName;
  final HealthRecord? initialRecord;
  final Function(HealthRecord) onRegistrationComplete;

  const RegistrationScreen({
    super.key,
    this.initialName,
    this.initialRecord,
    required this.onRegistrationComplete,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _allergiesController;
  late TextEditingController _conditionsController;

  // Emergency Contact
  late TextEditingController _ecNameController;
  late TextEditingController _ecRelationController;
  late TextEditingController _ecPhoneController;

  // Insurance
  late TextEditingController _insProviderController;
  late TextEditingController _insPolicyController;

  late String _selectedBloodType;
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    final r = widget.initialRecord;
    _nameController = TextEditingController(text: r?.personalInfo.name ?? widget.initialName ?? "");
    _ageController = TextEditingController(text: r?.personalInfo.age.toString() ?? "");
    _dobController = TextEditingController(text: r?.personalInfo.dateOfBirth ?? "");
    _phoneController = TextEditingController(text: r?.personalInfo.mobileNumber ?? "");
    _allergiesController = TextEditingController(text: r?.allergies.join(", ") ?? "");
    _conditionsController = TextEditingController(text: r?.medicalConditions.join(", ") ?? "");

    _ecNameController = TextEditingController(text: r?.emergencyContact.name ?? "");
    _ecRelationController = TextEditingController(text: r?.emergencyContact.relationship ?? "");
    _ecPhoneController = TextEditingController(text: r?.emergencyContact.phone ?? "");

    _insProviderController = TextEditingController(text: r?.insuranceInfo.provider ?? "");
    _insPolicyController = TextEditingController(text: r?.insuranceInfo.policyNumber ?? "");

    _selectedBloodType = r?.bloodType ?? 'O+';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.initialRecord == null ? "Profile Setup" : "Edit Profile", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.initialRecord == null ? "Complete your health profile" : "Update your information",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF40C4FF),
                ),
              ).animate().fadeIn().slideX(),
              const SizedBox(height: 8),
              const Text(
                "Your information is stored locally and will not be visible to us.",
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 32),

              _buildSectionTitle("Personal Details"),
              _buildTextField(_nameController, "Full Name", Icons.person),
              Row(
                children: [
                  Expanded(child: _buildTextField(_ageController, "Age", Icons.calendar_today, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(_dobController, "DOB (YYYY-MM-DD)", Icons.cake)),
                ],
              ),
              _buildTextField(_phoneController, "Mobile Number", Icons.phone, isNumber: true),

              const SizedBox(height: 24),
              _buildSectionTitle("Medical Info"),
              _buildBloodTypeDropdown(),
              _buildTextField(_allergiesController, "Allergies (comma separated)", Icons.warning_amber_rounded, required: false),
              _buildTextField(_conditionsController, "Medical Conditions (comma separated)", Icons.medical_services_outlined, required: false),

              const SizedBox(height: 24),
              _buildSectionTitle("Emergency Contact"),
              _buildTextField(_ecNameController, "Contact Name", Icons.contact_phone),
              _buildTextField(_ecRelationController, "Relationship", Icons.people),
              _buildTextField(_ecPhoneController, "Contact Phone", Icons.phone_android, isNumber: true),

              const SizedBox(height: 24),
              _buildSectionTitle("Insurance Info (Optional)"),
              _buildTextField(_insProviderController, "Insurance Provider", Icons.security, required: false),
              _buildTextField(_insPolicyController, "Policy Number", Icons.numbers, required: false),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF40C4FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(widget.initialRecord == null ? "Create Account" : "Save Changes", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: const TextStyle(color: Color(0xFF40C4FF), fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white38),
          labelStyle: const TextStyle(color: Colors.white60),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF40C4FF))),
        ),
        validator: required ? (value) => value == null || value.isEmpty ? 'Required' : null : null,
      ),
    );
  }

  Widget _buildBloodTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedBloodType,
        dropdownColor: const Color(0xFF1C1B1F),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "Blood Type",
          prefixIcon: const Icon(Icons.bloodtype, color: Colors.white38),
          labelStyle: const TextStyle(color: Colors.white60),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        ),
        items: _bloodTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
        onChanged: (val) => setState(() => _selectedBloodType = val!),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final record = HealthRecord(
        id: widget.initialRecord?.id ?? 0,
        profileName: widget.initialRecord?.profileName ?? "Profile",
        personalInfo: PersonalInfo(
          name: _nameController.text,
          age: int.tryParse(_ageController.text) ?? 0,
          dateOfBirth: _dobController.text,
          mobileNumber: _phoneController.text,
        ),
        bloodType: _selectedBloodType,
        allergies: _allergiesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        medicalConditions: _conditionsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        emergencyContact: EmergencyContact(
          name: _ecNameController.text,
          relationship: _ecRelationController.text,
          phone: _ecPhoneController.text,
        ),
        insuranceInfo: InsuranceInfo(
          provider: _insProviderController.text,
          policyNumber: _insPolicyController.text,
          memberId: "",
        ),
      );
      widget.onRegistrationComplete(record);
    }
  }
}
