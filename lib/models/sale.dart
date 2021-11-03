class Sale {
  final String idsale;
  final String customer;
  final double amount;

  Sale(this.customer, this.idsale, this.amount);

  Map<String, dynamic> toDB() {
    return {
      'idsale': idsale,
      'user': customer,
      'amount': amount,
    };
  }

  factory Sale.fromDB(Map<String, dynamic> data) {
    return Sale(
      data['idsale'],
      data['user'],
      data['amount'],
    );
  }
}
