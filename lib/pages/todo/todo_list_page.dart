import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/controllers/auth_controller.dart';
import 'package:todolist_app/controllers/todo_controller.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/routes/app_routes.dart';

class TodoListPage extends StatelessWidget {
  TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>();
    final authController = Get.find<AuthController>();
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final user = authController.user;
          final name = user?.name ?? 'User';
          return Text('Hi, $name 👋');
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildFilterBar(todoController),
            const Divider(height: 1),
            Expanded(
              child: Obx(() {
                final isLoading = todoController.isLoading.value;
                final todos = todoController.todos;
                final error = todoController.errorMessage.value;

                if (isLoading && todos.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

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

                if (todos.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => todoController.fetchTodos(refresh: true),
                    child: ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(child: Text('Belum ada todo. Tambah yuk!')),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => todoController.fetchTodos(refresh: true),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: todos.length + 1, // +1 buat row "Load more"
                    itemBuilder: (context, index) {
                      if (index == todos.length) {
                        // Row paling bawah: tombol Load more
                        if (!todoController.hasMore) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Obx(() {
                            final isLoadingMore =
                                todoController.isLoadingMore.value;
                            return ElevatedButton(
                              onPressed: isLoadingMore
                                  ? null
                                  : todoController.loadMore,
                              child: isLoadingMore
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Load more'),
                            );
                          }),
                        );
                      }

                      final TodoModel todo = todos[index];
                      final isCompleted = todo.status == 'completed';

                      return Dismissible(
                        key: ValueKey(todo.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await _confirmDelete(context);
                        },
                        onDismissed: (_) {
                          todoController.deleteTodo(todo.id);
                        },
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              isCompleted
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isCompleted ? Colors.green : Colors.grey,
                            ),
                            onPressed: () =>
                                todoController.toggleComplete(todo),
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (todo.description != null &&
                                  todo.description!.isNotEmpty)
                                Text(todo.description!),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _buildStatusChip(todo.status),
                                  const SizedBox(width: 8),
                                  _buildPriorityChip(todo.priority),
                                  const SizedBox(width: 8),
                                  if (todo.dueDate != null)
                                    Row(
                                      children: [
                                        const Icon(Icons.event, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          dateFormat.format(todo.dueDate!),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            // Edit todo → buka form dengan argumen todo
                            Get.toNamed(AppRoutes.todoForm, arguments: todo);
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.todoForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Hapus Todo'),
            content: const Text('Yakin ingin menghapus todo ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildStatusChip(String status) {
    String label;
    Color color;

    switch (status) {
      case 'in_progress':
        label = 'In Progress';
        color = Colors.blue;
        break;
      case 'completed':
        label = 'Completed';
        color = Colors.green;
        break;
      default:
        label = 'Pending';
        color = Colors.orange;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildPriorityChip(String priority) {
    String label;
    Color color;

    switch (priority) {
      case 'high':
        label = 'High';
        color = Colors.red;
        break;
      case 'low':
        label = 'Low';
        color = Colors.green;
        break;
      default:
        label = 'Medium';
        color = Colors.orange;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildFilterBar(TodoController todoController) {
    return Obx(() {
      final statusValue = todoController.statusFilter.value;
      final priorityValue = todoController.priorityFilter.value;
      final sortByValue = todoController.sortBy.value;
      final sortOrderValue = todoController.sortOrder.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: statusValue,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: 'in_progress',
                        child: Text('In Progress'),
                      ),
                      DropdownMenuItem(
                        value: 'completed',
                        child: Text('Completed'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        todoController.updateStatusFilter(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: priorityValue,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All')),
                      DropdownMenuItem(value: 'low', child: Text('Low')),
                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'high', child: Text('High')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        todoController.updatePriorityFilter(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: sortByValue,
                    decoration: const InputDecoration(
                      labelText: 'Sort By',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'createdAt',
                        child: Text('Created At'),
                      ),
                      DropdownMenuItem(
                        value: 'dueDate',
                        child: Text('Due Date'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        todoController.updateSortBy(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: sortOrderValue,
                    decoration: const InputDecoration(
                      labelText: 'Order',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'desc', child: Text('Desc')),
                      DropdownMenuItem(value: 'asc', child: Text('Asc')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        todoController.updateSortOrder(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
