import 'package:flutter/material.dart';
import 'package:flutter_rhine/common/common.dart';
import 'package:flutter_rhine/common/constants/constants.dart';
import 'package:flutter_rhine/common/widget/global_progress_bar.dart';

import 'login.dart';

class LoginForm extends StatefulWidget {
  final LoginSuccessCallback loginSuccessCallback;
  final LoginCancelCallback loginCancelCallback;

  LoginForm(this.loginSuccessCallback, this.loginCancelCallback);

  @override
  _LoginFormState createState() =>
      _LoginFormState(loginSuccessCallback, loginCancelCallback);
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final LoginSuccessCallback loginSuccessCallback;
  final LoginCancelCallback loginCancelCallback;

  _LoginFormState(this.loginSuccessCallback, this.loginCancelCallback);

  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      StoreProvider.of<AppState>(context)
          .dispatch(InitialAction(shouldAutoLogin: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginState>(
      converter: (store) {
        final state = store.state.loginState;
        if (Config.DEBUG) print('onNext State: ${state.toString()}');

        final User user = state.user;
        // 登录成功
        if (user != null && loginSuccessCallback != null) {
          loginSuccessCallback(context, user, user.token);
        }
        // 取消登录
        if (state.isLoginCancel) {
          loginCancelCallback(context);
        }
        // 异常事件
        final Exception error = state.error;
        if (error != null) {
          if (error is NetworkRequestException) toast(error.message);
          if (error is LoginFailureException) toast(error.message);
          if (error is EmptyInputException) toast(error.message);
        }
        return state;
      },
      builder: (context, LoginState state) => Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 38.0, 16.0, 8.0),
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.loose,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        /// 顶部图标和标题
                        Row(
                          children: <Widget>[
                            Image(
                              image: AssetImage(imageGithubCat),
                              width: 65.0,
                              height: 65.0,
                              fit: BoxFit.fitWidth,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 32.0),
                              child: Text(
                                'Sign into GitHub',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.normal,
                                  color: colorPrimaryText,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        _usernameInput(),
                        _passwordInput(),
                        _signInButton()
                      ],
                    ),
                  ),
                  StoreConnector<AppState, bool>(
                    converter: (store) => store.state.loginState.isLoading,
                    builder: (context, visibility) =>
                        ProgressBar(visibility: visibility),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  /// 用户名输入框
  Widget _usernameInput() {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final String username = store.state.loginState.username ?? '';
    userNameController.text = username;
    return Container(
      margin: EdgeInsets.only(top: 24.0),
      child: TextField(
        controller: userNameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          labelText: 'Username or email address',
        ),
      ),
    );
  }

  /// 密码输入框
  Widget _passwordInput() {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final String password = store.state.loginState.password ?? '';
    passwordController.text = password;
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          labelText: 'Password',
        ),
      ),
    );
  }

  /// 登录按钮
  Widget _signInButton() {
    final Store<AppState> store = StoreProvider.of<AppState>(context);

    /// 登录按钮点击事件
    void _onLoginButtonClicked(Store<AppState> store) {
      final String username = userNameController.text ?? '';
      final String password = passwordController.text ?? '';

      store
          .dispatch(LoginClickedAction(username: username, password: password));
    }

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 32.0),
      width: double.infinity,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: 50.0,
        ),
        child: FlatButton(
          onPressed: () => _onLoginButtonClicked(store),
          color: colorSecondaryDark,
          highlightColor: colorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          child: Text(
            'Sign in',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
