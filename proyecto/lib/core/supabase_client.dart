import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // Ignorar si ya está cargado o si falla en web
    }

    final url = dotenv.maybeGet('SUPABASE_URL') ?? '';
    final anonKey = dotenv.maybeGet('SUPABASE_ANON_KEY') ?? '';

    if (url.isNotEmpty && anonKey.isNotEmpty) {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
      );
    }
  }

  static SupabaseClient get client => Supabase.instance.client;
}
