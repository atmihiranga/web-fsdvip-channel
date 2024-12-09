String extractCurrency(String price) {
  RegExp regex = RegExp(r'[\$A-Za-z]+');
  Match? match = regex.firstMatch(price);
  return match?.group(0) ?? '';
}
