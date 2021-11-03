class User {
  final int iduser;
  final String username;
  final String email;
  final String password;
  final double amount;

  User(this.iduser, [this.username = '', this.email = '', this.password = '', this.amount = 10000]);

  Map<String, dynamic> toDB() {
    return {
      'iduser': iduser,
      'username': username,
      'email': email,
      'password': password,
      'amount': amount,
    };
  }

  factory User.fromDB(Map<String, dynamic> data) {
    return User(
      data['iduser'] as int,
      data['username'] as String,
      data['email'] as String,
      data['password'] as String,
      data['amount'] ?? 0,
    );
  }
}
