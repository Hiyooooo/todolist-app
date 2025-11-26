import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/controllers/todo_controller.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/widgets/todo/todo_list_item.dart';
import 'package:todolist_app/widgets/todo/todo_section_header.dart';

class TodoGroupedListBody extends StatelessWidget {
  final TodoController controller;
  final DateFormat dateFormat;

  const TodoGroupedListBody({
    super.key,
    required this.controller,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isLoading.value;
      final todos = controller.todos;
      final error = controller.errorMessage.value;

      final query = controller.searchQuery.value.trim().toLowerCase();

      final filteredTodos = query.isEmpty
          ? todos
          : todos.where((t) {
              final title = t.title.toLowerCase();
              return title.contains(query);
            }).toList();

      // Loading awal
      if (isLoading && todos.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // Error awal
      if (error.isNotEmpty && todos.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      }

      // Tidak ada todo sama sekali
      if (todos.isEmpty) {
        return RefreshIndicator(
          onRefresh: () => controller.fetchTodos(refresh: true),
          child: ListView(
            children: const [
              SizedBox(height: 100),
              Center(child: Text('Belum ada todo. Tambah yuk!')),
            ],
          ),
        );
      }

      // Ada todo, tapi tidak ada yang match search
      if (filteredTodos.isEmpty) {
        return RefreshIndicator(
          onRefresh: () => controller.fetchTodos(refresh: true),
          child: ListView(
            children: const [
              SizedBox(height: 100),
              Center(
                child: Text('Tidak ada todo yang cocok dengan pencarian.'),
              ),
            ],
          ),
        );
      }

      // Grouping by status
      final groupedItems = _buildGroupedItems(filteredTodos.toList());

      return RefreshIndicator(
        onRefresh: () => controller.fetchTodos(refresh: true),
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: groupedItems.length + 1, // +1 untuk "Load more"
          itemBuilder: (context, index) {
            // Row terakhir: tombol Load more
            if (index == groupedItems.length) {
              if (!controller.hasMore) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Obx(() {
                  final isLoadingMore = controller.isLoadingMore.value;
                  return ElevatedButton(
                    onPressed: isLoadingMore ? null : controller.loadMore,
                    child: isLoadingMore
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Load more'),
                  );
                }),
              );
            }

            final item = groupedItems[index];

            if (item is _HeaderItem) {
              return TodoSectionHeader(title: item.title, color: item.color);
            } else if (item is _TodoItem) {
              return TodoListItem(todo: item.todo, dateFormat: dateFormat);
            }

            return const SizedBox.shrink();
          },
        ),
      );
    });
  }
}

/// ===== Helper class untuk grouping list =====

abstract class _ListItem {}

class _HeaderItem extends _ListItem {
  final String title;
  final Color color;

  _HeaderItem(this.title, this.color);
}

class _TodoItem extends _ListItem {
  final TodoModel todo;

  _TodoItem(this.todo);
}

/// Urutan group: Pending → In Progress → Completed
List<_ListItem> _buildGroupedItems(List<TodoModel> todos) {
  final items = <_ListItem>[];

  final pending = todos.where((t) => t.status == 'pending').toList();
  final inProgress = todos.where((t) => t.status == 'in_progress').toList();
  final completed = todos.where((t) => t.status == 'completed').toList();

  if (pending.isNotEmpty) {
    items.add(_HeaderItem('Pending', Colors.orange));
    items.addAll(pending.map<_ListItem>((t) => _TodoItem(t)));
  }

  if (inProgress.isNotEmpty) {
    items.add(_HeaderItem('In Progress', Colors.blue));
    items.addAll(inProgress.map<_ListItem>((t) => _TodoItem(t)));
  }

  if (completed.isNotEmpty) {
    items.add(_HeaderItem('Completed', Colors.green));
    items.addAll(completed.map<_ListItem>((t) => _TodoItem(t)));
  }

  return items;
}
