import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import '../provider/user_Provider.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  SignUpScreen({super.key, required this.onClickedSignUp});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/Images/SignIn_background.jpg'),
                  fit: BoxFit.cover)),
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(height: height / 3.5),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(35),
                          bottomLeft: Radius.circular(35))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        validator: ((name) =>
                            name == null ? 'Enter a username' : null),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Email Id',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.message),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Password',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (password) =>
                            password != null && password.length < 6
                                ? 'Enter min 6 character'
                                : null,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 6),
                      _isLoading
                          ? const Align(
                              alignment: Alignment.bottomCenter,
                              child: CircularProgressIndicator())
                          : Align(
                              alignment: Alignment.center,
                              child: ElevatedButton.icon(
                                onPressed: signUp,
                                icon: const Icon(
                                  Icons.lock_open,
                                  size: 24,
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                label: const Text(
                                  'Sign In',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                    ],
                  )),
              const SizedBox(height: 6),
              RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      text: 'Already have an Account?',
                      children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: 'Log In',
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                    )
                  ])),
            ]),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((value) {
        Provider.of<UserProvider>(context, listen: false)
            .createUser(_usernameController.text);
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
