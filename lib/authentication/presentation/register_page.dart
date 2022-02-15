import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/authentication/application/register/register_bloc.dart';
import 'package:puzzle/helpers/responsive_helper.dart';
import 'package:puzzle/injection/injection.dart';
import 'package:puzzle/l10n/l10n.dart';
import 'package:puzzle/routes/routes.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterBloc>(),
      child: const RegisterView(
        key: Key('login_view'),
      ),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final _emailTextController = TextEditingController();
    final _passwordTextController = TextEditingController();
    final _confirmPasswordTextController = TextEditingController();
    _emailTextController.addListener(() {
      context.read<RegisterBloc>().add(
            EmailChanged(_emailTextController.value.text),
          );
    });
    _passwordTextController.addListener(() {
      context.read<RegisterBloc>().add(
            PasswordChanged(
              password: _passwordTextController.value.text,
              confirmPassword: _confirmPasswordTextController.value.text,
            ),
          );
    });
    _confirmPasswordTextController.addListener(() {
      context.read<RegisterBloc>().add(
            ConfirmPasswordChanged(
              password: _passwordTextController.value.text,
              confirmPassword: _confirmPasswordTextController.value.text,
            ),
          );
    });
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary
            ],
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Register error!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            if (state.successful) {
              Navigator.of(context).pushReplacementNamed(
                RouteGenerator.mainPage,
              );
            }
          },
          builder: (context, state) {
            return Form(
              autovalidateMode: AutovalidateMode.always,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color.fromRGBO(255, 255, 255, 0.7)
                        : const Color.fromRGBO(0, 0, 0, 0.7),
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
                          key: const Key('registerpage_email_field'),
                          controller: _emailTextController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            labelText: l10n.registerFormEmail,
                          ),
                          style: const TextStyle().copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (state.errorEmail) {
                              return l10n.registerFormEmailError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          key: const Key('registerpage_password_field'),
                          controller: _passwordTextController,
                          obscureText: true,
                          style: const TextStyle().copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: l10n.registerFormPassword,
                          ),
                          validator: (value) {
                            if (state.errorPassword) {
                              return l10n.registerFormPasswordError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          key: const Key('registerpage_confirm_password_field'),
                          controller: _confirmPasswordTextController,
                          obscureText: true,
                          style: const TextStyle().copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelText: l10n.registerFormRepeatPassword,
                          ),
                          validator: (value) {
                            if (state.errorConfirmPassword) {
                              return l10n.registerFormPasswordEqualError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          key: const Key('registerpage_register_button'),
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
                            context.read<RegisterBloc>().add(
                                  const AttemptRegister(),
                                );
                          },
                          child: Text(
                            l10n.registerFormButton,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          key: const Key('registerpage_login_link'),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              RouteGenerator.loginPage,
                            );
                          },
                          child: Text(
                            l10n.registerFormLoginLink,
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
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
