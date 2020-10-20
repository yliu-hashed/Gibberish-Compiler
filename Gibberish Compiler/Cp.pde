String fieldStartingSignal = "(:,";
String fieldEnddingSignal = ",)";
String[] unreconizeInstructionResponse = {
  "Please clear your mind before coding (meditation is recommended)",
  "What are you writing? I don't understand this $hit",
  "What is this? I don't understand",
  "Is your keyboard broken or you are broken?",
  "this is wrong, worth Nzero point",
  "I am disappointed",
  "Please learn more before spit gibberish at me",
  "Please obtain some brain cells", 
  "look at this ... no words"
};

class Compiler {

  ArrayList<String> Text = new ArrayList<String>();
  ArrayList<String> MachineCode = new ArrayList<String>();

  String ErrorText = "";

  void updateCompiler(ArrayList<String> t) {
    Text = t;
  }

  void runCompiler() {
    String compileResult = compile();
    println("Compiler Result: " + compileResult);
    if (!compileResult.equals("Successed")) {
      MachineCode.add("Error");
      ErrorText = "Error: " + compileResult;
    }
  }

  String compile() {

    if (hasFileOpened) Save();

    ErrorText = "";
    MachineCode = new ArrayList<String>();

    println("Compiler Started");

    refreshGenericColorReference();

    Phrasing P = new Phrasing();

    IntDict codeLocationTag = new IntDict();

    int MachineCodeByteNumber = 0;

    for (int lineNumber = 0; lineNumber < Text.size(); lineNumber ++) {
      String Line = Text.get(lineNumber);
      String AbsoluteLine = Line.replaceAll(" ", "");

      if (AbsoluteLine.equals("")) {
        MachineCode.add("");
        continue;
      }
      if (AbsoluteLine.startsWith("//")) {
        MachineCode.add("");
        continue;
      }
      if (AbsoluteLine.startsWith("@")) {
        MachineCode.add("");
        if (AbsoluteLine.startsWith("@tag(") && AbsoluteLine.endsWith(")")) {
          String name = AbsoluteLine.substring(5, AbsoluteLine.length()-1);
          codeLocationTag.set("@" + name, MachineCodeByteNumber);
          colorReference.set("@" + name, "3");
        }

        continue;
      }

      println("Line " + lineNumber  + ":" + AbsoluteLine);

      String phraseResult = P.phrasing(AbsoluteLine);
      println("     >"+ phraseResult);
      println("     |  " + P.backbone + " - " + P.valueFields);

      //phrase the instruction
      if (!phraseResult.equals("Phraseing Successed")) {
        return "Phrasing Error: " + phraseResult;
      }

      //find the corrisponding instruction according to backbone
      Phrasing RP = new Phrasing();
      boolean foundInstruction = false;
      JSONObject actionObj = new JSONObject();
      for (int actionIndex = 0; actionIndex < Language.size(); actionIndex ++) {
        JSONObject Obj = Language.getJSONObject(actionIndex);
        String format = Obj.getString("format");
        RP.phrasing(format);
        if (RP.backbone.equals(P.backbone)) {
          actionObj = Obj;
          foundInstruction = true;
          break;
        }
      }
      if (!foundInstruction) {
        int randomIndex = (int) random(0, unreconizeInstructionResponse.length);
        return unreconizeInstructionResponse[randomIndex];
      }

      //test match fieldArray
      if (P.valueFields.size() != RP.valueFields.size()) return "Inputed field is ambiguous";
      
      //assemble machine code
      ArrayList<String> FieldMCode = new ArrayList<String>();

      for (int fieldIndex = RP.valueFields.size() - 1; fieldIndex >= 0; fieldIndex --) {
        String FieldTagName = RP.valueFields.get(fieldIndex);
        String FieldValue = P.valueFields.get(fieldIndex);
        String FieldFreedom = "None";
        
        if (FieldValue.equals(FieldTagName)) return "Field is not complete on " + FieldValue;
        if (FieldValue.length() == 0) return "Empty field is not allowed";
        
        //find field freedom
        for (int idd = 0; idd < LanguageEx.size(); idd ++) {
          JSONObject targetObject = LanguageEx.getJSONObject(idd);
          if (FieldTagName.equals(targetObject.getString("token"))) {
            FieldFreedom = targetObject.getString("fieldFreedom");
            break;
          }
        }

        //locate tag
        JSONArray possibleValue = new JSONArray();
        for (int c = 0; c < LanguageEx.size(); c ++) {
          JSONObject targetObject = LanguageEx.getJSONObject(c);
          if (targetObject.getString("token").equals(FieldTagName)) {
            possibleValue = targetObject.getJSONArray("replacements");
            break;
          }
        }

        //find value
        boolean foundValue = false;
        for (int d = 0; d < possibleValue.size(); d ++) {
          JSONObject targetObject = possibleValue.getJSONObject(d);
          if (targetObject.getString("replacement").equals(FieldValue)) {
            String MCode = targetObject.getString("codex");
            FieldMCode.add(MCode);
            foundValue = true;
            break;
          }
        }

        //freedom cases
        if (!foundValue) {
          switch (FieldFreedom) {
          case "None":
            break;

          case "8BitInt":
            int num = 0;
            try { 
              num = Integer.parseInt(FieldValue.substring(1));
            } 
            catch (Exception e) {
              return FieldValue.substring(1) + " is not a number";
            }
            if (num < 0) return "Value " + num + " is below 8 bit capacity (255 min)";
            if (num > 255) return "Value " + num + " is ablove 8 bit capacity (255 max)";
            String bi = intTo8BitBinary(num);
            FieldMCode.add(bi);
            foundValue = true;
            break;

          case "Direct":
            FieldMCode.add(FieldValue);
            foundValue = true;
            break;
          }
        }

        if (!foundValue) {
          if (FieldTagName.equals(FieldValue)) {
            return "Field " + FieldTagName + " is not complete";
          }
          return FieldValue + " is not included in Token " + "[" + FieldTagName + "]";
        }
      }

      String MachineCodeReference = actionObj.getString("codex");
      println("     >" + "Searched Successfully");
      println("     |  " + MachineCodeReference + " - " + FieldMCode);

      //generate machine code
      String MachineCodeLine = MachineCodeReference;
      for (int fieldIndex = 0; fieldIndex < FieldMCode.size(); fieldIndex ++) {
        MachineCodeLine = MachineCodeLine.replaceAll("#"+(fieldIndex+1), FieldMCode.get(fieldIndex));
      }

      println("     >" + "Compiled Successfully");
      println("     |  " + MachineCodeLine);

      MachineCode.add(MachineCodeLine);
      if (MachineCodeLine.length() > 0) {
        if (MachineCodeLine.contains(" ")) {
          MachineCodeByteNumber += 2;
        } else {
          MachineCodeByteNumber += 1;
        }
      }
    }

    if (MachineCodeByteNumber > 256) {
      return "program too large for memory: Length = " + MachineCodeByteNumber;
    }

    codeLocationTag.sortValues();
    for (int i = 0; i < MachineCode.size(); i++) {
      for (int t = 0; t < codeLocationTag.size(); t++) {
        String targetKey = codeLocationTag.key(t);
        if (MachineCode.get(i).contains(targetKey)) {
          int targetValue = codeLocationTag.value(t);
          String bi = Integer.toBinaryString(targetValue);
          while (bi.length() < 8) { //fill in leading zeros
            bi = "0" + bi;
          }
          String replacedMachineCodeLine = MachineCode.get(i).replaceAll(targetKey, bi);
          MachineCode.set(i, replacedMachineCodeLine);
        }
      }
    }

    return "Successed";
  }
}
