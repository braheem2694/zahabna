List currencyExlist = <currencyExclass>[];

class currencyExclass {
  String? currency_id;
  String? from_to;
  String? from_currency;
  String? to_currency;
  String? Rate;

  currencyExclass({
    this.currency_id,
    this.from_to,
    this.from_currency,
    this.to_currency,
    this.Rate,
  });

   currencyExclass.fromJson(Map<String, dynamic> json) {
    currencyExlist.add(currencyExclass(
      currency_id: json['currency_id'].toString(),
      from_to: json['from_to'].toString(),
      from_currency: json['from_currency'].toString(),
      to_currency: json['to_currency'].toString(),
      Rate: json['Rate'].toString(),
    ));
  }
}
