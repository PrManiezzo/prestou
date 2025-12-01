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
  final List<String> _mockImages = [];

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
          leading: BackButton(onPressed: () => context.pop()),
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
                    elevation: 1,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _mockImages.add(
                            'https://via.placeholder.com/600x400.png?text=Imagem+Mockada',
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Imagem mockada adicionada.')),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Adicionar imagens',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Em desenvolvimento',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (_mockImages.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Pré-visualização',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    _mockImages.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final url = entry.value;
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          url,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) => Container(
                                            width: 90,
                                            height: 90,
                                            color: Colors.grey[200],
                                            child:
                                                const Icon(Icons.broken_image),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _mockImages.removeAt(idx);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
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
