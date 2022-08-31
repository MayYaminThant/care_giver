import 'package:care_giver/ui/pages/registration_page.dart';
import 'package:care_giver/util/navigator_util.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    super.dispose();

    _userNameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _label(),
                  const SizedBox(height: 32),
                  _nameForm(),
                  const SizedBox(height: 16),
                  _passwordForm(),
                  const SizedBox(height: 32),
                  _loginButton(),
                  const SizedBox(height: 32),
                  _goToNewsFeed(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label() {
    return Text(
      'Care Giver',
      style: TextStyle(
        fontSize: 30,
        color: Theme.of(context).primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _nameForm() {
    return TextFormField(
      controller: _userNameTextEditingController,
      validator: (String? value) {
        return (value == null || value.isEmpty) ? 'Enter username' : null;
      },
      decoration: const InputDecoration(
        label: Text('Username'),
        floatingLabelStyle: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _passwordForm() {
    return TextFormField(
      controller: _passwordTextEditingController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Enter password';
        }

        if (value.length < 6) {
          return 'Password must be at least 6 characters.';
        }

        return null;
      },
      decoration: const InputDecoration(
        label: Text('Password'),
        floatingLabelStyle: TextStyle(color: Colors.black),
      ),
      obscureText: true,
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() == true) {
          _login();
        }
      },
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        child: _loading
            ? const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(color: Colors.white),
              )
            : const Text('Login'),
      ),
    );
  }

  Widget _goToNewsFeed() {
    return Row(
      children: [
        const Text(
          'Not Registered?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        InkWell(
            child: Text(
              ' Go to Newsfeed',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              NavigatorUtils.pushAndRemoveUntil(
                  context, const RegistrationPage());
            })
      ],
    );
  }

  Future<void> _login() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    // call login

    setState(() {
      _loading = false;
    });

    if (!mounted) return;
  }
}