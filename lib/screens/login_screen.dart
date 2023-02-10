import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../model/user.dart';

Users? loginUser = Users();

class LoginScreen extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  LoginScreen({super.key, required this.onClickedSignUp});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // print('${height}  ${width}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/Images/login_background.jpg'),
                  fit: BoxFit.cover)),
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(height: height / 2.85),
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
                        'Email Id',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      TextFormField(
                        controller: emailController,
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
                        controller: passwordController,
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
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton.icon(
                                onPressed: signIn,
                                icon: const Icon(
                                  Icons.lock_open,
                                  size: 24,
                                ),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                label: const Text(
                                  'Log In',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                      // const SizedBox(height: 4),
                    ],
                  )),
              const SizedBox(height: 2),
              RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      text: 'No Account?  ',
                      children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: 'Sign Up',
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

  Future signIn() async {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) =>const Center(
    //           child: CircularProgressIndicator(),
    //         ));
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        //Provider.of<UserProvider>(context, listen: false).getLoginUser();
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
    //navigatorKey.currentState!.popUntil((route)=>route)
  }
}
