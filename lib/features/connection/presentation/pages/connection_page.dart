import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lg_star_command/core/constants/app_constants.dart';
import 'package:lg_star_command/core/models/connection_params.dart';
import 'package:lg_star_command/features/connection/presentation/bloc/connection_bloc.dart';
import 'package:lg_star_command/features/connection/presentation/bloc/connection_event.dart';
import 'package:lg_star_command/features/connection/presentation/bloc/connection_state.dart';
import 'package:lg_star_command/features/dashboard/presentation/pages/dashboard_page.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final _formKey = GlobalKey<FormState>();
  final _ipController = TextEditingController();
  final _portController = TextEditingController(text: AppConstants.defaultSshPort.toString());
  final _usernameController = TextEditingController(text: AppConstants.defaultUsername);
  final _passwordController = TextEditingController(text: AppConstants.defaultPassword);
  final _screenCountController = TextEditingController(text: AppConstants.defaultScreenCount.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LG Connection')),
      body: BlocConsumer<ConnectionBloc, LGConnectionState>(
        listener: (context, state) {
          if (state is ConnectionSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            );
          } else if (state is ConnectionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                   TextFormField(
                    controller: _ipController,
                    decoration: const InputDecoration(labelText: 'Master IP Address', hintText: '192.168.0.x'),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _portController,
                    decoration: const InputDecoration(labelText: 'SSH Port'),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    obscureText: true,
                  ),
                   TextFormField(
                    controller: _screenCountController,
                    decoration: const InputDecoration(labelText: 'Screen Count'),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: state is ConnectionLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final params = ConnectionParams(
                                ip: _ipController.text,
                                port: int.parse(_portController.text),
                                username: _usernameController.text,
                                password: _passwordController.text,
                                screenCount: int.parse(_screenCountController.text),
                              );
                              context.read<ConnectionBloc>().add(ConnectToLG(params));
                            }
                          },
                    child: state is ConnectionLoading
                        ? const CircularProgressIndicator()
                        : const Text('Connect to Rig'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
