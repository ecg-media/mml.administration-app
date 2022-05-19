import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/change_password.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

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

              // TODO: Implement password change, if isConfirmed is false!
              return Container();
            },
          );
        },
      ),
    );
  }
}
