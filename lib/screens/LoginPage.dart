import 'package:flutter/material.dart';

import '../controllers/Controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final resetKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _resetController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   const Text("Войти"),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          validator: (value) =>
                          value!.isEmpty ? "Заполните поле Почта." : null,
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Почта"),
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: TextFormField(
                          validator: (value) => value!.length < 8
                              ? "Пароль должен быть не менее 8 символов"
                              : null,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Пароль"),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Сбросить пароль"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                            "Please enter your email we will send a recovery link."),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Form(
                                          key: resetKey,
                                          child: TextFormField(
                                            controller: _resetController,
                                            validator: (value) => value!
                                                .isEmpty
                                                ? "Please enter a valid email."
                                                : null,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              label: Text("Почта"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Отмена")),
                                      TextButton(
                                          onPressed: () {
                                            if (resetKey.currentState!
                                                .validate()) {
                                              sendRecoveryMail(
                                                  _resetController.text)
                                                  .then((value) {
                                                Navigator.pop(context);
                                                if (value) {
                                                  ScaffoldMessenger.of(
                                                      context)
                                                      .showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          "Recovery Mail Sent",
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white),
                                                        ),
                                                        backgroundColor: Colors
                                                            .green.shade400,
                                                      ));
                                                } else {
                                                  ScaffoldMessenger.of(
                                                      context)
                                                      .showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          "Cannot Sent Recovery Mail",
                                                          style: TextStyle(
                                                              color:
                                                              Colors.white),
                                                        ),
                                                        backgroundColor:
                                                        Colors.red.shade400,
                                                      ));
                                                }
                                              });
                                            }
                                          },
                                          child: const Text("Send Link"))
                                    ],
                                  ));
                            },
                            child: Text(
                              "Забыл пароль",
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        height: 65,
                        width: MediaQuery.of(context).size.width * .9,
                        child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                loginUser(_emailController.text,
                                    _passwordController.text)
                                    .then((value) {
                                  if (value == "success") {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text(
                                        "Вход выполнен",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green.shade400,
                                    ));
                                    Navigator.pushReplacementNamed(
                                        context, "/home");
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        value,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red.shade400,
                                    ));
                                  }
                                });
                              }
                            },
                            child: const Text(
                              "Войти",
                              style: TextStyle(fontSize: 17),
                            ))),
                   const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 65,
                      width: MediaQuery.of(context).size.width * .9,
                      child: OutlinedButton(
                          onPressed: () {
                            continueWithGoogle().then((value) {
                              if (value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:const  Text(
                                    "Google Login Successful",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green.shade400,
                                ));
                                Navigator.pushReplacementNamed(
                                    context, "/home");
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                    "Google Login Failed",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red.shade400,
                                ));
                              }
                            });
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Продолжить с Google",
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Нет аккаунта?"),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/signup");
                            },
                            child: const Text("Зарегистрироваться"))
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}