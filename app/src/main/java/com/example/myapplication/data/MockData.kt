package com.example.myapplication.data

object MockData {
    fun getMockProfile(): HealthRecord {
        return HealthRecord(
            id = 1,
            profileName = "Demo Profile",
            personalInfo = PersonalInfo(
                name = "John Doe",
                age = 28,
                dateOfBirth = "1995-05-15",
                mobileNumber = "+1 (555) 012-3456"
            ),
            bloodType = "O+",
            allergies = listOf("Peanuts", "Penicillin"),
            medicalConditions = listOf("Type 1 Diabetes", "Asthma"),
            emergencyContact = EmergencyContact(
                name = "Jane Doe",
                relationship = "Spouse",
                phone = "+1 (555) 987-6543"
            ),
            insuranceInfo = InsuranceInfo(
                provider = "MediShield Global",
                policyNumber = "MS-882-9910",
                memberId = "ID-4421"
            )
        )
    }
}
