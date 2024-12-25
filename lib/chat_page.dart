import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatefulWidget {
  final String userSendId;
  final String userGetId;

  const ChatPage({super.key, required this.userSendId, required this.userGetId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Stream<List<dynamic>> chat_peremennaya; 

  final SupabaseClient supabaseClient = SupabaseClient(
    'https://hvtufmrmhwcqqhlkradu.supabase.co', 
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh2dHVmbXJtaHdjcXFobGtyYWR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQyNjUxMTIsImV4cCI6MjA0OTg0MTExMn0.kb-GTWVs8Alpl6GUZVs5-POYFxeIYfCgstVwmUZGmxY', // Замените на ваш анонимный ключ
  );

@override
void initState() {
  super.initState();
  fetchMessages(); // Просто вызываем метод, чтобы инициализировать поток
}

  final TextEditingController _messageController = TextEditingController();
  String errorMessage = '';

  Future<void> sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      setState(() {
        errorMessage = 'Message cannot be empty';
        fetchMessages();
      });
      return;
    }

    try {
      final response = await Supabase.instance.client.from('chat').insert({
        'user_send_id': widget.userSendId,
        'user_get_id': widget.userGetId,
        'text': message,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      _messageController.clear(); // Очищаем текстовое поле после отправки
      setState(() {
        errorMessage = ''; // Сбрасываем сообщение об ошибке
        fetchMessages();
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        fetchMessages();
      });
    }
  }

Future<void> fetchMessages() async {
  // Убедитесь, что вы правильно инициализируете поток
  chat_peremennaya = Supabase.instance.client
      .from('chat')
      .stream(primaryKey: ['id'])
      .eq('user_get_id', widget.userGetId) // Получаем сообщения для конкретного пользователя
      .order('created_at', ascending: true); // Сортируем по времени создания
  print(chat_peremennaya);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.userGetId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<dynamic>>(
              stream: chat_peremennaya,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages yet. ${snapshot.data}'));
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['text']),
                      subtitle: Text(message['created_at']),
                    );
                  },
                );
              },
            ),

            ),
            if (errorMessage.isNotEmpty) 
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Type your message',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
