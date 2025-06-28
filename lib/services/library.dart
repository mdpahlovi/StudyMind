import 'package:dio/dio.dart';
import 'package:studymind/models/library.dart';
import 'package:studymind/services/api.dart';

class LibraryService {
  final ApiService apiService = ApiService();

  Future<ApiResponse> getLibraryItems(GetLibraryItemsQuery query) async {
    return await apiService.get('/library', queryParameters: query.toJson());
  }

  Future<ApiResponse> getLibraryItemsByType(GetLibraryItemsByTypeQuery query) async {
    return await apiService.get('/library/by-type', queryParameters: query.toJson());
  }

  Future<ApiResponse> getLibraryItemsWithPath({String? type = '', bool isEmBedded = true}) async {
    return await apiService.get('/library/with-path', queryParameters: {'type': type, 'isEmbedded': isEmBedded});
  }

  Future<ApiResponse> getLibraryItemByUid(String uid) async {
    return await apiService.get('/library/$uid');
  }

  Future<ApiResponse> createLibraryItem(CreateLibraryItem data) async {
    return await apiService.post(
      '/library',
      data: data.file != null ? await data.toFormData() : data.toJson(),
      options: data.file != null
          ? Options(contentType: 'multipart/form-data')
          : Options(contentType: 'application/json'),
    );
  }

  Future<ApiResponse> updateLibraryItem(UpdateLibraryItem data) async {
    return await apiService.patch('/library/${data.uid}', data: data.toJson());
  }

  Future<ApiResponse> updateBulkLibraryItem(UpdateBulkLibraryItem data) async {
    return await apiService.patch('/library/bulk', data: data.toJson());
  }
}
