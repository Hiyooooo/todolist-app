import 'package:dio/dio.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/services/api_client.dart';

class PaginatedTodos {
  final List<TodoModel> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginatedTodos({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginatedTodos.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>;
    final meta = json['meta'] as Map<String, dynamic>? ?? {};

    return PaginatedTodos(
      items: dataList
          .map((e) => TodoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: meta['page'] as int? ?? 1,
      limit: meta['limit'] as int? ?? dataList.length,
      total: meta['total'] as int? ?? dataList.length,
      totalPages: meta['totalPages'] as int? ?? 1,
    );
  }
}

class TodoApi {
  TodoApi() : _dio = ApiClient().dio;

  final Dio _dio;

  Future<PaginatedTodos> getTodos({
    int page = 1,
    int limit = 10,
    String? status,
    String? priority,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (priority != null && priority.isNotEmpty) {
        queryParams['priority'] = priority;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }
      if (sortOrder != null && sortOrder.isNotEmpty) {
        queryParams['sortOrder'] = sortOrder;
      }

      final response = await _dio.get('/todos', queryParameters: queryParams);

      final json = response.data as Map<String, dynamic>;
      return PaginatedTodos.fromJson(json);
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// Ambil detail satu todo berdasarkan id.
  Future<TodoModel> getTodoById(String id) async {
    try {
      final response = await _dio.get('/todos/$id');

      final data = response.data['data'] as Map<String, dynamic>;
      return TodoModel.fromJson(data);
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// Buat todo baru.
  Future<TodoModel> createTodo({
    required String title,
    String? description,
    String? status, // jika null → pakai default backend (pending)
    String? priority, // jika null → default backend (medium)
    DateTime? dueDate,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title,
        'description': description,
      };

      if (status != null) body['status'] = status;
      if (priority != null) body['priority'] = priority;
      if (dueDate != null) body['dueDate'] = dueDate.toIso8601String();

      final response = await _dio.post('/todos', data: body);

      final data = response.data['data'] as Map<String, dynamic>;
      return TodoModel.fromJson(data);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<TodoModel> updateTodo({
    required String id,
    required String title,
    String? description,
    required String status,
    required String priority,
    DateTime? dueDate,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title,
        'description': description,
        'status': status,
        'priority': priority,
        'dueDate': dueDate?.toIso8601String(),
      };

      final response = await _dio.put('/todos/$id', data: body);

      final data = response.data['data'] as Map<String, dynamic>;
      return TodoModel.fromJson(data);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<TodoModel> patchTodo({
    required String id,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
  }) async {
    try {
      final body = <String, dynamic>{};

      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (status != null) body['status'] = status;
      if (priority != null) body['priority'] = priority;
      if (dueDate != null) body['dueDate'] = dueDate.toIso8601String();

      final response = await _dio.patch('/todos/$id', data: body);

      final data = response.data['data'] as Map<String, dynamic>;
      return TodoModel.fromJson(data);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<TodoModel> patchTodoStatus({
    required String id,
    required String status, // 'pending' | 'in_progress' | 'completed'
  }) {
    return patchTodo(id: id, status: status);
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _dio.delete('/todos/$id');
    } on DioException catch (e) {
      rethrow;
    }
  }
}
