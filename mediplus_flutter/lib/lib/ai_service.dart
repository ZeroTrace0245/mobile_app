import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage {
  final String role;
  final List<ContentPart> content;

  ChatMessage({required this.role, required this.content});

  factory ChatMessage.textOnly(String role, String text) {
    return ChatMessage(role: role, content: [ContentPart(type: "text", text: text)]);
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content.map((c) => c.toJson()).toList(),
    };
  }
}

class ContentPart {
  final String type;
  final String? text;
  final ImageUrl? imageUrl;

  ContentPart({required this.type, this.text, this.imageUrl});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'type': type};
    if (text != null) map['text'] = text;
    if (imageUrl != null) map['image_url'] = imageUrl!.toJson();
    return map;
  }
}

class ImageUrl {
  final String url;

  ImageUrl({required this.url});

  Map<String, dynamic> toJson() => {'url': url};
}

class ChatRequest {
  final List<ChatMessage> messages;
  final String model;
  final double temperature;
  final double topP;
  final int maxTokens;

  ChatRequest({
    required this.messages,
    this.model = "gpt-4o",
    this.temperature = 1.0,
    this.topP = 1.0,
    this.maxTokens = 1000,
  });

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((m) => m.toJson()).toList(),
      'model': model,
      'temperature': temperature,
      'top_p': topP,
      'max_tokens': maxTokens,
    };
  }
}

class AiService {
  final String endpoint = "https://models.inference.ai.azure.com/chat/completions";

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('github_token');
  }

  Future<String> getFallbackToken() async {
    // In a real app, you would fetch this from a secure server
    return "";
  }

  Future<String> getCompletion(List<ChatMessage> messages) async {
    final apiKey = await getApiKey() ?? await getFallbackToken();
    if (apiKey.isEmpty) {
      throw Exception("API Key is missing. Please set your GitHub Token in settings.");
    }

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
        'User-Agent': 'MediPlus-Flutter-App',
      },
      body: json.encode(ChatRequest(messages: messages).toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'] ?? "No response from AI";
    } else {
      throw Exception("AI Error (${response.statusCode}): ${response.body}");
    }
  }

  Future<String> analyzeImage(String base64Image, String mode) async {
    String prompt;
    switch (mode) {
      case "Food":
        prompt = "Identify the fruits or vegetables in this image. For each item, provide its name and the average nutritional abundance (calories, vitamins, minerals) per 100g. Format the output cleanly.";
        break;
      case "Document":
        prompt = "Analyze this medical document (prescription, lab report, or summary). Extract the key information like patient name, medications prescribed, test results, or doctor's advice. Summarize it clearly.";
        break;
      case "ID/Insurance":
        prompt = "Scan this health insurance card or hospital ID. Extract the provider name, policy number, member ID, and any other relevant identification details.";
        break;
      case "Symptom":
        prompt = "Analyze this image of a skin rash, injury, or symptom. Provide a general observation of what it looks like (without giving a formal medical diagnosis) and suggest if it's something that typically requires a doctor's visit. Advice on simple first aid if applicable.";
        break;
      case "Barcode":
        prompt = "Identify any medication barcodes or labels in this image. Extract the drug name, dosage, and manufacturer if possible.";
        break;
      default:
        prompt = "Identify and explain what is shown in this medical-related image.";
    }

    final messages = [
      ChatMessage(
        role: "user",
        content: [
          ContentPart(type: "text", text: prompt),
          ContentPart(type: "image_url", imageUrl: ImageUrl(url: "data:image/jpeg;base64,$base64Image")),
        ],
      )
    ];
    return getCompletion(messages);
  }
}
