extension TempParsing on double? {
  int roundTempNumber() {
    return this!.round();
  }

  String roundTempString() {
    return this!.round().toString();
  }
}
