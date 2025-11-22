import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist_app/controllers/todo_controller.dart';
import 'package:todolist_app/models/todo_model.dart';

class TodoFormPage extends StatefulWidget {
  const TodoFormPage({super.key});

  @override
  State<TodoFormPage> createState() => _TodoFormPageState();
}

class _TodoFormPageState extends State<TodoFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TodoController _todoController;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _status = 'pending';
  String _priority = 'medium';
  DateTime? _dueDate;

  TodoModel? _editingTodo;

  final _dateFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _todoController = Get.find<TodoController>();

    final args = Get.arguments;
    if (args is TodoModel) {
      _editingTodo = args;
      _titleController.text = args.title;
      _descriptionController.text = args.description ?? '';
      _status = args.status;
      _priority = args.priority;
      _dueDate = args.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final initial = _dueDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    try {
      if (_editingTodo == null) {
        await _todoController.createTodo(
          title: title,
          description: description,
          status: _status,
          priority: _priority,
          dueDate: _dueDate,
        );
        Get.snackbar(
          'Sukses',
          'Todo berhasil dibuat',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        await _todoController.updateTodo(
          id: _editingTodo!.id,
          title: title,
          description: description,
          status: _status,
          priority: _priority,
          dueDate: _dueDate,
        );
        Get.snackbar(
          'Sukses',
          'Todo berhasil diupdate',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      Get.back();
    } catch (_) {
      // error ditangani oleh controller melalui errorMessage
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _editingTodo != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Todo' : 'Tambah Todo')),
      body: SafeArea(
        child: Obx(() {
          final isSaving = _todoController.isSaving.value;
          final error = _todoController.errorMessage.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _status,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
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
                              setState(() {
                                _status = value;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _priority,
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'low', child: Text('Low')),
                            DropdownMenuItem(
                              value: 'medium',
                              child: Text('Medium'),
                            ),
                            DropdownMenuItem(
                              value: 'high',
                              child: Text('High'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _priority = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Due date',
                            border: OutlineInputBorder(),
                          ),
                          child: InkWell(
                            onTap: _pickDueDate,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              child: Text(
                                _dueDate != null
                                    ? _dateFormat.format(_dueDate!)
                                    : 'Tidak ada',
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _dueDate = null;
                          });
                        },
                        icon: const Icon(Icons.clear),
                        tooltip: 'Hapus due date',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (error.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : _onSubmit,
                      child: isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isEdit ? 'Simpan Perubahan' : 'Tambah Todo'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
