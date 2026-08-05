import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final fullName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  Future<void> register() async {

    if (!_formKey.currentState!.validate()) return;

    final auth =
        Provider.of<AuthProvider>(context, listen: false);

    auth.setLoading(true);

    try {

      await auth.authService.register(
        fullName: fullName.text.trim(),
        email: email.text.trim(),
        phone: phone.text.trim(),
        password: password.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    }

    auth.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: fullName,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                ),
                validator: (v) =>
                    v!.isEmpty ? "Enter Full Name" : null,
              ),

              const SizedBox(height:15),

              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                validator: (v) =>
                    v!.isEmpty ? "Enter Email" : null,
              ),

              const SizedBox(height:15),

              TextFormField(
                controller: phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                ),
                validator: (v) =>
                    v!.isEmpty ? "Enter Phone Number" : null,
              ),

              const SizedBox(height:15),

              TextFormField(
                controller: password,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: (){
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                validator: (v){
                  if(v!.length <6){
                    return "Minimum 6 characters";
                  }
                  return null;
                },
              ),

              const SizedBox(height:15),

              TextFormField(
                controller: confirmPassword,
                obscureText: hidePassword,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                ),
                validator: (v){
                  if(v != password.text){
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),

              const SizedBox(height:30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      auth.loading ? null : register,
                  child: auth.loading
                      ? const CircularProgressIndicator()
                      : const Text("Create Account"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
