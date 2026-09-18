import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://ywpwpxxlfcdhjcpyuyob.supabase.co',
      publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3cHdweHhsZmNkaGpjcHl1eW9iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODcxNzc3NTAsImV4cCI6MjEwMjc1Mzc1MH0.sSyfA175f77tkgsnfneHFxLRhwou2Qo_t96jnzIadl0',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
