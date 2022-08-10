class ColorHandler {
  private String mode;
  private int iter = 0;

  ColorHandler(String mode) {
    this.mode = mode;
  }

  public void setFill(int value) {
    switch (mode) {
    case "STATIC":
      fill(value, value, 255);
      break;
    case "INVERSE":
      fill(value, 255, value);
      break;
    case "LOOP":
      fill((iter/(480*640))%255, value, 255);
      break;
    case "LOOP_INVERSE":
      fill((iter/(480*640))%255, 255, value);
      break;
    }
    iter++;
  }
}
