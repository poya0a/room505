import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:room505/main.dart';
import 'package:room505/auth.dart';
import 'package:provider/provider.dart';
import 'package:room505/config/conf.dart';
import 'package:room505/config/palette.dart';
import 'package:room505/common/customTextFromField.dart';
import 'package:room505/common/dupleCheckField.dart';
import 'package:room505/common/buttonFooter.dart';

class Join extends StatefulWidget {
  const Join({Key? key}) : super(key: key);

  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword = '';
  String userPasswordConfirm = '';
  String userName = '';
  String userPhoneNumber = '';
  String userBirthdate = '';
  List<int> userTermsSeq = [];
  List<Map<String, String>> errors = [];
  bool emailButtonDisabled = true;
  bool emailCheck = false;
  bool setDisabled = true;

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  Widget buildEmailField() {
    return DupleCheckField(
      keyValue: 1,
      label: "이메일",
      type: TextInputType.emailAddress,
      hintText: '이메일을 입력해 주세요.',
      onChanged: (value) {
        setState(() {
          userEmail = value;
          emailCheck = false;
          clearErrors('email');
          final emailRegex = RegExp(
              r'^[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9.-]+\.(?:kr|co\.kr|or\.kr|ne\.kr|re\.kr|pe\.kr|go\.kr|com|net|org|biz|info|name))$');
          if (value != "" && !emailRegex.hasMatch(value)) {
            setErrors('email', '이메일 형식이 올바르지 않습니다.');
            emailButtonDisabled = true;
          } else if (value == "") {
            emailButtonDisabled = true;
          } else {
            emailButtonDisabled = false;
          }
          updateButtonState();
        });
      },
      onTap: () async {
        try {
          final String url = requests("DUPLICATE");
          final response =
              await http.post(Uri.parse(url), body: {"email": userEmail});

          if (response.statusCode == 200) {
            final responseData = jsonDecode(response.body);
            final resultCode = responseData['resultCode'];
            final resultMsg = responseData['msg'];
            setState(() {
              emailButtonDisabled = resultCode;
              emailCheck = resultCode;
            });
            showResultDialog(false, resultMsg);
          }
        } catch (e) {
          print(e);
        } finally {
          updateButtonState();
          setState(() {
            showSpinner = false;
          });
        }
      },
      buttonDisabled: emailButtonDisabled,
      errorMessage: errors.isNotEmpty && errors[0]['email'] != null
          ? errors[0]['email']!
          : "",
    );
  }

