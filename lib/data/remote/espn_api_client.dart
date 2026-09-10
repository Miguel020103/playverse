import 'dart:convert';
import 'package:http/http.dart' as http;

/// Cliente HTTP ampliado para la API no oficial de ESPN (NFL).
class EspnApiClient {
  EspnApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _siteBase =
      'https://site.api.espn.com/apis/site/v2/sports/football/nfl';
  static const String _standingsBase =
      'https://site.api.espn.com/apis/v2/sports/football/nfl';

  /// Scoreboard del día o de una fecha (YYYYMMDD).
  Future<Map<String, dynamic>> getScoreboard({String? date}) async {
    final query = date != null ? '?dates=$date' : '';
    return _get(Uri.parse('$_siteBase/scoreboard$query'));
  }

  /// Scoreboard por semana de temporada.
  /// seasontype: 1=pre, 2=regular, 3=post
  Future<Map<String, dynamic>> getScoreboardByWeek({
    required int year,
    required int week,
    int seasontype = 2,
  }) async {
    final uri = Uri.parse(
      '$_siteBase/scoreboard?dates=$year&seasontype=$seasontype&week=$week',
    );
    return _get(uri);
  }

  /// Standings oficiales de la temporada.
  Future<Map<String, dynamic>> getStandings({int? season}) async {
    final query = season != null ? '?season=$season' : '';
    return _get(Uri.parse('$_standingsBase/standings$query'));
  }

  /// Resumen detallado de un partido.
  Future<Map<String, dynamic>> getSummary(String eventId) async {
    return _get(Uri.parse('$_siteBase/summary?event=$eventId'));
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'PlayVerse/1.1.0 (Flutter)',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      throw EspnApiException(
        'ESPN error ${response.statusCode}: ${response.reasonPhrase}',
        statusCode: response.statusCode,
      );
    } on EspnApiException {
      rethrow;
    } catch (e) {
      throw EspnApiException('Network error: $e');
    }
  }

  void dispose() => _client.close();
}

class EspnApiException implements Exception {
  final String message;
  final int? statusCode;
  EspnApiException(this.message, {this.statusCode});
  @override
  String toString() => 'EspnApiException: $message';
}