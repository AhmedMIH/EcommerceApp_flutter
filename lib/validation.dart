String passwordValidation(password){
  Pattern pattern =
      r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(password))
    return 'Invalid password';
  else
    return null;
}
