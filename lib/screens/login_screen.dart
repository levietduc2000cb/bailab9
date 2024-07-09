import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bailab9/apis/login_response.dart';
import '../utils/local_storage.dart';
import '../utils/constant.dart';
import '../apis/http_service.dart';
import '../apis/login_request.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login',
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final _formLoginKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isRememberMe = false;
  bool isVisibilityPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(
            child: SingleChildScrollView(
                child: Image.asset(
          "images/bg.jpeg",
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ))),
        Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10.0), // bo góc border
                ),
                child: Form(
                  key: _formLoginKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text('Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 31,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      const Text("Username",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TextFormField(
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller: userNameController,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .white), // Màu sắc của đường viền khi không có tiêu điểm (focus)
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            suffixIcon:
                                Icon(Icons.verified_user, color: Colors.white),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your user name';
                            }
                            return null;
                          }),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: const Text("Password",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      TextFormField(
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          obscureText: isVisibilityPassword ? false : true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Màu sắc của đường viền khi không có tiêu điểm (focus)
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isVisibilityPassword =
                                          !isVisibilityPassword;
                                    });
                                  },
                                  child: Icon(
                                      isVisibilityPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          }),
                      CheckboxListTile(
                          title: Transform.translate(
                              offset: const Offset(-10, 0),
                              child: const Text("Remember Me",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold))),
                          value: isRememberMe,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.blue,
                          checkColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          onChanged: (value) {
                            setState(() {
                              isRememberMe = !isRememberMe;
                            });
                          }),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: handleLogin,
                            child: const Text("Log In")),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }

  Future handleLogin() async {
    LoginRequest userLogin = LoginRequest(
        username: userNameController.text.trim(),
        password: passwordController.text.trim());

    try{
      LoginResponse? user = await HttpService.login(userLogin);
      if (!mounted) return;
      if (user != null) {
        LocalStorage.setValue(Constants.token, user.token);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User name or password is not valid!!!'),
          ),
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login is failure!!!'),
        ),
      );
    }
  }
}
