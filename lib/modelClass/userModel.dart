class model{
  String userName;
  String emaill;
  String password;
  String createdAt;

  model({required this.userName, required this.emaill, required this.password, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'userName': this.userName,
      'emaill': this.emaill,
      'password': this.password,
      'createdAt': this.createdAt,
    };
  }

  factory model.fromMap(Map<String, dynamic> map) {
    return model(
      userName: map['userName'] as String,
      emaill: map['emaill'] as String,
      password: map['password'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}