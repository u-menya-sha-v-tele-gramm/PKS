import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'LoginPage.dart';
import 'orders_page.dart'; // Импортируйте страницу истории заказов

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
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text('Выйти'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrdersPage()), // Переход на страницу истории заказов
                      );
                    },
                    child: const Text('Просмотреть историю заказов'),
                  ),
                ],
              )
            : const Text('Вы не авторизованы'),
      ),
    );
  }
}
