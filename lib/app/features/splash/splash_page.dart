import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prestou/app/features/auth/data/auth_local_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> dot1;
  late Animation<double> dot2;
  late Animation<double> dot3;

  final _storage = AuthLocalStorage();

  @override
  void initState() {
    super.initState();

    // Cria a animação dos pontos
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    dot1 = Tween(begin: 0.7, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6)),
    );
    dot2 = Tween(begin: 0.7, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8)),
    );
    dot3 = Tween(begin: 0.7, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0)),
    );

    // Executa redirecionamento somente após o widget estar montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startRedirect();
    });
  }

  Future<void> _startRedirect() async {
    // Mantém a Splash por 2 segundos
    await Future.delayed(const Duration(seconds: 2));

    final token = await _storage.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      context.go('/home'); // Usuário logado
    } else {
      context.go('/login'); // Usuário não logado
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget dot(Animation<double> animation) {
    return ScaleTransition(
      scale: animation,
      child: const Icon(Icons.circle, size: 18, color: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/icon.png', width: 350, height: 350),
            const SizedBox(height: 20),
            const Text(
              "Prestou",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dot(dot1),
                const SizedBox(width: 10),
                dot(dot2),
                const SizedBox(width: 10),
                dot(dot3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
