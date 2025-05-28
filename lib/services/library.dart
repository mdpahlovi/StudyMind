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

  Future<ApiResponse> getLibraryItemByUid(String uid) async {
    return await apiService.get('/library/$uid');
  }

  Future<ApiResponse> createLibraryItem(CreateLibraryItem request) async {
    return await apiService.post('/library', data: request.toJson());
  }

  Future<ApiResponse> updateLibraryItem(UpdateLibraryItem request) async {
    return await apiService.patch('/library/${request.uid}', data: request.toJson());
  }
}
