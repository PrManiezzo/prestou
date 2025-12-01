import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prestou/app/features/advertisements/presentation/advertisement/bloc/advertisement_bloc.dart';
import 'package:prestou/app/features/advertisements/presentation/advertisement/bloc/advertisement_event.dart';
import 'package:prestou/app/features/advertisements/presentation/advertisement/bloc/advertisement_state.dart';
import 'package:prestou/app/features/advertisements/presentation/category/bloc/category_bloc.dart';
import 'package:prestou/app/features/advertisements/presentation/category/bloc/category_event.dart';
import 'package:prestou/app/features/advertisements/presentation/category/bloc/category_state.dart';
import 'package:prestou/app/widgets/inputDefaut/app_input_field.dart';

class CreateAdvertisementPage extends StatefulWidget {
  final int? categoryId;

  const CreateAdvertisementPage({
    super.key,
    this.categoryId,
  });

  @override
  State<CreateAdvertisementPage> createState() =>
      _CreateAdvertisementPageState();
}

class _CreateAdvertisementPageState extends State<CreateAdvertisementPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione uma categoria')),
        );
        return;
      }

      if (_titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, insira um título')),
        );
        return;
      }

      if (_descriptionController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, insira uma descrição')),
        );
        return;
      }

      final price = _priceController.text.isEmpty
          ? null
          : double.tryParse(_priceController.text.replaceAll(',', '.'));

      context.read<AdvertisementBloc>().add(
            CreateAdvertisement(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              price: price,
              categoryId: _selectedCategoryId!,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AdvertisementBloc()),
        BlocProvider(create: (_) => CategoryBloc()..add(LoadCategories())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Criar Anúncio'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: BlocListener<AdvertisementBloc, AdvertisementState>(
          listener: (context, state) {
            if (state is AdvertisementCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Anúncio criado com sucesso!')),
              );
              context.go(
                  '/advertisements/category/${state.advertisement.categoryId}');
            } else if (state is AdvertisementError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro: ${state.message}')),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Category selector
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryLoaded) {
                        return DropdownButtonFormField<int>(
                          value: _selectedCategoryId,
                          decoration: const InputDecoration(
                            labelText: 'Categoria *',
                            border: OutlineInputBorder(),
                          ),
                          items: state.categories.map((category) {
                            return DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Por favor, selecione uma categoria';
                            }
                            return null;
                          },
                        );
                      }
                      return const LinearProgressIndicator();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Title
                  AppInputField(
                    controller: _titleController,
                    label: 'Título *',
                    type: InputType.text,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  AppInputField(
                    controller: _descriptionController,
                    label: 'Descrição *',
                    type: InputType.text,
                  ),
                  const SizedBox(height: 16),

                  // Price
                  AppInputField(
                    controller: _priceController,
                    label: 'Preço (opcional)',
                    type: InputType.text,
                  ),
                  const SizedBox(height: 24),

                  // Image upload section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.add_photo_alternate, size: 48),
                          const SizedBox(height: 8),
                          const Text('Adicionar imagens'),
                          const SizedBox(height: 4),
                          Text(
                            'Funcionalidade em desenvolvimento',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  BlocBuilder<AdvertisementBloc, AdvertisementState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state is AdvertisementLoading
                            ? null
                            : () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: state is AdvertisementLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Publicar Anúncio',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
