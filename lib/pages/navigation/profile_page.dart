import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Scaffold(
        // appBar: AppBar(
        //   titleSpacing: 27,
        //   title: const Text(
        //     "Владимир",
        //     style: TextStyle(
        //       fontSize: 24,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(27.5, 0, 27.5, 0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Владимир",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 22),
                    Text(
                      "8-800-555-35-35",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(137, 138, 141, 100),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "gaben@valvesoftware.com",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(137, 138, 141, 100),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 48, 0, 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 64,
                      width: 335,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/order.png',
                              height: 32,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Мои заказы",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 64,
                      width: 335,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/cards.png',
                              height: 32,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Медицинские карты",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 64,
                      width: 335,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/adress.png',
                              height: 32,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Мои адреса",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 64,
                      width: 335,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/settings.png',
                              height: 32,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "Настройки",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Column(
                children: [
                  Text(
                    "Ответы на вопросы",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(147, 147, 150, 100),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Политика конфиденциальности",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(147, 147, 150, 100),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Пользовательское соглашение",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(147, 147, 150, 100),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Выход",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(253, 53, 53, 100),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
