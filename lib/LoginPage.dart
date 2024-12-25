import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'RegistrationPage.dart';
import 'account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login(String email, String password) async {
    try{
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AccountPage()),
      );
    
    }
    catch(e){print(e);}


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:()async{await _login(_emailController.text, _passwordController.text);},
              child: const Text('Войти'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: const Text('Создать аккаунт'),
            ),
          ],
        ),
      ),
    );
  }
}
