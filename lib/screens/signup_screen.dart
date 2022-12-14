// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_alpha/responsives/mobile_screen_layout.dart';
import 'package:project_alpha/responsives/responsive_layout_screen.dart';
import 'package:project_alpha/responsives/web_screen_layout.dart';
import 'package:project_alpha/screens/login_screen.dart';
import 'package:project_alpha/utils/colors.dart';
import 'package:project_alpha/utils/utils.dart';
import 'package:project_alpha/widgets/text_field_input.dart';

import '../resources/auth_method.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        bio: _bioController.text,
        username: _nameController.text,
        password: _passController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });
    if (res != 'Success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          width: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //svg logo
                  SvgPicture.asset(
                    "assets/ic_instagram.svg",
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(height: 12),
                  //circular widget for profile picture
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64, backgroundImage: MemoryImage(_image!))
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  "https://www.bluefrosthvac.com/wp-content/uploads/2019/08/default-person.png"),
                            ),
                      Positioned(
                        bottom: 0,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo_rounded,
                            size: 38,
                          ),
                        ),
                      )
                    ],
                  ),
                  //name
                  const SizedBox(height: 12),
                  TextFieldInput(
                      textEditingController: _nameController,
                      hintText: "Enter your Name",
                      keyboardType: TextInputType.text),
                  //email
                  const SizedBox(height: 12),
                  TextFieldInput(
                      textEditingController: _emailController,
                      hintText: "Enter your Email",
                      keyboardType: TextInputType.emailAddress),
                  //pass
                  const SizedBox(height: 12),
                  TextFieldInput(
                    textEditingController: _passController,
                    hintText: "Enter password",
                    keyboardType: TextInputType.text,
                    isPass: true,
                  ),
                  //name
                  const SizedBox(height: 12),
                  TextFieldInput(
                      textEditingController: _bioController,
                      hintText: "Tell us about yourself",
                      keyboardType: TextInputType.text),
                  //submit
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: primaryColor,
                            ))
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        color: blueColor,
                      ),
                    ),
                  ),

                  //Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ignore: prefer_const_constructors
                      Text("Already a member?"),
                      GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => const LoginScreen()));
                          Navigator.pushNamed(context, "/Login");
                          setState(() {});
                        },
                        child: Container(
                          child: const Text(
                            "Log in",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          width: 80,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
