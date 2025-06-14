import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studymind/controllers/library.dart';

class GetLibraryItemsQuery {
  final int page;
  final int limit;
  final String? parentUid;

  GetLibraryItemsQuery({this.page = 1, this.limit = 12, this.parentUid});

  Map<String, dynamic> toJson() => {'page': page, 'limit': limit, 'parentUid': parentUid};
}

class GetLibraryItemsByTypeQuery {
  final String search;
  final String type;
  final int page;
  final int limit;

  GetLibraryItemsByTypeQuery({this.search = '', this.type = '', this.page = 1, this.limit = 12});

  Map<String, dynamic> toJson() => {'search': search, 'type': type.toUpperCase(), 'page': page, 'limit': limit};
}

class GetLibraryItemsWithPathQuery {
  final String type;

  GetLibraryItemsWithPathQuery({this.type = 'FOLDER'});

  Map<String, dynamic> toJson() => {'type': type};
}

class CreateLibraryItem {
  final String name;
  final ItemType type;
  final int? parentId;
  final Map<String, dynamic>? metadata;
  final PlatformFile? file;

  CreateLibraryItem({required this.name, required this.type, this.parentId, this.metadata, this.file});

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.toString().split('.').last.toUpperCase(),
    'parentId': parentId,
    'metadata': jsonEncode(metadata),
  };

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{};

    map['name'] = name;
    map['type'] = type.toString().split('.').last.toUpperCase();
    if (parentId != null) map['parentId'] = parentId.toString();
    if (metadata != null) map['metadata'] = jsonEncode(metadata);
    if (file != null) map['file'] = await MultipartFile.fromFile(file!.path!, filename: file!.name);

    return FormData.fromMap(map);
  }
}

class UpdateLibraryItem {
  final String uid;
  final String name;

  UpdateLibraryItem({required this.uid, required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}

class UpdateBulkLibraryItem {
  final List<String> uid;
  final bool isActive;
  final int? parentId;

  UpdateBulkLibraryItem({required this.uid, required this.isActive, required this.parentId});

  Map<String, dynamic> toJson() => {'uid': uid, 'isActive': isActive, 'parentId': parentId};
}
