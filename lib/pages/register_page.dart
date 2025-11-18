import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
              TextFormField(
                controller: _username,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Username tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v == null || v.trim().length < 4 ? 'Password minimal 4 karakter' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Register'),
                onPressed: _loading ? null : () async {
                  if (!_formKey.currentState!.validate()) return;
                  setState((){_loading = true; _error = null;});
                  final ok = await auth.register(_username.text.trim(), _password.text.trim());
                  setState((){_loading = false;});
                  if (!ok) {
                    setState((){_error = 'Username sudah terdaftar';});
                  } else {
                  
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil')));
                    Navigator.of(context).pop(); 
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}