import java.awt.*;
import java.awt.datatransfer.*;
import java.awt.datatransfer.DataFlavor;

Clipboard clipboard;

void setupClipBoard() {
  clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
} 

void copyToClipboard(String stringToCopy) {
  StringSelection selection = new StringSelection(stringToCopy);
  clipboard.setContents(selection,selection);
}

String getFromClipboard() {
  Transferable contents = clipboard.getContents(null);
  String data = "";
  if (contents != null && contents.isDataFlavorSupported(DataFlavor.stringFlavor)) {
    try {
      data = (String) contents.getTransferData(DataFlavor.stringFlavor);
    } catch (UnsupportedFlavorException e1) {
      println(e1);
      return "";
    } catch (IOException e2) {
      println(e2);
      return "";
    }
  }
  return data;
}
