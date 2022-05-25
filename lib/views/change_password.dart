import 'package:flutter/material.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/view_models/change_password.dart';
import 'package:provider/provider.dart';

/// Screen to force the user to change his password on first login.
class ChangePasswordScreen extends StatelessWidget {
  /// Initializes the instance.
  const ChangePasswordScreen({Key? key}) : super(key: key);

  /// Create the screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<ChangePasswordViewModel>(
        create: (context) => ChangePasswordViewModel(),
        builder: (context, _) {
          var vm = Provider.of<ChangePasswordViewModel>(context, listen: false);

          return FutureBuilder(
            future: vm.init(context),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Center(
                child: Form(
                  key: vm.formKey,
                  child: SizedBox(
                    width: 500,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              vm.locales.confirmAccount,
                              textScaleFactor: 1.5,
                            ),
                          ),
                          spacer,
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: vm.locales.actualPassword,
                              icon: const Icon(Icons.lock),
                            ),
                            onSaved: (String? password) {
                              vm.actualPassword = password!;
                            },
                            onChanged: (String? password) {
                              vm.clearActualPasswordError();
                              vm.actualPassword = password;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: vm.validateActualPassword,
                          ),
                          spacer,
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: vm.locales.newPassword,
                              icon: const Icon(Icons.lock),
                            ),
                            onSaved: (String? password) {
                              vm.newPassword = password!;
                            },
                            onChanged: (String? password) {
                              vm.clearNewPasswordError();
                              vm.newPassword = password;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: vm.validateNewPassword,
                          ),
                          spacer,
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: vm.locales.confirmNewPassword,
                              icon: const Icon(Icons.lock),
                            ),
                            onSaved: (String? password) {
                              vm.newConfirmPassword = password!;
                            },
                            onChanged: (String? password) {
                              vm.clearNewPasswordError();
                              vm.newConfirmPassword = password;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: vm.validateConfirmPassword,
                          ),
                          spacer,
                          spacer,
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: vm.confirmPassword,
                              child: Text(vm.locales.save),
                            ),
                          ),
                        ]),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
