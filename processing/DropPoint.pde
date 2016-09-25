/* 
 * Points within the dispenser object where the balls originate 
 */

public class DropPoint {
  int count;
  int code;
  float xPos;
  int mod;
  boolean awake;
  boolean acceptingChange;
  
   public DropPoint() {
    count = 0;
    code = 1;
    awake = true;
    acceptingChange = true;
    mod = 2;
    this.xPos = 0;
  }
    
  
  public DropPoint(float xPos) {
    this();
    this.xPos = xPos;
  }
  
  public void setMod() {
    mod = (int)Math.pow(2,code);
    
    awake = code > 0;
  }
  
  public boolean isReady() {
    count++;
    count %= 32;
    //print("  " + count + "|");
    //print(mod + "  ");
    return (awake && count % mod == 0);
  }
  
  public void increaseCode() {
    if (acceptingChange) {
      code++;
      code %= 6;
      if (code == 0) {
        code++;
      }
      setMod();
      acceptingChange = false;
    }
    
  }
  
  public void acceptingChange() {
    acceptingChange = true;
  }
  
  public void setPosition(float x) {
    xPos = x;
  }
  
  
  
}
