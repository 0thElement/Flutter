import 'package:flutter/material.dart';
import 'package:week7_firebase/screens/event_screen.dart';
import '../shared/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  String? _userId;
  String? _password;
  String? _email;
  String? _message;

  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  late Authentication auth;

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: txtEmail,
        keyboardType: TextInputType.emailAddress,
        decoration:
            const InputDecoration(hintText: 'Email', icon: Icon(Icons.mail)),
        validator: (text) =>
            text == null || text.isEmpty ? 'Email is required' : '',
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: txtPassword,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: const InputDecoration(
            hintText: 'Password', icon: Icon(Icons.password)),
        validator: (text) =>
            text == null || text.isEmpty ? 'Password is required' : '',
      ),
    );
  }

  Future submit() async {
    setState(() {
      _message = "";
    });
    try {
      if (_isLogin) {
        _userId = await auth.login(txtEmail.text, txtPassword.text);
      } else {
        _userId = await auth.signUp(txtEmail.text, txtPassword.text);
      }
      if (_userId != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EventScreen(_userId!)));
      }
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
  }

  @override
  void initState() {
    auth = Authentication();
    super.initState();
  }

  Widget mainButton() {
    final String buttonText = _isLogin ? 'Login' : 'Sign up';
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: SizedBox(
          width: 400,
          height: 50,
          child: ElevatedButton(
            child: Text(buttonText),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                primary: Theme.of(context).colorScheme.secondary,
                elevation: 3),
            onPressed: submit,
          )),
    );
  }

  Widget secondaryButton() {
    final String buttonText = !_isLogin ? 'Login' : 'Create an account';
    return TextButton(
        onPressed: () {
          setState(() {
            _isLogin = !_isLogin;
          });
        },
        child: Text(
          buttonText,
          style: const TextStyle(color: Colors.grey),
        ));
  }

  Widget validationMessage() {
    return Text(
      _message ?? "",
      style: const TextStyle(
          fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Container(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                  child: Column(
                children: [
                  emailInput(),
                  passwordInput(),
                  mainButton(),
                  secondaryButton(),
                  validationMessage(),
                ],
              )),
            ),
          )),
    );
  }
}
