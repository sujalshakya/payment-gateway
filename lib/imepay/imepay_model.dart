class ImePayModel {
  final String merchantCode;
  final String merchantName;
  final String module;
  final String user;
  final String password;

  ImePayModel({
    required this.merchantCode,
    required this.merchantName,
    required this.module,
    required this.user,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'merchant_code': merchantCode,
      'merchant_name': merchantName,
      'module': module,
      'user': user,
      'password': password,
    };
  }

  factory ImePayModel.fromJson(Map<String, dynamic> json) {
    return ImePayModel(
      merchantCode: json['merchant_code'],
      merchantName: json['merchant_name'],
      module: json['module'],
      user: json['user'],
      password: json['password'],
    );
  }
}
