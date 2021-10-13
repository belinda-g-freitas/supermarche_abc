class Achat {
  final String idtrans;
  final String customer;
  final double amount;

  Achat(this.customer, this.idtrans, this.amount);

  Map<String, dynamic> toDB() {
    return {
      'idtrans': idtrans,
      'customer': customer,
      'amount': amount,
    };
  }

  factory Achat.fromDB(Map<String, dynamic> data) {
    return Achat(
      data['idtrans'],
      data['customer'],
      data['amount'],
    );
  }
}
