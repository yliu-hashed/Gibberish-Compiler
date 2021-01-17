boolean enablePrintout = false;

void p(String message, boolean lineB) { //automatic printing
  if (enablePrintout) {
    print(message);
    if (lineB) {
      print("\n");
    }
  }
}

void e(String message) {
  print(message);
}
