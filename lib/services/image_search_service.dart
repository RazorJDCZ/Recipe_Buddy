import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageSearchService {
  final String _apiKey = const String.fromEnvironment("BING_API_KEY");
  final String _endpoint = "https://api.bing.microsoft.com/v7.0/images/search";

  Future<String> searchImage(String query) async {
    try {
      final url = Uri.parse("$_endpoint?q=$query food dish&count=1");

      final response = await http.get(
        url,
        headers: {"Ocp-Apim-Subscription-Key": _apiKey},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final first = decoded["value"]?[0];
        if (first != null && first["contentUrl"] != null) {
          return first["contentUrl"];
        }
      }
      return "";
    } catch (e) {
      print("Error buscando imagen: $e");
      return "";
    }
  }
}
