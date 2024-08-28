import 'package:e_commerce_app_flutter/provider/login_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:e_commerce_app_flutter/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/login_social_item.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController, _passwordController;
  late FocusNode _emailFocusNode, _passwordFocusNode;
  bool visibility = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 36),
                      Text(
                        'Login Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Please, login with registered account!',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: AppColors.gray),
                      ),
                      const SizedBox(height: 36),
                      Text(
                        'Email',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          _emailFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email),
                          prefixIconColor: AppColors.gray,
                        ),
                      ),
                      const SizedBox(height: 36),
                      Text(
                        'Password',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        onEditingComplete: () {
                          if (_formKey.currentState!.validate()) {
                            loginProvider.login(
                              context,
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          } else {
                            return null;
                          }
                        },
                        obscureText: !visibility,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock),
                          prefixIconColor: AppColors.gray,
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                visibility = !visibility;
                              });
                            },
                            child: Icon(
                              visibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          suffixIconColor: AppColors.gray,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox.shrink(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: loginProvider.state == LoginState.loading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    loginProvider.login(
                                      context,
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: AppColors.white,
                          ),
                          child: loginProvider.state == LoginState.loading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.white,
                                  ),
                                )
                              : Text(
                                  'Login',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w500),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Or using other methods:',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: AppColors.gray),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      LoginSocialItem(
                        color: AppColors.red,
                        icon: FontAwesomeIcons.google,
                        title: 'Login with Google',
                        onTap: () {},
                      ),
                      const SizedBox(height: 16.0),
                      LoginSocialItem(
                        color: AppColors.blue,
                        icon: FontAwesomeIcons.facebookF,
                        title: 'Login with Facebook',
                        onTap: () {},
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: AppColors.gray),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.register);
                            },
                            child: Text(
                              'Register',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
