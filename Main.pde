class Character {
  PVector loc;
  PVector speed;
  int diameter = 50;
  
  Character(PVector loc, PVector speed) {
    this.loc = loc;
    this.speed = speed;
  }
  
  float getLocX() {
    return this.loc.x;
  }
  float getLocY() {
    return this.loc.y;
  }
  
  void setLocX(float x) {
    this.loc.x += x;
  }
  void setLocY(float y){
    this.loc.y += y;
  }
}

class Bullet extends PVector {
  PVector vel;
 
  Bullet(PVector loc, PVector vel) {
    super(loc.x, loc.y);
    this.vel = vel.get();
  }
 
  void update() {
    add(vel);
  }
 
  void display() {
    fill(0, 0, 255);
    ellipse(x, y, 3, 3);
  }
}

class Enemy {
  PVector loc;
  PVector speed;
  int diameter = 20;
  
  Enemy(PVector loc, PVector speed) {
    this.loc = loc;
    this.speed = speed;
  }
  
  void update(float x, float y) {
    float diffX = x - this.loc.x;
    float diffY = y - this.loc.y;
    float angle = (float)Math.atan2(diffY, diffX);
    this.loc.x += this.speed.x * Math.cos(angle);
    this.loc.y += this.speed.y * Math.sin(angle);
  }
  
  void draw() {
    noStroke();
    fill(0, 255, 0);
    ellipse(loc.x, loc.y, diameter, diameter);
  }
}

Character c;
ArrayList <Bullet> bullets = new ArrayList <Bullet> ();
ArrayList<Enemy> enemies;
float maxSpeed = 3;

void setup() {
  size(600, 600);
  
  PVector loc = new PVector(width/2, height/2);
  PVector speed = new PVector();
  c = new Character(loc, speed);
  
  enemies = new ArrayList();
  for (int i = 0; i < 5; i++) {
    float x = random(0, width);
    float y = random(0, height);
    PVector locE = new PVector(x, y);
    PVector speedE = new PVector(1, 1);
    enemies.add(new Enemy(locE, speedE));
  }
  
  noCursor();
  noStroke();
  smooth();
}
 
void draw() {
  background(255);
 
  c.loc.add(c.speed);
  fill(255, 0, 0);
  ellipse(c.loc.x, c.loc.y, 20, 20);
  fill(255);
  ellipse(c.loc.x, c.loc.y, 10, 10);
 
  PVector mouse = new PVector(mouseX, mouseY);
  fill(0);
  ellipse(mouse.x, mouse.y, 5, 5);
 
  if (frameCount%5==0 && mousePressed) {
    PVector dir = PVector.sub(mouse, c.loc);
    dir.normalize();
    dir.mult(maxSpeed*3);
    Bullet b = new Bullet(c.loc, dir);
    bullets.add(b);
  }
 
  for (Bullet b : bullets) {
    b.update();
    b.display();
  }
  
  for (int i = 0; i < enemies.size(); i++) {
    enemies.get(i).update(c.getLocX(),c.getLocY());
    enemies.get(i).draw();
  }
}

void keyPressed() {
  if (key == 'w')    { c.speed.y = -maxSpeed; }
  if (key == 's')  { c.speed.y = maxSpeed;  }
  if (key == 'a')  { c.speed.x = -maxSpeed; }
  if (key == 'd') { c.speed.x = maxSpeed;  }
}
 
void keyReleased() {
  if (key == 'w' || key == 's')    { c.speed.y = 0; }
  if (key == 'a' || key == 'd') { c.speed.x = 0; }
}
