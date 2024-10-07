bool validEmail(String input) {
  const validator = r'^[a-zA-Z0-9.-<>$#%]+@+[a-zA-Z]+[\.a-zA-Z]{2,}[\.a-zA-Z]*$';

  return input == '' ? true : RegExp(validator).hasMatch(input);
}

/*
bool validPassword(String input) {
  const validator =
      r'^(?=.[a-z])(?=.[A-Z])(?=.[0-9])(?=.[@!=,;<>_:+*-/%#$.()\]){8,}';

  return input == '' ? true : RegExp(validator).hasMatch(input);
}
*/

bool validPassword(String input) {
  const validator =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@$!%*?&.,;:_+=<>-])[A-Za-z0-9@$!%*?&.,;:_+=<>-]{8,}$';

  return input == '' ? true : RegExp(validator).hasMatch(input);
}

bool validName(String input) {
  const validator = r"^[a-zA-ZÀ-ÿ\s]{2,}$";

  return input == '' ? false : RegExp(validator).hasMatch(input);
}
