
import 'package:flutter/material.dart';
import 'package:location_app/controllers/Controller.dart';



class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Регистрация"),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  child: TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Заполните поле Имя" : null,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Имя"),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  child: TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? "Заполните поле Почта" : null,
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 65,
                  width: MediaQuery.of(context).size.width * .9,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          createUser(_nameController.text, _emailController
                              .text, _passwordController.text)
                              .then((value) {
                            if (value == "success") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(
                                  "Аккаунт успешно создан",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green.shade400,
                              ));
                              Navigator.pop(context);
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
                          createUserDocument(
                              _nameController.text, _emailController.text,
                              _passwordController.text);
                        }
                      },
                      child: const Text(
                        "Зарегистрироваться",
                        style: TextStyle(fontSize: 16),
                      ))),
             const  SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width * .9,
                child: OutlinedButton(
                    onPressed: () {
                      continueWithGoogle().then((value) {
                        if (value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:const  Text(
                              "Google Login Successful",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green.shade400,
                          ));
                          Navigator.pushReplacementNamed(context, "/home");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                          style: TextStyle(fontSize: 16),
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
                  const Text("Уже есть аккаунт?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Войти"))
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}