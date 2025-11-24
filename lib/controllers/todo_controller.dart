import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/services/todo_api.dart';

class TodoController extends GetxController {
  final TodoApi _todoApi = TodoApi();

  final todos = <TodoModel>[].obs;

  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final isLoadingMore = false.obs;
  final isSaving = false.obs;
  final errorMessage = ''.obs;

  final statusFilter = 'all'.obs; // all | pending | in_progress | completed
  final priorityFilter = 'all'.obs; // all | low | medium | high
  final sortBy = 'createdAt'.obs; // createdAt | dueDate
  final sortOrder = 'desc'.obs; // asc | desc

  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  @override
  void onInit() {
    super.onInit();
    fetchTodos(initial: true);
  }

  Future<void> fetchTodos({bool initial = false, bool refresh = false}) async {
    if (initial) {
      isLoading.value = true;
    } else if (refresh) {
      isRefreshing.value = true;
      _page = 1;
      _hasMore = true;
    }

    errorMessage.value = '';

    try {
      final result = await _todoApi.getTodos(
        page: _page,
        limit: _limit,
        status: statusFilter.value == 'all' ? null : statusFilter.value,
        priority: priorityFilter.value == 'all' ? null : priorityFilter.value,
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
      );

      if (refresh || initial) {
        todos.assignAll(result.items);
      } else {
        todos.addAll(result.items);
      }

      _hasMore = _page < result.totalPages;
    } catch (e) {
      errorMessage.value = _mapErrorToMessage(e);
    } finally {
      if (initial) {
        isLoading.value = false;
      }
      if (refresh) {
        isRefreshing.value = false;
      }
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || isLoadingMore.value) return;

    isLoadingMore.value = true;
    errorMessage.value = '';

    try {
      _page += 1;
      final result = await _todoApi.getTodos(page: _page, limit: _limit);

      todos.addAll(result.items);
      _hasMore = _page < result.totalPages;
    } catch (e) {
      errorMessage.value = _mapErrorToMessage(e);
      // kalau error saat loadMore, kembalikan page
      _page -= 1;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> createTodo({
    required String title,
    String? description,
    String? status,
    String? priority,
    DateTime? dueDate,
  }) async {
    isSaving.value = true;
    errorMessage.value = '';

    try {
      final todo = await _todoApi.createTodo(
        title: title,
        description: description,
        status: status,
        priority: priority,
        dueDate: dueDate,
      );

      // Masukkan ke paling atas list
      todos.insert(0, todo);
    } catch (e) {
      errorMessage.value = _mapErrorToMessage(e);
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateTodo({
    required String id,
    required String title,
    String? description,
    required String status,
    required String priority,
    DateTime? dueDate,
  }) async {
    isSaving.value = true;
    errorMessage.value = '';

    try {
      final updated = await _todoApi.updateTodo(
        id: id,
        title: title,
        description: description,
        status: status,
        priority: priority,
        dueDate: dueDate,
      );

      final index = todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        todos[index] = updated;
      }
    } catch (e) {
      errorMessage.value = _mapErrorToMessage(e);
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }

  /// Toggle status:
  /// - kalau saat ini 'completed' → balik ke 'pending'
  /// - selain itu → jadikan 'completed'
  Future<void> toggleComplete(TodoModel todo) async {
    final newStatus = todo.status == 'completed' ? 'pending' : 'completed';

    try {
      final updated = await _todoApi.patchTodoStatus(
        id: todo.id,
        status: newStatus,
      );

      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        todos[index] = updated;
      }
    } catch (e) {
      errorMessage.value = _mapErrorToMessage(e);
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _todoApi.deleteTodo(id);
      todos.removeWhere((t) => t.id == id);

      Get.snackbar(
        'Sukses',
        'Todo berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = _mapErrorToMessage(e);
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _mapErrorToMessage(Object e) {
    if (e is DioException) {
      final res = e.response;
      if (res != null) {
        final data = res.data;
        if (data is Map && data['message'] is String) {
          return data['message'] as String;
        }
      }
      return 'Gagal memuat data: ${e.message ?? 'Terjadi kesalahan jaringan.'}';
    }
    return 'Terjadi kesalahan, silakan coba lagi.';
  }

  void updateStatusFilter(String value) {
    if (statusFilter.value == value) return;
    statusFilter.value = value;
    _page = 1;
    _hasMore = true;
    fetchTodos(refresh: true);
  }

  void updatePriorityFilter(String value) {
    if (priorityFilter.value == value) return;
    priorityFilter.value = value;
    _page = 1;
    _hasMore = true;
    fetchTodos(refresh: true);
  }

  void updateSortBy(String value) {
    if (sortBy.value == value) return;
    sortBy.value = value;
    _page = 1;
    _hasMore = true;
    fetchTodos(refresh: true);
  }

  void updateSortOrder(String value) {
    if (sortOrder.value == value) return;
    sortOrder.value = value;
    _page = 1;
    _hasMore = true;
    fetchTodos(refresh: true);
  }
}
