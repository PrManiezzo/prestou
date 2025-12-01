import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prestou/app/features/advertisements/presentation/advertisement/bloc/advertisement_bloc.dart';
import 'package:prestou/app/features/advertisements/presentation/advertisement/bloc/advertisement_event.dart';
import 'package:prestou/app/features/advertisements/presentation/advertisement/bloc/advertisement_state.dart';

class AdvertisementsListPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const AdvertisementsListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AdvertisementBloc()..add(LoadAdvertisementsByCategory(categoryId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<AdvertisementBloc, AdvertisementState>(
          builder: (context, state) {
            if (state is AdvertisementLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdvertisementError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar anúncios',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AdvertisementBloc>().add(
                              LoadAdvertisementsByCategory(categoryId),
                            );
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            if (state is AdvertisementLoaded) {
              if (state.advertisements.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum anúncio encontrado',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Seja o primeiro a anunciar nesta categoria!',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.advertisements.length,
                itemBuilder: (context, index) {
                  final ad = state.advertisements[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        ad.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            ad.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          if (ad.price != null)
                            Text(
                              'R\$ ${ad.price!.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.go('/advertisements/${ad.id}');
                      },
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go('/advertisements/new?categoryId=$categoryId');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
