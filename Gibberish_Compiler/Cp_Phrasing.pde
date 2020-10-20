class Phrasing {
  ArrayList<String> valueFields = new ArrayList<String>();
  String backbone = "";

  String phrasing(String line) {
    valueFields = new ArrayList<String>();
    backbone = "";
    
    String AbsoluteLine = line.replaceAll(" ", "");
    
    boolean Fielding = false;
    for (int i = AbsoluteLine.length() - 1; i >= 0; i--) {
      char currentChar = AbsoluteLine.charAt(i);
      boolean isMarker = false;
      //print("a");
      if (fieldStartingSignal.contains(String.valueOf(currentChar)) && Fielding != false) {
        Fielding = false;
        isMarker = true;
      }
      if (fieldEnddingSignal.contains(String.valueOf(currentChar))) {
        if (Fielding == true) return "Ambiguous Field Structure";
        Fielding = true;
        valueFields.add("");
        isMarker = true;
      }
      if (isMarker) {
        backbone = currentChar + backbone;
      } else {
        if (Fielding == true) {
          String field = valueFields.get(valueFields.size()-1);
          valueFields.set(valueFields.size()-1, currentChar + field);
        } else {
          backbone = currentChar + backbone;
        }
      }
    }
    if (Fielding == true) return "Ambiguous Field Structure";
    
    return "Phraseing Successed";
  }
}
