import 'package:care_giver/ui/pages/login_page.dart';
import 'package:care_giver/util/navigator_util.dart';
import 'package:flutter/material.dart';

import '../../util/reg_exp_util.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameTextEditingController = TextEditingController();
  final _gmailOrPhoneNoTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _confirmedPasswordTextEditingController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    super.dispose();

    _userNameTextEditingController.dispose();
    _gmailOrPhoneNoTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _confirmedPasswordTextEditingController.dispose();
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
                  _gmailOrPhoneNumberForm(),
                  const SizedBox(height: 16),
                  _passwordForm(_passwordTextEditingController, 'Password'),
                  const SizedBox(height: 32),
                  _passwordForm(_confirmedPasswordTextEditingController,
                      'Confirmed Password'),
                  const SizedBox(height: 32),
                  _doneButton(),
                  const SizedBox(height: 50),
                  _loginLabel(),
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
      'Care Giver Admin Registration',
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

  Widget _gmailOrPhoneNumberForm() {
    return TextFormField(
      controller: _gmailOrPhoneNoTextEditingController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Enter gmail or phone number';
        }
        if ((!_isNumeric(value) && !RegExpUtils.email.hasMatch(value)) ||
            !RegExpUtils.phoneNumber.hasMatch(value)) {
          return 'Enter gmail or phone number';
        }
        return null;
      },
      decoration: const InputDecoration(
        label: Text('Gmail or Phone Number'),
        floatingLabelStyle: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _passwordForm(
    TextEditingController textEditingController,
    String message,
  ) {
    return TextFormField(
      controller: textEditingController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Enter ${message.toLowerCase()}';
        }

        if (value.length < 6) {
          return '$message must be at least 6 characters.';
        }

        return null;
      },
      decoration: InputDecoration(
        label: Text(message),
        floatingLabelStyle: const TextStyle(color: Colors.black),
      ),
      obscureText: true,
    );
  }

  Widget _doneButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() == true) {
          _registration();
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
            : const Text('Done'),
      ),
    );
  }

  Widget _loginLabel() {
    return InkWell(
      child: Text(
        'Login',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
          decoration: TextDecoration.underline,
        ),
      ),
      onTap: () {
        NavigatorUtils.pushAndRemoveUntil(context, const LoginPage());
      },
    );
  }

  bool _isNumeric(String? result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }

  Future<void> _registration() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    // call registration

    setState(() {
      _loading = false;
    });

    if (!mounted) return;
  }
}
