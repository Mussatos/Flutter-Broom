class BankInfo {
  int? diaristId;
  String? bankName;
  String? accountName;
  String? pixKey;
  int? agency;
  int? accountNumber;

  BankInfo(
      {required this.diaristId,
      required this.bankName,
      required this.accountName,
      required this.accountNumber,
      required this.agency,
      required this.pixKey});

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
        accountName: json['account_name'],
        accountNumber: json['account_number'],
        agency: json['agency'],
        bankName: json['bank_name'],
        diaristId: json['diarist_id'],
        pixKey: json['pix_key']);
  }
  Map<String, dynamic> toJson() {
    return {
      'account_name': accountName,
      'account_number': accountNumber,
      'agency': agency,
      'bank_name': bankName,
      'diarist_id': diaristId,
      'pix_key': pixKey
    };
  }
}
