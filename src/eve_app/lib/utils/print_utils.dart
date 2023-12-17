import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

void xtPrint(dynamic toPrint) {
  if (kDebugMode) print('testPrint:: \x1B[33m$toPrint\x1B[0m');
}

void errPrint(dynamic toPrint) {
  if (kDebugMode) print('errPrint:: \x1B[31m$toPrint\x1B[0m');
}

void printYellow(dynamic toPrint) {
  if (kDebugMode) print('printYellowc:: \x1B[33m$toPrint\x1B[0m');
}

void printF(dynamic toPrint) {
  if (kDebugMode) print('printF:: \x1B[33m$toPrint\x1B[0m');
}

void printGreen(dynamic toPrint) {
  if (kDebugMode) print('printGreenc:: \x1B[32m$toPrint\x1B[0m');
}

void printRed(dynamic toPrint) {
  if (kDebugMode) print('printRedc:: \x1B[31m$toPrint\x1B[0m');
}

void printTimer(dynamic toPrint) {
  if (kDebugMode) print('\x1b[30m\x1b[43m$toPrint\x1b[43m\x1b[30m');
}

void printBuild(dynamic toPrint) {
  //build and init prints
  bool activated = false; //set to true to show prints
  // ignore: dead_code
  if (activated && kDebugMode) debugPrint('\x1B[37m$toPrint\x1B[0m');
}

void xPrint(dynamic toPrint) {
  bool activated = true; //set to true to show prints
  if (activated) {
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss:S");
    DateFormat timeFormat = DateFormat("HH:mm:ss:S");
    String dateTime = timeFormat.format(DateTime.now());
    // ignore: avoid_print
    debugPrint('[$dateTime] \x1B[35m$toPrint\x1B[0m');
  }
}
