import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://rbngfltifnxjegqyaneb.supabase.co',
      publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJibmdmbHRpZm54amVncXlhbmViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODcyMjcwNDgsImV4cCI6MjEwMjgwMzA0OH0.3LjnuuPtnYoK616IALNDLZKfVrJ1mbLmuDyPa6WG99E',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
