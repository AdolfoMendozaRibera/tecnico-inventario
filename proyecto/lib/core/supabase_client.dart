import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static Future<void> initialize() async {
    // Las credenciales se leen desde el archivo .env (excluido del repo por .gitignore)
    await dotenv.load(fileName: '.env');

    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
