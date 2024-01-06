import 'dart:core';

extension TimeParsing on int? {
  String getCurrentTime() {
    DateTime utcNow = DateTime.now().toUtc();

    DateTime localTime = utcNow.add(Duration(seconds: this!));

    return "${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}";
  }
}
