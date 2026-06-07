import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/run_session.dart';
import '../models/user_profile.dart';

class AIPersonalTrainerService {
  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static const String _apiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  static const String _systemPrompt = '''
Voce e o Bolt, um personal trainer virtual especialista em corrida.

PERSONALIDADE:
- Motivador, positivo e direto.
- Linguagem casual, mas profissional.
- Celebra pequenas conquistas.

CONHECIMENTO:
- Teste de Cooper.
- Pace, ritmo e zonas de esforco.
- Periodizacao de treino.
- Prevencao de lesoes.
- Nutricao basica para corredores.

RESPOSTAS:
- Maximo de 150 palavras.
- Praticas e objetivas.
- Use os dados do usuario quando estiverem disponiveis.
- Sugira proximos passos concretos.

SEGURANCA:
- Nao de diagnosticos medicos.
- Nao recomende medicamentos.
- Oriente procurar profissional de saude em caso de dor persistente.
''';

  final List<Map<String, String>> _conversationHistory = [];

  void clearHistory() {
    _conversationHistory.clear();
  }

  Future<String> sendMessage(
    String userMessage, {
    UserProfile? userProfile,
    List<RunSession>? recentRuns,
  }) async {
    try {
      final context = _buildContext(userProfile, recentRuns);

      _conversationHistory.add({'role': 'user', 'content': userMessage});

      final fullPrompt = _buildFullPrompt(context, userMessage);
      final response = await _callGeminiAPI(fullPrompt);

      _conversationHistory.add({'role': 'assistant', 'content': response});

      return response;
    } catch (e) {
      debugPrint('Erro ao chamar IA: $e');
      return _getFallbackResponse(userMessage);
    }
  }

  String _buildContext(UserProfile? profile, List<RunSession>? runs) {
    final buffer = StringBuffer();

    if (profile != null && profile.hasAnyData) {
      buffer.writeln('DADOS DO USUARIO:');
      if (profile.displayName.trim().isNotEmpty) {
        buffer.writeln('Nome: ${profile.displayName}');
      }
      if (profile.age > 0) {
        buffer.writeln('Idade: ${profile.age}');
      }
      if (profile.bodyWeightKg > 0) {
        buffer.writeln('Peso: ${profile.bodyWeightKg.toStringAsFixed(1)} kg');
      }
      if (profile.heightCm > 0) {
        buffer.writeln('Altura: ${profile.heightCm.toStringAsFixed(0)} cm');
      }
      buffer.writeln('');
    }

    if (runs != null && runs.isNotEmpty) {
      buffer.writeln('ULTIMAS CORRIDAS:');
      for (var i = 0; i < runs.length && i < 3; i++) {
        final run = runs[i];
        buffer.writeln(
          '- ${_formatDate(run.startedAt)}: '
          '${_formatDistance(run.distanceMeters)} em '
          '${_formatDuration(run.duration.inSeconds)}, '
          'pace: ${_formatPace(run.paceSecondsPerKm)}',
        );
      }
      buffer.writeln('');
    }

    return buffer.toString();
  }

  String _buildFullPrompt(String context, String userMessage) {
    final buffer = StringBuffer()
      ..writeln(_systemPrompt)
      ..writeln();

    if (context.isNotEmpty) {
      buffer.writeln(context);
    }

    if (_conversationHistory.length > 1) {
      buffer.writeln('CONVERSA ANTERIOR:');
      final startIndex = _conversationHistory.length > 4
          ? _conversationHistory.length - 4
          : 0;
      for (var i = startIndex; i < _conversationHistory.length - 1; i++) {
        final message = _conversationHistory[i];
        final sender = message['role'] == 'user' ? 'Usuario' : 'Bolt';
        buffer.writeln('$sender: ${message['content']}');
      }
      buffer.writeln();
    }

    buffer
      ..writeln('MENSAGEM ATUAL:')
      ..writeln(userMessage);

    return buffer.toString();
  }

  Future<String> _callGeminiAPI(String prompt) async {
    if (_apiKey.isEmpty) {
      throw StateError('GEMINI_API_KEY nao configurada.');
    }

    final response = await http.post(
      Uri.parse('$_apiEndpoint?key=$_apiKey'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 300,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao obter resposta da IA: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = data['candidates'] as List<dynamic>?;
    final firstCandidate = candidates?.isNotEmpty == true
        ? candidates!.first as Map<String, dynamic>
        : null;
    final content = firstCandidate?['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    final firstPart = parts?.isNotEmpty == true
        ? parts!.first as Map<String, dynamic>
        : null;
    final text = firstPart?['text'];

    if (text == null) {
      throw Exception('Resposta da IA sem texto.');
    }

    return text.toString().trim();
  }

  String _getFallbackResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('treino') ||
        lowerMessage.contains('corrida') ||
        lowerMessage.contains('correr')) {
      return 'Oi, eu sou o Bolt. Para um treino seguro, comece com 20 a 30 '
          'minutos em ritmo confortavel, 3 vezes por semana. Aumente o volume '
          'aos poucos e registre suas corridas para eu analisar sua evolucao.';
    }

    if (lowerMessage.contains('dor') || lowerMessage.contains('lesao')) {
      return 'Se voce esta sentindo dor, reduza a intensidade e descanse. '
          'Se a dor persistir, procure um medico ou fisioterapeuta antes de '
          'continuar treinando.';
    }

    if (lowerMessage.contains('pace') || lowerMessage.contains('ritmo')) {
      return 'Para melhorar o pace, mantenha a maioria dos treinos em ritmo '
          'leve e inclua um treino intervalado por semana quando ja estiver '
          'correndo com consistencia.';
    }

    return 'Oi, eu sou o Bolt, seu personal trainer virtual. Me diga seu '
        'objetivo atual: comecar a correr, melhorar pace, ganhar resistencia '
        'ou preparar uma distancia especifica?';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}';
  }

  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  String _formatPace(int secondsPerKm) {
    if (secondsPerKm <= 0) return '--:-- /km';
    final minutes = secondsPerKm ~/ 60;
    final seconds = secondsPerKm % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')} /km';
  }

  static List<String> getQuickSuggestions({bool hasRuns = false, int? level}) {
    if (!hasRuns) {
      return [
        'Como comecar a correr?',
        'O que e o Teste de Cooper?',
        'Qual o melhor horario para treinar?',
        'Dicas para iniciantes',
      ];
    }

    if (level != null && level < 5) {
      return [
        'Como melhorar meu pace?',
        'Monte um plano de treino pra mim',
        'Como evitar lesoes?',
        'Devo treinar todo dia?',
      ];
    }

    return [
      'Como fazer treino intervalado?',
      'Preparacao para 10km',
      'Analise minhas corridas',
      'Proxima meta para mim',
    ];
  }
}
