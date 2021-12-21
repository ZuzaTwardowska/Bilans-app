class Numeric {
  static String formatPrice(String value) {
    if (!value.contains('.')) return value + ".00";
    if (value.substring(value.indexOf('.') + 1).isEmpty) return value + "00";
    if (value.substring(value.indexOf('.') + 1).length == 1) return value + "0";
    if (value.substring(value.indexOf('.') + 1).length > 2) {
      return value.substring(0, value.indexOf('.') + 3);
    }
    return value;
  }
}
