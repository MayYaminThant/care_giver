class RegExpUtils {
  static final username = RegExp(r'[\/A-Z ]+');

  static final onlyTwoDigits = RegExp(r'^\d+\.?\d{0,2}');

  static final phoneNumber = RegExp(r'[+0-9]+');

  static final email =
      RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');

  //   r'^
  //   (?=.*[A-Z])       // should contain at least one upper case
  //   (?=.*[a-z])       // should contain at least one lower case
  //   (?=.*?[0-9])      // should contain at least one digit
  //   (?=.*?[!@#\$&*~]) // should contain at least one Special character
  //   .{8,}             // Must be at least 8 characters in length
  //   $
  static final password = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );
}
