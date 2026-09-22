import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      // Ignorar si ya está cargado o si falla en web
    }

    final url = dotenv.maybeGet('SUPABASE_URL') ?? 'https://ywpwpxxlfcdhjcpyuyob.supabase.co';
    final anonKey = dotenv.maybeGet('SUPABASE_ANON_KEY') ?? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3cHdweHhsZmNkaGpjcHl1eW9iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODcxNzc3NTAsImV4cCI6MjEwMjc1Mzc1MH0.sSyfA175f77tkgsnfneHFxLRhwou2Qo_t96jnzIadl0';

    if (url.isNotEmpty && anonKey.isNotEmpty) {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
      );
    }
  }

  static SupabaseClient get client => Supabase.instance.client;
}
