int x;  //declare globally 
int xSpeed;
void setup() { 
  size(400, 400);
  x = 30;  //initiliaze in setup
  xSpeed = 5;
} 

void draw() {
  x += xSpeed;
  
  
  if (x == 400) {
   xSpeed = -xSpeed;
  }
 
  background(#233958); 
  //draw ball
  noStroke();
  fill(255, 165, 0);
  ellipse(x, 200 , 50, 50);      //update variable 
  
  if (x <= 0) {
    xSpeed = -xSpeed;
  }
  
  
 
}
  