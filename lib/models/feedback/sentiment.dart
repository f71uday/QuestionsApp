enum Sentiment {
  POSITIVE,
  NEUTRAL,
  NEGATIVE;

  bool equals(String value) {
    return name == value;
  }
}
