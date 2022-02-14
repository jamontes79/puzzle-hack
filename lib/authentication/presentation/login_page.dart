import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/authentication/application/auth/auth_bloc.dart';
import 'package:puzzle/authentication/application/login/login_bloc.dart';
import 'package:puzzle/helpers/responsive_helper.dart';
import 'package:puzzle/injection/injection.dart';
import 'package:puzzle/l10n/l10n.dart';
import 'package:puzzle/routes/routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: const LoginView(
        key: Key('login_view'),
      ),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final _emailTextController = TextEditingController();
    final _passwordTextController = TextEditingController();
    _emailTextController.addListener(
      () {
        context.read<LoginBloc>().add(
              EmailChanged(_emailTextController.value.text),
            );
      },
    );
    _passwordTextController.addListener(
      () {
        context.read<LoginBloc>().add(
              PasswordChanged(_passwordTextController.value.text),
            );
      },
    );
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 19, 74, 159),
              Color.fromARGB(255, 109, 184, 246),
            ],
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login error!'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state.successful) {
              context.read<AuthBloc>().add(const CheckStatus());
              Navigator.of(context).pushReplacementNamed(
                RouteGenerator.mainPage,
              );
            }
          },
          builder: (context, state) {
            return Form(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: ResponsiveHelper.getDevice(context) == Device.mobile
                      ? MediaQuery.of(context).size.width
                      : 500,
                  height: ResponsiveHelper.getDevice(context) == Device.mobile
                      ? MediaQuery.of(context).size.height
                      : 560,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        Text(
                          l10n.appBarTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 80,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        TextFormField(
                          key: const Key('loginpage_email_field'),
                          controller: _emailTextController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            labelText: l10n.loginFormEmail,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style:
                              const TextStyle().copyWith(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          key: const Key('loginpage_password_field'),
                          controller: _passwordTextController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: l10n.loginFormPassword,
                          ),
                          style:
                              const TextStyle().copyWith(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          key: const Key('loginpage_login_button'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            context.read<LoginBloc>().add(
                                  const AttemptLogin(),
                                );
                          },
                          child: Text(
                            l10n.loginFormButton,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: state.validating,
                          child: const LinearProgressIndicator(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          key: const Key('loginpage_glogin_button'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              RouteGenerator.mainPage,
                            );
                          },
                          child: Text(
                            l10n.loginFormGoogleButton,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          key: const Key('loginpage_register_link'),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              RouteGenerator.registerPage,
                            );
                          },
                          child: Text(
                            l10n.loginFormRegisterLink,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
