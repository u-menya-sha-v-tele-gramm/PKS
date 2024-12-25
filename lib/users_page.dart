import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_page.dart'; // Импортируем страницу чата

class User {
  final String id;
  final String email;

  User({required this.id, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['user_metadata']['email'], // Исправлено на 'user_metadata'
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final currentUser = Supabase.instance.client.auth.currentUser!;
  final SupabaseClient adminClient = SupabaseClient(
    'https://hvtufmrmhwcqqhlkradu.supabase.co', // Замените на ваш URL Supabase
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh2dHVmbXJtaHdjcXFobGtyYWR1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczNDI2NTExMiwiZXhwIjoyMDQ5ODQxMTEyfQ.m5AP7AME02o62XrG72ZQv6X9qpH6Vuy7eDBXT7InlCI', // Замените на ваш сервисный ключ
  );

  List<dynamic> users = [];
  bool isLoading = true;
  String errorMessage = '';


  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await adminClient.auth.admin.listUsers();
      users = response; // Получите данные пользователей
    } catch (error) {
      setState(() {
        errorMessage = error.toString(); // Установка сообщения об ошибке
      });
    } finally {
      setState(() {
        isLoading = false; // Установите состояние загрузки в false
      });
    }
  }


  void navigateToChat(String userSendId, String userGetId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          userSendId: userSendId,
          userGetId: userGetId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authorized Users'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage'))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return GestureDetector(
                      onTap: () {
                        // Переход на страницу чата с текущим пользователем и выбранным пользователем
                        navigateToChat(currentUser.id, user.id); // Замените 'currentUser Id' на фактический ID текущего пользователя
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(user.email ?? 'No email'), // Исправлено на 'user_metadata'
                          subtitle: Text(user.id ?? 'No ID'), // Измените на нужное поле
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
