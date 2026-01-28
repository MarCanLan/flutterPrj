import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://vhxgumyleqazevghmzzp.supabase.co',
    anonKey: 'sb_publishable_m1nLRiS3HCB6EnyiXCsEsw_fy5VDYe3',
  );
  runApp(App());
}
