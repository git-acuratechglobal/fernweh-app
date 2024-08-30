import 'package:flutter_riverpod/flutter_riverpod.dart';

final validatorsProvider = Provider<Validators>((ref) {
  return Validators();
});

class Validators {
  final emailRegex =
      r"^((([a-z]|\d|[!#\$%&'*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
  String pattern =
      r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email Field can't be empty";
    } else if (!RegExp(emailRegex).hasMatch(email)) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password field can't be empty";
    } else if (password.length < 8) {
      return "Password must contain atleast 8 characters";
    }
    return null;
  }

  String? conformPassword(String? password, String? newPassword) {
    if (newPassword == null || newPassword.isEmpty) {
      return "Password field can't be empty";
    } else if (password != newPassword) {
      return "Enter same Password";
    }
    return null;
  }

  String? validateMobile(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "Phone field can't be empty";
    } else if (phone.length < 10) {
      return "Please entre correct mobile number";
    }else if (phone.startsWith(" ")){
      return "Please entre correct mobile number";
    }
    return null;
  }

  String? validateOTP(String? otp) {
    if (otp == null || otp.isEmpty) {
      return "OTP field can't be empty";
    } else if (otp.length < 6) {
      return "OTP must contain atleast 6 digits";
    }
    return null;
  }

  String? validateConfirmPassword(String? confirmPassword, String password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Confirm Password field can't be empty";
    } else if (confirmPassword != password) {
      return "Confirm password filed can't be matched with password field";
    }
    return null;
  }

  String? validateTermsAccepted(value) {
    if (value == null || value == false) {
      return "Please agree to terms and conditions.";
    }
    return null;
  }

  String? validateGender(String? gender) {
    return validate(gender, "Please select a gender");
  }

  String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }
    if (name.startsWith(" ")) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? validateNotempty(String? name) {
    return validate(name, "Field can't be empty");
  }

  String? validate(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  String? itineraryName(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    if (value.startsWith(" ")) {
      return '';
    }
    return null;
  }
}
