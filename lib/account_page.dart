import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'LoginPage.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser ;

    return Scaffold(
      appBar: AppBar(title: const Text('Аккаунт')),
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Email: ${user.email}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await Supabase.instance.client.auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text('Выйти'),
                  ),
                ],
              )
            : const Text('Вы не авторизованы'),
      ),
    );
  }
}
