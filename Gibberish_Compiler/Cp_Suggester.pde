JSONArray Language;
JSONArray LanguageEx;

void LoadLanguageReference() {
  Language = loadJSONArray("Language Reference/language.json");
  LanguageEx = loadJSONArray("Language Reference/languageEx.json");
}

void drawSuggestionWithColor(String text, float x, float y) {

  String Token = text.charAt(0) + "#";
  int colorCode = 0;
  for (int i = 0; i < LanguageEx.size(); i ++) {
    JSONObject a = LanguageEx.getJSONObject(i);
    String targetToken = a.getString("token");
    if (targetToken.equals(Token)) {
      colorCode = i + 1;
      break;
    }
  }

  fill(secondaryLabel);
  text(text.charAt(0), x, y);
  fill(colorCode == 0 ? secondaryLabel : colorReferenceColor[colorCode]);
  text(text.substring(1), x + fontWidth, y);
}

boolean SuggesterVisibleToggle = false;

class suggester {
  String currentLine = "";
  int curserPosition = 0;
  boolean onEdit = true;
  boolean visible = false;
  ArrayList<String> SuggestedObject = new ArrayList<String>();

  int selection = -1;

  float fontWidth = 0;

  //box size
  float w = 0;
  float h = 0;
  
  void updateSuggester(String l, int c, float fw) {
    selection = -1;

    currentLine = l;
    curserPosition = c;
    
    suggestions();

    fontWidth = fw;

    //update shape
    int SuggestionLength = 0;
    for (String i : SuggestedObject) {
      int trueLength = i.length();
      if (i.charAt(0) == '§') trueLength -= 4;
      if (trueLength > SuggestionLength) SuggestionLength = trueLength;
    }

    w = SuggestionLength * fontWidth + 5;
    if (w < 50) w = 50;

    h = SuggestedObject.size() * fontHeight + 2;

    if (SuggestedObject.size() != 0 && !currentLine.isEmpty()) {
      visible = true;
    } else {
      visible = false;
    }

    if (curserPosition == 0) visible = false;

    if (SuggestionLength == currentLine.length() && c == currentLine.length()) visible = false;
  }

  void render(CGPoint lineStartingPosition) {
    if (onEdit) {
      if (SuggesterVisibleToggle) {
        if (visible) {
          visible = false;
        } else {
          if (SuggestedObject.size() != 0) {
            visible = true;
          }
        }
        SuggesterVisibleToggle = false;
      }

      if (visible) {

        boolean tokenSuggestion = false;
        if (SuggestedObject.size() >= 1) {
          String firstSuggestion = SuggestedObject.get(0);
          if (firstSuggestion.charAt(0) == '§') {
            tokenSuggestion = true;
          }
        }

        int suggestionCharOffset = 0;
        int suggestionTextCutoff = 0;

        //action suggestion
        if (tokenSuggestion) {
          String firstSuggestion = SuggestedObject.get(0);
          String token = "";

          if (firstSuggestion.charAt(1) == '#') {
            token = "#";
          } else {
            token = firstSuggestion.charAt(1)+"#";
          }

          int offset = 0;
          if (token.equals(currentLine.substring(curserPosition, curserPosition + token.length()))) {
            offset = 0;
          } else {
            offset = 1;
          }

          suggestionCharOffset = curserPosition - offset;
          suggestionTextCutoff = token.length() + 2;
        }

        //shapes
        //box shape
        fill(background);
        stroke(seperator);
        rect(lineStartingPosition.x + suggestionCharOffset * fontWidth - 3, lineStartingPosition.y, w, h, 7);

        //selection shape
        fill(selectionBackground);
        noStroke();
        if (selection >= 0) {
          boolean tR = false;
          boolean bR = false;
          if (selection == 0) tR = true;
          if (selection == SuggestedObject.size() - 1) bR = true;

          rect(lineStartingPosition.x + suggestionCharOffset * fontWidth - 3, lineStartingPosition.y + fontHeight * selection, w, fontHeight + 2, tR ? 7 : 0, tR ? 7 : 0, bR ? 7 : 0, bR ? 7 : 0);
        }

        //text
        for (int i = 0; i < SuggestedObject.size(); i++) {
          //suggestion text
          String suggestion = SuggestedObject.get(i).substring(suggestionTextCutoff);
          if (selection == i) {
            fill(255);
            text(suggestion, lineStartingPosition.x + fontWidth * suggestionCharOffset, lineStartingPosition.y + fontHeight * i + fontHeight - 3);
          } else {
            drawSuggestionWithColor(suggestion, lineStartingPosition.x + fontWidth * suggestionCharOffset, lineStartingPosition.y + fontHeight * i + fontHeight - 3);
          }
          //written overlay
          fill(selection == i ? 255 : label);
          text(currentLine.substring(suggestionCharOffset, curserPosition), lineStartingPosition.x + fontWidth * suggestionCharOffset, lineStartingPosition.y + fontHeight * i + fontHeight - 3);
        }
      }
    }
  }

