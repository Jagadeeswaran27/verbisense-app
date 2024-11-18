class Regex {
  Regex._();
  static const emailRegEx = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
  static const phoneRegEx = r"^(?:\+91|91|0)?[6-9]\d{9}$";
  static const zipCodeRegex = r"^\d{6}$";
}
