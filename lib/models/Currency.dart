List currencylist = <currencyclass>[];

class currencyclass {
  String? currency_id;
  String? currency_name;
  String? currency_shortcut;
  String? currency_rate;
  String? country_currency;

  currencyclass({
    this.currency_id,
    this.currency_name,
    this.currency_shortcut,
    this.currency_rate,
    this.country_currency,
  });
   currencyclass.fromJson(Map<String, dynamic> json) {
    currencylist.add(currencyclass(
      currency_id: json['currency_id'].toString(),
      currency_name: json['currency_name'].toString(),
      currency_shortcut: json['currency_shortcut'].toString(),
      currency_rate: json['currency_rate'].toString(),
      country_currency: json['country_currency'].toString(),
    ));
  }
}
