import 'package:e_commerce_app_flutter/provider/notification_provider.dart';
import 'package:e_commerce_app_flutter/provider/register_provider.dart';
import 'package:e_commerce_app_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/login_social_item.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _usernameController,
      _emailController,
      _passwordController;
  late FocusNode _usernameFocusNode, _emailFocusNode, _passwordFocusNode;
  bool visibility = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    return Consumer<RegisterProvider>(
        builder: (context, registerProvider, child) {
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
                      'Create Account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Let's, create your account",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: AppColors.gray),
                    ),
                    const SizedBox(height: 36),
                    Text(
                      'Username',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        } else {
                          return null;
                        }
                      },
                      focusNode: _usernameFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        _usernameFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Create your username',
                        prefixIcon: Icon(Icons.person),
                        prefixIconColor: AppColors.gray,
                      ),
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
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                        prefixIconColor: AppColors.gray,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Text(
                      'Password ',
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
                          registerProvider.register(
                              email: _emailController.text,
                              password: _passwordController.text,
                              username: _usernameController.text,
                              notificationProvider: notificationProvider,
                              context: context);
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
                            child: Icon(visibility
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        suffixIconColor: AppColors.gray,
                      ),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed:
                            registerProvider.state == RegisterState.loading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      registerProvider.register(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          username: _usernameController.text,
                                          notificationProvider:
                                              notificationProvider,
                                          context: context);
                                    }
                                  },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: AppColors.white),
                        child: registerProvider.state == RegisterState.loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                'Sign Up',
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
                      title: 'Sign In with Google ',
                      onTap: () {},
                    ),
                    const SizedBox(height: 16.0),
                    LoginSocialItem(
                      color: AppColors.blue,
                      icon: FontAwesomeIcons.facebookF,
                      title: 'Sign In with Facebook',
                      onTap: () {},
                    ),
                    const SizedBox(height: 86),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
