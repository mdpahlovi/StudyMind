import 'dart:convert';

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

  CreateLibraryItem({required this.name, required this.type, this.parentId, this.metadata});

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.toString().split('.').last.toUpperCase(),
    'parentId': parentId,
    'metadata': jsonEncode(metadata),
  };
}

class UpdateLibraryItem {
  final String uid;
  final bool isActive;
  final String name;
  final ItemType type;
  final int? parentId;
  final Map<String, dynamic>? metadata;

  UpdateLibraryItem({
    required this.uid,
    required this.isActive,
    required this.name,
    required this.type,
    this.parentId,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'isActive': isActive,
    'name': name,
    'type': type.toString().split('.').last.toUpperCase(),
    'parentId': parentId,
    'metadata': jsonEncode(metadata),
  };
}
