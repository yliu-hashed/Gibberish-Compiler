class scrollableObject extends screenObject {
  boolean ScrollBarVisible = true;

  ScrollBar scrollBar = new ScrollBar();

  void scroll(float scrollValue) {
    scrollBar.scrollTo(scrollBar.scrollPosition + scrollValue * 2);
  }

  void scrollTo(float scrollPosition) {
    scrollBar.scrollTo(scrollPosition);
  }

  void setScrollSize(float newScrollSize) {
    scrollBar.setContentSize(newScrollSize);
  }

  void render() {
    super.render();
  }
}

class ScrollBar extends screenObject {
  float scrollBarPosition = 0;
  float scrollBarSize = 0;
  float overScroll = 100;

  //parent system
  float contentSize = 0;
  float scrollPosition = 0;

  void scrollTo(float newPosition) {
    this.scrollPosition = newPosition;
    if (scrollPosition < 0.0) scrollPosition = 0.0;
    float cContentSize = max(contentSize - Size.y, 0);
    if (scrollPosition > cContentSize) scrollPosition = cContentSize;
  }

  void updateSize() {
    Position = new CGPoint(screenSize.x - 20, 30);
    Size = new CGSize(20, screenSize.y - 30);

    if (CO != null) {
      CO.Position = Position;
      CO.Size = Size;
    }
  }

  ScrollBar() {
    updateSize();
    CO = new clickableObject(Position, Size);
    zPosition = 1;
  }

  void setContentSize(float newContentSize) {
    contentSize = newContentSize + overScroll;
    scrollTo(scrollPosition);
  }

  void render() {
    super.render();

    scrollBarSize = (Size.y / contentSize) * Size.y;
    if (scrollBarSize > Size.y) scrollBarSize = Size.y;

    scrollBarPosition = (scrollPosition / contentSize) * Size.y;
    
    fill(255, 255, 255);
    rect(Position.x, Position.y, Size.x, Size.y);
    //stroke(seperator);
    fill(CO.onHover ? color(180, 181, 182, 200) : color(200, 200, 200, 200));
    rect(Position.x + 3, Position.y + scrollBarPosition, Size.x - 6, scrollBarSize - 3, 7);
  }

  void updateScrollBar(float contentSize, float scrollPosition) {
    this.contentSize = contentSize;
    this.scrollPosition = scrollPosition;
  }

  float storedClickOffset = 0;

  //click start position;
  void onClick(CGPoint position) {
    super.onClick(position);
    float clickPosition = position.y - Position.y;
    //storedClickOffset = clickPosition - scrollBarPosition;
    if (clickPosition > scrollBarPosition && clickPosition < scrollBarPosition + scrollBarSize) {
      storedClickOffset = clickPosition - scrollBarPosition;
    } else {
      storedClickOffset = scrollBarSize / 2;
    }
  }

  void onDrag(CGPoint position) {
    super.onDrag(position);
    float clickPosition = position.y - Position.y;
    float idealScrollBarPosition = clickPosition - storedClickOffset;
    float idealScrollPosition = (idealScrollBarPosition / Size.y) * contentSize;
    scrollTo(idealScrollPosition);
  }
}
