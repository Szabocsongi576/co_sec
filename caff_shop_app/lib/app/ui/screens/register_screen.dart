import 'package:caff_shop_app/app/routes/routes.dart';
import 'package:caff_shop_app/app/stores/screen_stores/register_store.dart';
import 'package:caff_shop_app/app/ui/widget/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterStore _store = RegisterStore();

  final Map<String, TextEditingController> _textControllers = {
    "username": TextEditingController(),
    "email": TextEditingController(),
    "password": TextEditingController(),
    "password_confirmation": TextEditingController(),
  };

  final Map<String, FocusNode> _focusNodes = {
    "username": FocusNode(),
    "email": FocusNode(),
    "password": FocusNode(),
    "password_confirmation": FocusNode(),
  };

  @override
  Widget build(BuildContext context) {
    return Loading(
      store: _store.loadingStore,
      isExpandable: true,
      appBar: AppBar(
        title: Text(tr('appbar.register')),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.r),
        child: Center(
          child: _buildRegisterArea(),
        ),
      ),
    );
  }

  Widget _buildRegisterArea() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildUsername(),
              SizedBox(height: 15.h),
              _buildEmail(),
              SizedBox(height: 15.h),
              _buildPassword(),
              SizedBox(height: 15.h),
              _buildPasswordConfirmation(),
              SizedBox(height: 25.h),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsername() {
    return Observer(
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5.r),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: tr("hint.username"),
            errorText: _store.usernameError,
          ),
          controller: _textControllers["username"],
          focusNode: _focusNodes["username"],
          onChanged: (value) =>
              _store.username = _textControllers["username"]!.text,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focusNodes["email"]);
          },
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Observer(
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5.r),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: tr("hint.email"),
            errorText: _store.emailError,
          ),
          keyboardType: TextInputType.emailAddress,
          controller: _textControllers["email"],
          focusNode: _focusNodes["email"],
          onChanged: (value) => _store.email = _textControllers["email"]!.text,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_focusNodes["password"]);
          },
        ),
      ),
    );
  }

  Widget _buildPassword() {
    return Observer(
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5.r),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: tr("hint.password"),
            errorText: _store.passwordError,
            suffixIcon: Observer(
              builder: (_) => IconButton(
                onPressed: () =>
                    _store.obscurePassword = !_store.obscurePassword,
                icon: Icon(
                  _store.obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
            ),
          ),
          obscureText: _store.obscurePassword,
          controller: _textControllers["password"],
          focusNode: _focusNodes["password"],
          onChanged: (value) =>
              _store.password = _textControllers["password"]!.text,
          onFieldSubmitted: (value) {
            FocusScope.of(context)
                .requestFocus(_focusNodes["password_confirmation"]);
          },
        ),
      ),
    );
  }

  Widget _buildPasswordConfirmation() {
    return Observer(
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5.r),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: tr("hint.password_confirmation"),
            errorText: _store.passwordConfirmationError,
            suffixIcon: Observer(
              builder: (_) => IconButton(
                onPressed: () => _store.obscurePasswordConfirmation =
                    !_store.obscurePasswordConfirmation,
                icon: Icon(
                  _store.obscurePasswordConfirmation
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
            ),
          ),
          obscureText: _store.obscurePasswordConfirmation,
          controller: _textControllers["password_confirmation"],
          focusNode: _focusNodes["password_confirmation"],
          onChanged: (value) => _store.passwordConfirmation =
              _textControllers["password_confirmation"]!.text,
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _onRegisterPressed,
              child: Text(tr('button.register')),
            ),
          ),
        ],
      ),
    );
  }

  //general methods:------------------------------------------------------------
  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<void> unFocus() async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
      await Future<void>.delayed(Duration(milliseconds: 300));
    }
  }

  Future<void> _onRegisterPressed() async {
    await unFocus();
    _store.register(
      onSuccess: () {
        Navigator.of(context).pushNamed(Routes.home);
      },
      onError: _showSnackBar,
    );
  }
}
