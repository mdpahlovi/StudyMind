import 'package:supabase_flutter/supabase_flutter.dart' as sf;

class Supabase {
  static final sf.SupabaseClient client = sf.Supabase.instance.client;

  static Future<void> init() async {
    await sf.Supabase.initialize(
      url: 'https://jeojfydynpyoyxywxnyy.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Implb2pmeWR5bnB5b3l4eXd4bnl5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2MDU4MTksImV4cCI6MjA2NTE4MTgxOX0.oEIP7kZau7aYLMZH0goKSrZPLcJr0M-1WT5kPywMg7s',
    );
  }
}
