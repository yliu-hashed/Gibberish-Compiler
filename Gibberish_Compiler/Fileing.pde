String programFileDirectory = "";
File programFile;
boolean hasFileOpened = false;

void Load() {
  String[] lineArray = loadStrings(programFileDirectory);
  editor.Reset();
  editor.Text.clear();
  if (lineArray.length == 0) {
    editor.Text.add("");
  }
  for (String line : lineArray) {
    editor.Text.add(line);
  }
  editor.EditingTextUpdate();
  hasFileOpened = true;
}

void Save() {
  if (hasFileOpened) {
    String[] lineArray = new String[editor.Text.size()];
    for (int i = 0; i < editor.Text.size(); i++) {
      lineArray[i] = editor.Text.get(i);
    }
    saveStrings(programFileDirectory, lineArray);
  } else {
    selectOutput("Select a file to write to:", "fileSaveSelected");
  }
}

void New() {
  if (hasFileOpened) Save();
  hasFileOpened = false;
  editor.Reset();
}

void Open() {
  if (hasFileOpened) Save();
  selectInput("Select a file", "fileOpenSelected");
}

public void fileSaveSelected(File selection) {
  if (selection == null) {
    p("Window was closed or the user hit cancel.", true);
    return;
  }
  p(selection.getAbsolutePath(), true);
  File newSelection = new File(selection.getAbsolutePath() + ".gibberish");
  try { 
    newSelection.createNewFile();
  } catch (IOException a) {
    e(a.getMessage());
    return;
  }
  programFileDirectory = newSelection.getAbsolutePath();
  programFile = newSelection;
  hasFileOpened = true;
  Save();
  Load();
}

public void fileOpenSelected(File selection) {
  if (selection == null) {
    p("Window was closed or the user hit cancel.", true);
    return;
  }
  boolean acceptableFileExtention = selection.getName().endsWith(".gibberish") || selection.getName().endsWith(".txt");
  if (!acceptableFileExtention && selection.isFile()) {
    p("Bad Selection", true);
    return;
  }
  p("Loading file: " + selection.getAbsolutePath(), true);
  programFileDirectory = selection.getAbsolutePath();
  programFile = selection;
  Load();
}
