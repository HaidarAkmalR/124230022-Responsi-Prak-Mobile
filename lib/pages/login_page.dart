import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(controller: _username, decoration: const InputDecoration(labelText: 'Username')),
            const SizedBox(height: 12),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Login'),
              onPressed: _loading ? null : () async {
                setState((){_loading = true; _error = null;});
                final ok = await auth.login(_username.text.trim(), _password.text.trim());
                setState((){_loading = false;});
                if (!ok) {
                  setState((){_error = 'Username/password salah';});
                } else {
                  
                  if (!mounted) return;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
                }
              },
            ),
            TextButton(
              child: const Text('Belum punya akun? Register'),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterPage())),
            )
          ],
        ),
      ),
    );
  }
}