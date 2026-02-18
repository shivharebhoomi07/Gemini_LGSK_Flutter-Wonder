import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lg_star_command/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:lg_star_command/features/connection/presentation/bloc/connection_event.dart';
import 'package:lg_star_command/features/connection/presentation/pages/connection_page.dart';
import 'package:lg_star_command/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:lg_star_command/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:lg_star_command/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LG Controller'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<ConnectionBloc>().add(DisconnectFromLG());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ConnectionPage()),
              );
            },
          )
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final isTouring = state is DashboardTouring;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is DashboardLoading) const CircularProgressIndicator(),
                if (state is DashboardError) Text('Error: ${state.error}', style: const TextStyle(color: Colors.red)),
                
                const SizedBox(height: 20),
                
                // Taj Mahal Card
                Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text("Taj Mahal Expedition", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                              onPressed: isTouring ? null : () {
                                context.read<DashboardBloc>().add(StartOrbit());
                              },
                              icon: const Icon(Icons.rocket_launch),
                              label: const Text("Start Orbit"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                  // We allow stopping even if not "Touring" state technically, to force stop
                                  context.read<DashboardBloc>().add(StopOrbit());
                              },
                              icon: const Icon(Icons.stop_circle),
                              label: const Text("Stop Orbit"),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                 const SizedBox(height: 40),
                 
                 ElevatedButton(
                   onPressed: () => context.read<DashboardBloc>().add(CleanRig()),
                   child: const Text("Clean Rig"),
                 ),
              ],
            ),
          );
        },
      ),
    );
  }
}
