import 'package:bilans/components/form_field_components.dart';
import 'package:bilans/components/login_components.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final nameField = FormFieldComponents.regularTextField(nameController,
        "First Name", true, Icons.account_circle, TextInputAction.next);

    final surnameField = FormFieldComponents.regularTextField(surnameController,
        "Surname", true, Icons.account_circle, TextInputAction.next);

    final emailField =
        FormFieldComponents.emailField(emailController, TextInputAction.next);

    final passwordField = FormFieldComponents.passwordField(
        passwordController, TextInputAction.next);

    final confirmPasswordField = FormFieldComponents.confirmPasswordField(
        confirmPasswordController,
        passwordController.text,
        TextInputAction.done);

    final signUpButton = FormFieldComponents.formSubmitButton(
        context,
        "Sign up",
        [emailController, passwordController, nameController, surnameController]
            .toList(),
        LoginComponents.register,
        _formKey);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 35),
                    nameField,
                    const SizedBox(height: 20),
                    surnameField,
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 20),
                    confirmPasswordField,
                    const SizedBox(height: 30),
                    signUpButton,
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