  void STab() {
    visible = false;
  }

  String ObtainNewLine() {
    String Suggestion = "";
    if (selection == -1) {
      Suggestion = SuggestedObject.get(0);
    } else {
      Suggestion = SuggestedObject.get(selection);
    }

    if (Suggestion.charAt(0) != '§') {
      return Suggestion.replaceAll(",", ", ");
    }

    String token = "";
    String trueSuggestion = "";
    if (Suggestion.charAt(1) == '#') {
      token = "#";
      trueSuggestion = Suggestion.substring(3);
    } else {
      token = Suggestion.charAt(1)+"#";
      trueSuggestion = Suggestion.substring(4);
    }

    return currentLine.replaceFirst(token, trueSuggestion);
  }

  int ObtainNewCurserPosition(String line) {
    String newString = line;

    int targetPosition = -1;
    for (int i = 0; i < newString.length(); i ++) {
      if (newString.charAt(i) == '#') {
        targetPosition = i;
        break;
      }
    }

    if (targetPosition == -1) {
      return newString.length();
    }
    if (targetPosition > 0) {
      char previousMark = newString.charAt(targetPosition-1);

      for (int a = 0; a < LanguageEx.size(); a++) {
        JSONObject tokenLanguageReference = LanguageEx.getJSONObject(a);
        String token = tokenLanguageReference.getString("token");
        if (token.equals(previousMark + "#")) {
          return targetPosition-1;
        }
      }
      return targetPosition;
    }
    return 0;
  }

  void SDown() {
    if (selection < SuggestedObject.size() - 1) {
      selection++;
    } else {
      selection = 0;
    }
  }

  void SUp() {
    if (selection > 0) {
      selection--;
    } else {
      selection = SuggestedObject.size() - 1;
    }
  }

  //seggesting mechenics
  void suggestions() {
    ArrayList<String> suggestions = new ArrayList<String>();

    String searchingLine = currentLine.substring(0, curserPosition);

    //index all @tag();
    ArrayList<String> AllText;
    try {
      AllText = editor.Text;
    } 
    catch (Exception e) {
      AllText = new ArrayList<String>();
    }

    ArrayList<String> codeLocationTags = new ArrayList<String>();
    for (String i : AllText) {
      String absoluteLine = i.replaceAll(" ", "");
      if (absoluteLine.startsWith("@tag(") && absoluteLine.endsWith(")")) {
        String name = absoluteLine.substring(5, absoluteLine.length()-1);
        codeLocationTags.add("@" + name);
      }
    }

    //searching for # token
    int targetPosition = -1;
    for (int i = curserPosition; i < currentLine.length(); i ++) {
      if (currentLine.charAt(i) == '#') {
        targetPosition = i;
        break;
      }
    }
    if (targetPosition != -1) {
      if (targetPosition > 0) {
        char previousMark = currentLine.charAt(targetPosition-1);
        String fullToken = previousMark + "#";
        String trueToken = "#";
        JSONObject tokenLanguageReference = new JSONObject();
        for (int a = 0; a < LanguageEx.size(); a++) {
          tokenLanguageReference = LanguageEx.getJSONObject(a);
          String token = tokenLanguageReference.getString("token");
          if (fullToken.equals(token)) {
            trueToken = token;
            break;
          }
        }
        if (trueToken.equals("#")) {
          if (targetPosition == curserPosition) {
            SuggestedObject = suggestions;
            return;
          }
        } else {
          if (targetPosition-1 == curserPosition || targetPosition == curserPosition) {
            JSONArray tokenLanguageArray = tokenLanguageReference.getJSONArray("replacements");
            for (int b = 0; b < tokenLanguageArray.size(); b ++) {
              String replacement = tokenLanguageArray.getJSONObject(b).getString("replacement");
              suggestions.add("§"+trueToken+"§"+replacement);
            }
            if (trueToken.equals("@#")) {
              for (String codeTagLocation : codeLocationTags) {
                suggestions.add("§"+trueToken+"§"+codeTagLocation);
              }
            }
            SuggestedObject = suggestions;
            return;
          }
        }
      }
    }

    //Language Line
    for (int i = 0; i < Language.size(); i++) {
      JSONObject targetAction = Language.getJSONObject(i);
      String targetFormat = targetAction.getString("format");
      if (searchingLine.length() > targetFormat.length()) continue;
      String searchingArea = targetFormat.substring(0, searchingLine.length());
      if (searchingArea.equals(searchingLine)) {
        suggestions.add(targetFormat);
      }
    }

    SuggestedObject = suggestions;
  }
}
