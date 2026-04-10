import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/logging/talker_setup.dart';
import 'package:myitihas/features/home/data/models/quote_model.dart';
import 'package:myitihas/features/home/domain/entities/quote.dart';

/// Local data source for quotes from bundled JSON asset
@lazySingleton
class QuoteLocalDataSource {
  static const String _quotesAssetPath = 'assets/data/quotes.json';

  List<Quote>? _cachedQuotes;

  /// Load all quotes from the JSON asset
  Future<List<Quote>> loadQuotes() async {
    if (_cachedQuotes != null) {
      return _cachedQuotes!;
    }

    try {
      final jsonString = await rootBundle.loadString(_quotesAssetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final quotesJson = jsonData['quotes'] as List<dynamic>;

      _cachedQuotes = quotesJson
          .map((q) => QuoteModel.fromJson(q as Map<String, dynamic>).toDomain())
          .toList();

      talker.info('📜 Loaded ${_cachedQuotes!.length} quotes from assets');
      return _cachedQuotes!;
    } catch (e, st) {
      talker.error('Failed to load quotes from assets', e, st);
      return [];
    }
  }

  /// Get the quote of the day based on current date
  /// Uses day of year for consistent daily rotation
  Future<Quote?> getQuoteOfTheDay() async {
    final quotes = await loadQuotes();
    if (quotes.isEmpty) return null;

    // Use day of year for consistent daily selection
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(startOfYear).inDays;

    final index = dayOfYear % quotes.length;
    return quotes[index];
  }

  /// Get a random quote
  Future<Quote?> getRandomQuote() async {
    final quotes = await loadQuotes();
    if (quotes.isEmpty) return null;

    quotes.shuffle();
    return quotes.first;
  }

  /// Get quote by ID
  Future<Quote?> getQuoteById(String id) async {
    final quotes = await loadQuotes();
    try {
      return quotes.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get quotes by scripture
  Future<List<Quote>> getQuotesByScripture(String scripture) async {
    final quotes = await loadQuotes();
    return quotes
        .where(
          (q) => q.scripture.toLowerCase().contains(scripture.toLowerCase()),
        )
        .toList();
  }

  /// Clear cached quotes (for testing or refresh)
  void clearCache() {
    _cachedQuotes = null;
  }
}
