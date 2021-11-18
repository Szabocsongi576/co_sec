import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:caff_shop_app/app/routes/routes.dart';
import 'package:caff_shop_app/app/stores/screen_stores/login_store.dart';
import 'package:caff_shop_app/app/ui/widget/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginStore _store = LoginStore();

  final Map<String, TextEditingController> _textControllers = {
    "email": TextEditingController(),
    "password": TextEditingController(),
  };

  final Map<String, FocusNode> _focusNodes = {
    "email": FocusNode(),
    "password": FocusNode(),
  };

  @override
  Widget build(BuildContext context) {
    return Loading(
      store: _store.loadingStore,
      appBar: AppBar(
        title: Text(tr('appbar.login')),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(),
              _buildLoginArea(),
              _buildRegisterArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginArea() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEmail(),
            SizedBox(height: 15.h),
            _buildPassword(),
            SizedBox(height: 25.h),
            _buildLoginButton(),
          ],
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
                onPressed: () => _store.obscurePassword = !_store.obscurePassword,
                icon: Icon(
                  _store.obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
          ),
          obscureText: _store.obscurePassword,
          controller: _textControllers["password"],
          focusNode: _focusNodes["password"],
          onChanged: (value) =>
              _store.password = _textControllers["password"]!.text,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _onLoginPressed,
              child: Text(tr('button.login')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterArea() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                tr('caption.dont_have_acc'),
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        //SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _onRegisterTap,
              child: Text(
                tr('caption.registration'),
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: ColorConstants.primary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
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

  Future<void> _onLoginPressed() async {
    await unFocus();
    _store.login(
      onSuccess: () {
        Navigator.of(context).pushNamed(Routes.home);
      },
      onError: _showSnackBar,
    );
  }

  Future<void> _onRegisterTap() async {
    await unFocus();
    Navigator.of(context).pushNamed(Routes.register);
  }
}