  Widget buildPasswordField() {
    return CustomTextFormField(
      keyValue: 2,
      label: "비밀번호",
      obscureText: true,
      type: TextInputType.visiblePassword,
      hintText: '영문, 숫자 포함 8글자 이상 입력해 주세요.',
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
      ],
      onChanged: (value) {
        setState(() {
          userPassword = value;
          clearErrors('password');
          final passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9]).{8,25}$');
          if (value != "" && !passwordRegex.hasMatch(value)) {
            setErrors('password', '영문, 숫자 포함 8자리 이상 입력해 주세요.');
          }
          updateButtonState();
        });
      },
      errorMessage: errors.isNotEmpty && errors[0]['password'] != null
          ? errors[0]['password']!
          : "",
    );
  }

  Widget buildPasswordConfirmField() {
    return CustomTextFormField(
      keyValue: 3,
      label: "비밀번호 확인",
      obscureText: true,
      type: TextInputType.visiblePassword,
      hintText: '비밀번호 한 번 더 입력해 주세요.',
      inputFormatters: [
        LengthLimitingTextInputFormatter(25),
      ],
      onChanged: (value) {
        setState(() {
          userPasswordConfirm = value;
          clearErrors('passwordConfirm');
          if (value != "" && userPassword != value) {
            setErrors('passwordConfirm', '비밀번호가 일치하지 않습니다.');
          }
          updateButtonState();
        });
      },
      errorMessage: errors.isNotEmpty && errors[0]['passwordConfirm'] != null
          ? errors[0]['passwordConfirm']!
          : "",
    );
  }

  Widget buildNameField() {
    return CustomTextFormField(
      keyValue: 4,
      label: "이름",
      type: TextInputType.name,
      hintText: '이름을 입력해 주세요.',
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
      ],
      onChanged: (value) {
        setState(() {
          userName = value;
          clearErrors('name');
          final nameRegex = RegExp(r'^[가-힣a-zA-Z]+$');
          if (value != "" && !nameRegex.hasMatch(value)) {
            setErrors('name', '이름 형식이 올바르지 않습니다.');
          }
          updateButtonState();
        });
      },
      errorMessage: errors.isNotEmpty && errors[0]['name'] != null
          ? errors[0]['name']!
          : "",
    );
  }

  Widget buildphoneNumberField() {
    return CustomTextFormField(
      keyValue: 5,
      label: "휴대폰 번호",
      type: TextInputType.phone,
      hintText: '-없이 숫자만 입력해 주세요.',
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(11),
      ],
      onChanged: (value) {
        setState(() {
          userPhoneNumber = value;
          clearErrors('phone');
          final phoneRegex = RegExp(r'[0-9].{10,11}$');
          if (value != "" && !phoneRegex.hasMatch(value)) {
            setErrors('phone', '휴대폰 번호 형식이 올바르지 않습니다.');
          }
          updateButtonState();
        });
      },
      errorMessage: errors.isNotEmpty && errors[0]['phone'] != null
          ? errors[0]['phone']!
          : "",
    );
  }

  Widget buildBirthdateField() {
    return CustomTextFormField(
      keyValue: 6,
      label: "생년월일",
      type: TextInputType.number,
      hintText: '예) 19900101',
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(8),
      ],
      onChanged: (value) {
        setState(() {
          userBirthdate = value;
          clearErrors('birthdate');
          if (value.length < 8) {
            setErrors('birthdate', '생년월일 형식이 올바르지 않습니다.');
          } else {
            final year = int.parse(value.substring(0, 4));
            final month = int.parse(value.substring(4, 6));
            final day = int.parse(value.substring(6, 8));

            final isLeapYear =
                (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;

            final yearCheck = year >= 1900 && year <= DateTime.now().year;
            final monthCheck = month >= 1 && month <= 12;
            final dayCheckLeapYear =
                isLeapYear ? (day >= 1 && day <= 29) : (day >= 1 && day <= 28);
            final dayCheckMonth =
                (month == 4 || month == 6 || month == 9 || month == 11)
                    ? (day >= 1 && day <= 30)
                    : (day >= 1 && day <= 31);

            if (!yearCheck ||
                !monthCheck ||
                !dayCheckLeapYear ||
                !dayCheckMonth) {
              setErrors('birthdate', '생년월일 형식이 올바르지 않습니다.');
            }
          }
          updateButtonState();
        });
      },
      errorMessage: errors.isNotEmpty && errors[0]['birthdate'] != null
          ? errors[0]['birthdate']!
          : "",
    );
  }

  void setErrors(key, message) {
    Map<String, String> errorList = {};
    errorList[key] = message;
    errors.add(errorList);
  }

  void clearErrors(key) {
    errors.removeWhere((element) => element.containsKey(key));
  }

  void updateButtonState() {
    if (userEmail.isNotEmpty &&
        userPassword.isNotEmpty &&
        userPasswordConfirm.isNotEmpty &&
        userName.isNotEmpty &&
        userPhoneNumber.isNotEmpty &&
        userBirthdate.isNotEmpty &&
        emailCheck &&
        errors.length < 1) {
      setState(() {
        setDisabled = false;
      });
    } else {
      setState(() {
        setDisabled = true;
      });
    }
  }

  void showResultDialog(bool code, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (code) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const App(),
                    ),
                  );
                }
              },
              child: const Text(
                '닫기',
                style: TextStyle(color: Palette.blueColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void handleButtonJoin() async {
    try {
      final String url = requests("AUTHENTICATION");

      Map<String, dynamic> userData = {
        'userEmail': userEmail,
        'userPwd': userPassword,
        'userName': userName,
        'userPhone': userPhoneNumber,
        'userBirth': userBirthdate,
        'termsSeq': userTermsSeq,
      };

      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(userData));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final resultCode = responseData['resultCode'];
        final resultMsg = responseData['msg'];
        showResultDialog(resultCode, resultMsg);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userTermsSeq =
        Provider.of<AuthProvider>(context, listen: false).getTermsSeq();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(
                    minWidth: 300,
                    minHeight: 500,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(25, 25, 112, 1),
                        Color.fromRGBO(11, 11, 49, 1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              color: Palette.subColor,
                              padding: EdgeInsets.only(left: 14),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Text(
                              '회원가입',
                              style: TextStyle(
                                color: Palette.subColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        margin: EdgeInsets.only(top: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildEmailField(),
                              const SizedBox(
                                height: 20,
                              ),
                              buildPasswordField(),
                              const SizedBox(
                                height: 20,
                              ),
                              buildPasswordConfirmField(),
                              const SizedBox(
                                height: 20,
                              ),
                              buildNameField(),
                              const SizedBox(
                                height: 20,
                              ),
                              buildphoneNumberField(),
                              const SizedBox(
                                height: 20,
                              ),
                              buildBirthdateField(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ButtonFooter(
        text: "회원가입",
        disabled: setDisabled,
        onPressed: handleButtonJoin,
      ),
    );
  }
}
