import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:studymind/core/notification.dart';
import 'package:studymind/core/supabase.dart';

class Download {
  static Future<void> fromSupabase(String filePath, {String? saveAs}) async {
    try {
      // Ask for storage permission
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        Notification.error('Storage permission denied');
        return;
      }

      final fileBytes = await Supabase.client.storage.from('studymind').download(filePath);
      final String fileName = saveAs ?? filePath.split('/').last;

      // Use Android's public Downloads folder
      final String downloadsPath = '/storage/emulated/0/Download';
      final String tempPath = '$downloadsPath/$fileName';

      final File localFile = File(tempPath);
      await localFile.writeAsBytes(fileBytes);

      Notification.success('File downloaded successfully');
    } catch (e) {
      Notification.error('Oops, something went wrong');
    }
  }
}
