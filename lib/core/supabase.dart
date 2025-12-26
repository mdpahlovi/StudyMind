import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sf;

class Supabase {
  static final sf.SupabaseClient client = sf.Supabase.instance.client;

  static Future<void> init() async {
    await sf.Supabase.initialize(url: dotenv.env['SUPABASE_URL']!, anonKey: dotenv.env['SUPABASE_ANON_KEY']!);
  }
}
