import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supplysync/core/theme/theme.dart';
import 'package:supplysync/core/utils/show_snackbar.dart';
import '../bloc/warehouses/warehouses_bloc.dart';
import '../bloc/warehouses/warehouses_event.dart';
import '../bloc/warehouses/warehouses_state.dart';
import '../../domain/entities/warehouse.dart';

class WarehousesScreen extends StatefulWidget {
  const WarehousesScreen({super.key});

  @override
  State<WarehousesScreen> createState() => _WarehousesScreenState();
}

class _WarehousesScreenState extends State<WarehousesScreen> {
  List<Warehouse> _warehouses = [];

  @override
  void initState() {
    super.initState();
    _loadWarehouses();
  }

  void _loadWarehouses() {
    context.read<WarehousesBloc>().add(const GetWarehousesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Armazéns'),
      ),
      body: BlocConsumer<WarehousesBloc, WarehousesState>(
        listener: (context, state) {
          if (state is WarehousesLoaded) {
            setState(() {
              _warehouses = state.warehouses;
            });
          } else if (state is WarehousesError) {
            showSnackBar(context, message: state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (state is WarehousesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is WarehousesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadWarehouses,
                    child: const Text('Tente Novamente'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<WarehousesBloc>()
                  .add(const RefreshWarehousesEvent());
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _warehouses.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum Armazém Encontrado',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _warehouses.length,
                      itemBuilder: (context, index) {
                        final warehouse = _warehouses[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            title: Text(warehouse.name),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    getColorWithOpacity(AppColors.green, 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Ativo',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            onTap: () {
                              context.push('/home/warehouses/${warehouse.id}');
                            },
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
