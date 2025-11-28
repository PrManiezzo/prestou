import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth/data/auth_local_storage.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String token = "";
  Map<String, dynamic>? payload;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final storage = AuthLocalStorage();
    final t = await storage.getToken();

    if (t != null) {
      setState(() {
        token = t;
        payload = decodeJwt(t);
      });
    }
  }

  Map<String, dynamic> decodeJwt(String token) {
    final parts = token.split('.');
    final payload = base64Url.normalize(parts[1]);
    return jsonDecode(utf8.decode(base64Url.decode(payload)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.go("/profile");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: payload == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("TOKEN:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(token),
                  SizedBox(height: 20),
                  Text(
                    "EXPIRAÇÃO:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(
                      payload!["exp"] * 1000,
                    ).toString(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "USER ID:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(payload!["id"]),
                ],
              ),
      ),
    );
  }
}
