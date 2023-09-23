import 'package:flutter/material.dart';

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 15.0,
    end: 15.0,
  ),
  child: Container(
    width: double.infinity,
    height: .2,
    color: Colors.grey[300],
  ),
);
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType Type,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  void Function()? onTap,
  required String? Function(String?)? validate,
  required String lable,
  bool isPassword = false,
  required IconData prefix,
  void Function()? suffixPressed,
  bool isClickable = true,
  IconData? suffix,
}) =>
    TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),

      controller: controller,
      keyboardType: Type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      enabled: isClickable,
      validator: validate,
      decoration:InputDecoration(
        labelText: lable,
        labelStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Janna',
        ),
          prefixIcon: Icon(
                color: Colors.white,


                prefix,
              ),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
      )

    );
void navigateTo(context,Widget)=> Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context)=> Widget,
  ),
);