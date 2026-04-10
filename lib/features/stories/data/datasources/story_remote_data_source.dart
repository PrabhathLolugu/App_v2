import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:myitihas/core/errors/exceptions.dart';
import '../models/story_model.dart';

abstract class StoryRemoteDataSource {
  Future<List<StoryModel>> getStories({
    String? searchQuery,
    String? sortBy,
    String? filterByType,
    String? filterByTheme,
    int? limit,
    int? offset,
  });

  Future<StoryModel> getStoryById(String id);
  Future<List<StoryModel>> getTrendingStories({int limit = 10});
  Future<List<StoryModel>> getStoriesByScripture(String scripture);
  Future<List<StoryModel>> searchStories(String query);
}

@LazySingleton(as: StoryRemoteDataSource)
class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final Dio dio;

  StoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<StoryModel>> getStories({
    String? searchQuery,
    String? sortBy,
    String? filterByType,
    String? filterByTheme,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (searchQuery != null) queryParams['search'] = searchQuery;
      if (sortBy != null) queryParams['sort'] = sortBy;
      if (filterByType != null) queryParams['type'] = filterByType;
      if (filterByTheme != null) queryParams['theme'] = filterByTheme;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await dio.get('/stories', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['stories'] ?? response.data;
        return data.map((json) => StoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to fetch stories',
          response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutException();
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      } else {
        throw ServerException(
          e.response?.statusMessage ?? 'Server error',
          e.response?.statusCode.toString(),
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<StoryModel> getStoryById(String id) async {
    try {
      final response = await dio.get('/stories/$id');

      if (response.statusCode == 200) {
        return StoryModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw const NotFoundException('Story not found');
      } else {
        throw ServerException(
          'Failed to fetch story',
          response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const NotFoundException('Story not found');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutException();
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      } else {
        throw ServerException(
          e.response?.statusMessage ?? 'Server error',
          e.response?.statusCode.toString(),
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<StoryModel>> getTrendingStories({int limit = 10}) async {
    try {
      final response = await dio.get(
        '/stories/trending',
        queryParameters: {'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['stories'] ?? response.data;
        return data.map((json) => StoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to fetch trending stories',
          response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutException();
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      } else {
        throw ServerException(
          e.response?.statusMessage ?? 'Server error',
          e.response?.statusCode.toString(),
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<StoryModel>> getStoriesByScripture(String scripture) async {
    try {
      final response = await dio.get(
        '/stories',
        queryParameters: {'scripture': scripture},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['stories'] ?? response.data;
        return data.map((json) => StoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to fetch stories by scripture',
          response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutException();
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      } else {
        throw ServerException(
          e.response?.statusMessage ?? 'Server error',
          e.response?.statusCode.toString(),
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<StoryModel>> searchStories(String query) async {
    try {
      final response = await dio.get(
        '/stories/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['stories'] ?? response.data;
        return data.map((json) => StoryModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to search stories',
          response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutException();
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException();
      } else {
        throw ServerException(
          e.response?.statusMessage ?? 'Server error',
          e.response?.statusCode.toString(),
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
