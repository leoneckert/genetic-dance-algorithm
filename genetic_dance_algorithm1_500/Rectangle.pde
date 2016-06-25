// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Re-implementing java.awt.Rectangle
// so JS mode works

class Rectangle {
   int x;
   int y;
   int w;
   int h;
   String text;
   int condition;
   
   Rectangle(int x_, int y_, int w_, int h_, String tex, int cond) {
     x = x_;
     y = y_;
     w = w_;
     h = h_;
     condition = cond;
     text = tex;
     
   }
   
   void display(){
     fill(255);
     stroke(255);
     strokeWeight(1);
     textSize(12);
     textAlign(CENTER); 
     line(x, y+2, x, y - h); 
     line(x + w, y+2, x + w, y - h); 
     
     if(condition == target){
      rect( x+5 , y - h , w-10, h+2);
      fill(0);
     }
     
     text(text, x + (w/2),y); 
     
   }
   
   boolean contains(int px, int py) {
     return (px > x-3 && px < x + w+3  && py > y-15 && py < y + h +5);
   }
   
}
