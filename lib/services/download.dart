import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/core/supabase.dart';

class Download {
  static Future<void> fromSupabase(String filePath, {String? saveAs}) async {
    try {
      final fileBytes = await Supabase.client.storage.from('studymind').download(filePath);
      final downloads = await getDownloadsDirectory();

      if (fileBytes.isNotEmpty && downloads != null) {
        final String fileName = saveAs ?? filePath.split('/').last;
        final String tempPath = '${downloads.path}/$fileName';

        final File localFile = File(tempPath);
        await localFile.writeAsBytes(fileBytes);
      } else {
        Notification.error('Oops, something went wrong');
      }

      Notification.success('File downloaded successfully');
    } catch (e) {
      Notification.error('Oops, something went wrong');
    }
  }
}
