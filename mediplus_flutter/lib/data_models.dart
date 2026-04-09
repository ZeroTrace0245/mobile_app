import 'dart:convert';

class HealthRecord {
  final int id;
  final String profileName;
  final PersonalInfo personalInfo;
  final String bloodType;
  final List<String> allergies;
  final List<String> medicalConditions;
  final EmergencyContact emergencyContact;
  final InsuranceInfo insuranceInfo;

  HealthRecord({
    this.id = 0,
    required this.profileName,
    required this.personalInfo,
    required this.bloodType,
    required this.allergies,
    required this.medicalConditions,
    required this.emergencyContact,
    required this.insuranceInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileName': profileName,
      'personalInfo': personalInfo.toMap(),
      'bloodType': bloodType,
      'allergies': allergies,
      'medicalConditions': medicalConditions,
      'emergencyContact': emergencyContact.toMap(),
      'insuranceInfo': insuranceInfo.toMap(),
    };
  }

  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id']?.toInt() ?? 0,
      profileName: map['profileName'] ?? '',
      personalInfo: PersonalInfo.fromMap(map['personalInfo']),
      bloodType: map['bloodType'] ?? '',
      allergies: List<String>.from(map['allergies']),
      medicalConditions: List<String>.from(map['medicalConditions']),
      emergencyContact: EmergencyContact.fromMap(map['emergencyContact']),
      insuranceInfo: InsuranceInfo.fromMap(map['insuranceInfo']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HealthRecord.fromJson(String source) => HealthRecord.fromMap(json.decode(source));
}

class PersonalInfo {
  final String name;
  final int age;
  final String dateOfBirth;
  final String mobileNumber;

  PersonalInfo({
    required this.name,
    required this.age,
    required this.dateOfBirth,
    required this.mobileNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'dateOfBirth': dateOfBirth,
      'mobileNumber': mobileNumber,
    };
  }

  factory PersonalInfo.fromMap(Map<String, dynamic> map) {
    return PersonalInfo(
      name: map['name'] ?? '',
      age: map['age']?.toInt() ?? 0,
      dateOfBirth: map['dateOfBirth'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
    );
  }
}

class EmergencyContact {
  final String name;
  final String relationship;
  final String phone;

  EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'relationship': relationship,
      'phone': phone,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}

class InsuranceInfo {
  final String provider;
  final String policyNumber;
  final String memberId;

  InsuranceInfo({
    required this.provider,
    required this.policyNumber,
    required this.memberId,
  });

  Map<String, dynamic> toMap() {
    return {
      'provider': provider,
      'policyNumber': policyNumber,
      'memberId': memberId,
    };
  }

  factory InsuranceInfo.fromMap(Map<String, dynamic> map) {
    return InsuranceInfo(
      provider: map['provider'] ?? '',
      policyNumber: map['policyNumber'] ?? '',
      memberId: map['memberId'] ?? '',
    );
  }
}

class Appointment {
  final int id;
  final String title;
  final String doctorName;
  final String location;
  final int dateTime;
  final String notes;

  Appointment({
    this.id = 0,
    required this.title,
    required this.doctorName,
    required this.location,
    required this.dateTime,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'doctorName': doctorName,
      'location': location,
      'dateTime': dateTime,
      'notes': notes,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      doctorName: map['doctorName'] ?? '',
      location: map['location'] ?? '',
      dateTime: map['dateTime']?.toInt() ?? 0,
      notes: map['notes'] ?? '',
    );
  }
}

class Medication {
  final int id;
  final String name;
  final String dosage;
  final String frequency;
  final String time;
  final bool isTaken;

  Medication({
    this.id = 0,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.time,
    this.isTaken = false,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != 0) 'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'time': time,
      'isTaken': isTaken ? 1 : 0,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
      time: map['time'] ?? '',
      isTaken: map['isTaken'] == 1,
    );
  }
}

class MockData {
  static HealthRecord getMockProfile() {
    return HealthRecord(
      id: 1,
      profileName: "Demo Profile",
      personalInfo: PersonalInfo(
        name: "John Doe",
        age: 28,
        dateOfBirth: "1995-05-15",
        mobileNumber: "+1 (555) 012-3456",
      ),
      bloodType: "O+",
      allergies: ["Peanuts", "Penicillin"],
      medicalConditions: ["Type 1 Diabetes", "Asthma"],
      emergencyContact: EmergencyContact(
        name: "Jane Doe",
        relationship: "Spouse",
        phone: "+1 (555) 987-6543",
      ),
      insuranceInfo: InsuranceInfo(
        provider: "MediShield Global",
        policyNumber: "MS-882-9910",
        memberId: "ID-4421",
      ),
    );
  }

  static List<Appointment> getMockAppointments() {
    final now = DateTime.now().millisecondsSinceEpoch;
    const oneHour = 3600000;
    const oneDay = 86400000;

    return [
      Appointment(
        id: 1,
        title: "Cardiology Checkup",
        doctorName: "Dr. Smith",
        location: "MediPlus Center, Floor 3",
        dateTime: now + (oneDay * 2) + (oneHour * 2),
        notes: "Bring previous test results",
      ),
      Appointment(
        id: 2,
        title: "Routine Eye Exam",
        doctorName: "Dr. Lee",
        location: "Vision Clinic, Suite 204",
        dateTime: now + (oneDay * 5),
        notes: "Fast for 4 hours before",
      ),
    ];
  }
}
