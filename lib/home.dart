import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loggedIn = false;
  String _name = 'Sebastian Espinoza';
  String _email = 'sebastian@demo.com';
  String _career = 'Desarrollo de aplicaciones moviles';
  String? _profileImagePath;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    setState(() {
      _email = email;
      _name = email.split('@').first;
      _loggedIn = true;
    });
  }

  void _logout() {
    setState(() => _loggedIn = false);
  }

  void _updateProfile({
    required String name,
    required String email,
    required String career,
  }) {
    setState(() {
      _name = name;
      _email = email;
      _career = career;
    });
  }

  Future<void> _changeProfilePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) {
      return;
    }

    setState(() => _profileImagePath = image.path);
  }

  ImageProvider _profileImage() {
    final path = _profileImagePath;
    if (path != null) {
      return FileImage(File(path));
    }
    return const AssetImage('foto2.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_loggedIn ? 'Nova ID' : 'Acceso Nova'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _loggedIn
              ? _ProfileView(
                  name: _name,
                  email: _email,
                  career: _career,
                  imageProvider: _profileImage(),
                  onChangePhoto: _changeProfilePhoto,
                  onLogout: _logout,
                  onSave: _updateProfile,
                )
              : _LoginView(
                  formKey: _loginFormKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  imageProvider: _profileImage(),
                  onLogin: _login,
                ),
        ),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.imageProvider,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ImageProvider imageProvider;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('login'),
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                CircleAvatar(radius: 62, backgroundImage: imageProvider),
                const SizedBox(height: 24),
                Text(
                  'Hola de nuevo',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Accede para personalizar tu identidad digital.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) {
                      return 'Ingresa tu correo';
                    }
                    if (!email.contains('@')) {
                      return 'Ingresa un correo valido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contrasena',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    final password = value ?? '';
                    if (password.isEmpty) {
                      return 'Ingresa tu contrasena';
                    }
                    if (password.length < 6) {
                      return 'Minimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: onLogin,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Entrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView({
    required this.name,
    required this.email,
    required this.career,
    required this.imageProvider,
    required this.onChangePhoto,
    required this.onLogout,
    required this.onSave,
  });

  final String name;
  final String email;
  final String career;
  final ImageProvider imageProvider;
  final VoidCallback onChangePhoto;
  final VoidCallback onLogout;
  final void Function({
    required String name,
    required String email,
    required String career,
  })
  onSave;

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  final _profileFormKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _careerController;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _careerController = TextEditingController(text: widget.career);
  }

  @override
  void didUpdateWidget(covariant _ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing) {
      _syncControllers();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _careerController.dispose();
    super.dispose();
  }

  void _syncControllers() {
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _careerController.text = widget.career;
  }

  void _saveProfile() {
    if (!_profileFormKey.currentState!.validate()) {
      return;
    }

    widget.onSave(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      career: _careerController.text.trim(),
    );
    setState(() => _editing = false);
  }

  void _cancelEdit() {
    _syncControllers();
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('profile'),
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _profileFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 72,
                        backgroundImage: widget.imageProvider,
                      ),
                      IconButton.filled(
                        onPressed: widget.onChangePhoto,
                        icon: const Icon(Icons.photo_camera_outlined),
                        tooltip: 'Cambiar foto',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Perfil activo en Nova',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                if (_editing) ...[
                  _EditableField(
                    controller: _nameController,
                    label: 'Nombre',
                    icon: Icons.person_outline,
                    validatorText: 'Ingresa tu nombre',
                  ),
                  const SizedBox(height: 12),
                  _EditableField(
                    controller: _emailController,
                    label: 'Correo',
                    icon: Icons.email_outlined,
                    validatorText: 'Ingresa tu correo',
                    email: true,
                  ),
                  const SizedBox(height: 12),
                  _EditableField(
                    controller: _careerController,
                    label: 'Carrera o rol',
                    icon: Icons.school_outlined,
                    validatorText: 'Ingresa tu carrera o rol',
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Guardar perfil'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _cancelEdit,
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                  ),
                ] else ...[
                  _InfoRow(icon: Icons.person_outline, text: widget.name),
                  const SizedBox(height: 12),
                  _InfoRow(icon: Icons.email_outlined, text: widget.email),
                  const SizedBox(height: 12),
                  _InfoRow(icon: Icons.school_outlined, text: widget.career),
                  const SizedBox(height: 12),
                  const _InfoRow(
                    icon: Icons.check_circle_outline,
                    text: 'Sesion iniciada correctamente',
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => setState(() => _editing = true),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Personalizar datos'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: widget.onLogout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Salir'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  const _EditableField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validatorText,
    this.email = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String validatorText;
  final bool email;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) {
          return validatorText;
        }
        if (email && !text.contains('@')) {
          return 'Ingresa un correo valido';
        }
        return null;
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
