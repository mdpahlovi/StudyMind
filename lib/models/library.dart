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
  final ItemType? type;
  final int page;
  final int limit;

  GetLibraryItemsByTypeQuery({this.search = '', this.type, this.page = 1, this.limit = 12});

  Map<String, dynamic> toJson() => {
    'search': search,
    'type': type?.toString().split('.').last.toUpperCase(),
    'page': page,
    'limit': limit,
  };
}

class CreateLibraryItem {
  final String name;
  final ItemType type;
  final int? parentId;
  final String path;
  final Map<String, dynamic>? metadata;
  final int sortOrder;

  CreateLibraryItem({
    required this.name,
    required this.type,
    this.parentId,
    required this.path,
    this.metadata,
    this.sortOrder = 0,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type.toString().split('.').last.toUpperCase(),
    'parentId': parentId,
    'path': path,
    'metadata': jsonEncode(metadata),
    'sortOrder': sortOrder,
  };
}

class UpdateLibraryItem {
  final String uid;
  final bool isActive;
  final String name;
  final ItemType type;
  final int? parentId;
  final String path;
  final Map<String, dynamic>? metadata;
  final int sortOrder;

  UpdateLibraryItem({
    required this.uid,
    required this.isActive,
    required this.name,
    required this.type,
    this.parentId,
    required this.path,
    this.metadata,
    this.sortOrder = 0,
  });

  Map<String, dynamic> toJson() => {
    'isActive': isActive,
    'name': name,
    'type': type.toString().split('.').last.toUpperCase(),
    'parentId': parentId,
    'path': path,
    'metadata': jsonEncode(metadata),
    'sortOrder': sortOrder,
  };
}
