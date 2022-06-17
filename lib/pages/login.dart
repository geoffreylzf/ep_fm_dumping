import 'package:ep_fm_dumping/controllers/login.dart';
import 'package:ep_fm_dumping/widgets/local_cb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Eng Peng Feedmill Dumping",
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          LoginForm(),
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                autocorrect: false,
                controller: loginController.tecUsername,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
            ),
            GetX<LoginController>(
              builder: (ctrl) {
                return TextFormField(
                  controller: ctrl.tecPassword,
                  obscureText: ctrl.isPasswordObscure.value,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                          icon: Icon(ctrl.isPasswordObscure.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            ctrl.toggleObscure();
                          })),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                );
              },
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('SIGN IN'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    loginController.login();
                  }
                },
              ),
            ),
            LocalCheckBox(),
          ],
        ),
      ),
    );
  }
}
