import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth/auth_service.dart';
import '../../services/wallet_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLogin = true;
  bool loading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> handleAuth() async {
    final emailText = email.text.trim();
    final passText = password.text.trim();

    // ✅ VALIDATION
    if (emailText.isEmpty || passText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password required")),
      );
      return;
    }

    setState(() => loading = true);

    final auth = context.read<AuthService>();

    try {
      final user = isLogin
          ? await auth.login(emailText, passText)
          : await auth.register(emailText, passText);

      if (!mounted) return;

      setState(() => loading = false);

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isLogin ? 'Login failed' : 'Registration failed',
            ),
          ),
        );
        return;
      }

      // ✅ CREATE WALLET ONLY AFTER SUCCESS
      await context.read<WalletService>().createWallet();

      // ✅ NAVIGATE
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VTU Auth System")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : handleAuth,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isLogin ? "Login" : "Register"),
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin
                    ? "Create account"
                    : "Already have account? Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
