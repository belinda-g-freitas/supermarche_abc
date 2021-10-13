class User {
  final String username;
  final String email;
  final String password;
  final double amount;
  // final users;

  User(/* this.users */this.username, this.email, this.password, this.amount);

  Map<String, dynamic> toDB() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'amount': amount,
    };
  }

  factory User.fromDB(Map<String, dynamic> data) {
    return User(
      data['username'] as String,
      data['email'] as String,
      data['password'] as String,
      data['amount'] ?? 0,
      // data['users']
    );
  }
}
