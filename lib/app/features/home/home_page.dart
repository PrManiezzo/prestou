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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Bem-vindo!",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "User ID: ${payload!["id"]}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),

                  // Cards de navegação
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _NavigationCard(
                          title: 'Dashboard',
                          icon: Icons.dashboard,
                          color: Colors.blue,
                          onTap: () => context.go('/dashboard'),
                        ),
                        _NavigationCard(
                          title: 'Anúncios',
                          icon: Icons.campaign,
                          color: Colors.green,
                          onTap: () => context.go('/advertisements/categories'),
                        ),
                        _NavigationCard(
                          title: 'Criar Anúncio',
                          icon: Icons.add_circle,
                          color: Colors.orange,
                          onTap: () => context.go('/advertisements/new'),
                        ),
                        _NavigationCard(
                          title: 'Perfil',
                          icon: Icons.person,
                          color: Colors.purple,
                          onTap: () => context.go('/profile'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info do token (colapsável)
                  ExpansionTile(
                    title: const Text('Informações do Token'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "TOKEN:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(token),
                            const SizedBox(height: 12),
                            const Text(
                              "EXPIRAÇÃO:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                payload!["exp"] * 1000,
                              ).toString(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _NavigationCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.7),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
