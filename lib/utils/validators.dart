bool validEmail(String input) {
  const validator = r'^[a-zA-Z0-9.-<>$#%]+@+[a-zA-Z]+[\.a-zA-Z]{2,}[\.a-zA-Z]*$';

  return input == '' ? true : RegExp(validator).hasMatch(input);
}

bool validPassword(String input) {
  const validator =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[@$!%*?&.,;:_+=<>-])[A-Za-z0-9@$!%*?&.,;:_+=<>-]{8,}$';

  return input == '' ? true : RegExp(validator).hasMatch(input);
}

bool validName(String input) {
  const validator = r"^[a-zA-ZÀ-ÿ\s]{2,}$";

  return input == '' ? false : RegExp(validator).hasMatch(input);
}

bool validCpf(String cpf){
    var notNumber = new RegExp(r'^[^0-9]$');
    if(cpf.replaceAll(notNumber, '').length != 11 || isRepeatedNumbers(cpf)) return false;

    
    return firstValidateNumber(cpf) && secondValidateNumber(cpf);
}

bool isRepeatedNumbers(String cpf) {
    return cpf.split('').every((String num)=> num == cpf[0]);
}

// ToDo -> Refatorar para uma única função, ou quebrar o código repetido em funções menores :)
bool firstValidateNumber(String cpf) {
    int valToMultiply = 10;
    double sum = 0;
    List<int> cpfNumbers = cpf.split('').map((String num) => int.parse(num)).toList();

    for(int i=0; i <= 8; i++){
        sum += cpfNumbers[i]*valToMultiply--;
    }
    
    if(sum%11 < 2) {
        return cpfNumbers[cpfNumbers.length-2] == 0;
    }

    return cpfNumbers[cpfNumbers.length-2] == 11-(sum%11);
}

bool secondValidateNumber(String cpf) {
    int valToMultiply = 11;
    double sum = 0;
     List<int> cpfNumbers = cpf.split('').map((String num) => int.parse(num)).toList();

    for(int i=0; i < 10; i++){
        sum += cpfNumbers[i]*valToMultiply--;
    }
    
    if(sum%11 < 2) {
        return cpfNumbers[cpfNumbers.length-1] == 0;
    }
    
    return cpfNumbers[cpfNumbers.length-1] == 11-(sum%11);
}