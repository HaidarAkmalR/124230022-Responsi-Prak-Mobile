import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _username;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _username = sp.getString(AuthProvider.sessionKey);
      _imagePath = sp.getString('profile_image');
    });
  }

  Future<void> _pick(ImageSource src) async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: src, maxWidth: 800, maxHeight: 800);
    if (x != null) {
      final sp = await SharedPreferences.getInstance();
      await sp.setString('profile_image', x.path);
      setState(() { _imagePath = x.path; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => showModalBottomSheet(context: context, builder: (_) => SafeArea(
                child: Wrap(children: [
                  ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Camera'), onTap: (){ Navigator.of(context).pop(); _pick(ImageSource.camera);}),
                  ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'), onTap: (){ Navigator.of(context).pop(); _pick(ImageSource.gallery);}),
                ]),
              )),
              child: CircleAvatar(
                radius: 56,
                backgroundImage: _imagePath == null ? null : FileImage(File(_imagePath!)),
                child: _imagePath == null ? const Icon(Icons.person, size: 56) : null,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(title: const Text('Nama'), subtitle: const Text('Haidar Akmal R')),
            ListTile(title: const Text('NIM'), subtitle: const Text('124230022')),
            ListTile(title: const Text('Username'), subtitle: Text(_username ?? '—')),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () async {
                await auth.logout();
                cart.ids.clear();
                final sp = await SharedPreferences.getInstance();
                await sp.remove('cart_ids');
                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}