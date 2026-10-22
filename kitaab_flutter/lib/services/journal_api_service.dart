
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/journal_entry.dart';

class JournalApiService {
  // Android emulator can reach your computer's localhost using this address.
  //static const String baseUrl = 'http://10.0.2.2:8080';
  //for web
  static const String baseUrl = 'http://localhost:8080';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  String _errorMessage(DioException error) {
    if (error.response != null) {
      return 'Server error: ${error.response!.statusCode}';
    }

    return 'Cannot connect to Kitaab server. '
        'Check that Spring Boot is running.';
  }

  Future<List<JournalEntry>> getEntries() async {
    try {
      final response = await _dio.get('/journal');
      final data = response.data;

      if (data is! List) {
        throw const FormatException(
          'Expected a list of journal entries.',
        );
      }

      return data.map((item) {
        if (item is! Map) {
          throw const FormatException(
            'Invalid journal entry returned by server.',
          );
        }

        return JournalEntry.fromJson(
          Map<String, dynamic>.from(item),
        );
      }).toList();
    } on DioException catch (error) {
      throw Exception(_errorMessage(error));
    }
  }

  Future<JournalEntry> getEntryById(String id) async {
    try {
      final response = await _dio.get('/journal/id/$id');

      if (response.data is! Map) {
        throw const FormatException(
          'Invalid journal entry returned by server.',
        );
      }

      return JournalEntry.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (error) {
      throw Exception(_errorMessage(error));
    }
  }

  Future<List<JournalEntry>> getAllEntries() async {
    final response = await _dio.get('/journal');

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map(
          (json) => JournalEntry.fromJson(
        Map<String, dynamic>.from(json as Map),
      ),
    )
        .toList();
  }

  Future<JournalEntry> createEntry(JournalEntry entry) async {
    try {
      final response = await _dio.post(
        '/journal',
        data: {
          'title': entry.title,
          'content': entry.content,
        },
      );

      if (response.data is! Map) {
        throw const FormatException(
          'Server did not return the created entry.',
        );
      }

      return JournalEntry.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (error) {
      throw Exception(_errorMessage(error));
    }
  }

  Future<JournalEntry> updateEntry(
      String id,
      JournalEntry entry,
      ) async {
    try {
      final response = await _dio.put(
        '/journal/id/$id',
        data: {
          'title': entry.title,
          'content': entry.content,
        },
      );

      if (response.data is! Map) {
        throw const FormatException(
          'Server did not return the updated entry.',
        );
      }

      return JournalEntry.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (error) {
      throw Exception(_errorMessage(error));
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      debugPrint('Deleting journal entry with ID: $id');
      await _dio.delete('/journal/id/$id');
    } on DioException catch (error) {
      throw Exception(_errorMessage(error));
    }
  }

}
