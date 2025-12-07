import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String _apiKey = String.fromEnvironment("OPENAI_KEY");


  // ---------------------------------------------------------
  // 1️⃣ GENERAR TEXTO DE RECETA — SOLO JSON PURO
  // ---------------------------------------------------------
  Future<String?> generateRecipeText(String ingredients) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "system",
            "content":
                "Return ONLY valid JSON. No comments. No explanation. Use exactly: {\"title\":\"\",\"ingredients\":[],\"steps\":[],\"time\":\"\",\"difficulty\":\"\",\"portions\":\"\"}. If unsure, fill with reasonable defaults."
          },
          {
            "role": "user",
            "content":
                "Create a cooking recipe JSON using these ingredients: $ingredients. Do NOT include any extra text, ONLY a JSON object."
          }
        ],
        "temperature": 0.5
      }),
    );

    if (response.statusCode != 200) {
      print("❌ ERROR TEXT: ${response.body}");
      return null;
    }

    final jsonResponse = jsonDecode(response.body);
    String raw = jsonResponse["choices"][0]["message"]["content"];

    // LIMPIAR texto extra
    raw = raw.trim();

    // EXTRAER SOLO EL JSON ENTRE {}
    if (!raw.startsWith("{")) {
      final start = raw.indexOf("{");
      final end = raw.lastIndexOf("}");
      if (start != -1 && end != -1) raw = raw.substring(start, end + 1);
    }

    return raw;
  }

  // ---------------------------------------------------------
  // 2️⃣ PARSEAR JSON Y GARANTIZAR QUE NUNCA FALLE
  // ---------------------------------------------------------
  Map<String, dynamic> parseRecipeJson(String text) {
    try {
      final decoded = jsonDecode(text);

      return {
        "title": decoded["title"] ?? "Untitled Recipe",
        "ingredients":
            List<String>.from(decoded["ingredients"] ?? const <String>[]),
        "steps": List<String>.from(decoded["steps"] ?? const <String>[]),
        "time": decoded["time"] ?? "15 min",
        "difficulty": decoded["difficulty"] ?? "Easy",
        "portions": decoded["portions"] ?? "1",
      };
    } catch (e) {
      print("❌ ERROR PARSE JSON: $e");
      throw "Invalid JSON returned by OpenAI";
    }
  }

  // ---------------------------------------------------------
  // 3️⃣ GENERAR IMAGEN — DEVUELVE BASE64
  // ---------------------------------------------------------
  Future<String?> generateImage(String prompt) async {
    final url = Uri.parse("https://api.openai.com/v1/images/generations");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey",
      },
      body: jsonEncode({
        "model": "gpt-image-1",
        "prompt": "Professional food photography of: $prompt",
        "size": "1024x1024"
      }),
    );

    if (response.statusCode != 200) {
      print("❌ ERROR IMAGE: ${response.body}");
      return null;
    }

    final data = jsonDecode(response.body);
    return data["data"][0]["b64_json"];
  }

  // ---------------------------------------------------------
  // 4️⃣ SUBIR BASE64 A FIREBASE STORAGE
  // ---------------------------------------------------------
  Future<String?> uploadImage(String title, String base64) async {
    try {
      final bytes = Uint8List.fromList(base64Decode(base64));

      final fileName =
          "${title.replaceAll(" ", "_").replaceAll("/", "")}_${DateTime.now().millisecondsSinceEpoch}.jpg";

      final ref = FirebaseStorage.instance
          .ref()
          .child("recipe_images/$fileName");

      await ref.putData(bytes, SettableMetadata(contentType: "image/jpeg"));

      return await ref.getDownloadURL();
    } catch (e) {
      print("❌ ERROR UPLOAD IMAGE: $e");
      return null;
    }
  }
}
