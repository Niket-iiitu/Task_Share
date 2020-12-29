String usernameVal(String val) {
  return val.isEmpty || val.length < 3
      ? "Username must have at least 3 characters"
      : null;
}

String positionVal(String val) {
  return val.isEmpty ? "Enter position name" : null;
}

String emailVal(String val) {
  return RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(val)
      ? null
      : "Please provide valid Email";
}

String passwordVal(String val) {
  return val.length > 6 ? null : "Password must have 6+ characters.";
}
