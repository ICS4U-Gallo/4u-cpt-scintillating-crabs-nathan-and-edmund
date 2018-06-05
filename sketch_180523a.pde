class Character {
  PVector loc;
  PVector speed;
  int diameter = 50;
  
  Character(PVector loc, PVector speed) {
    this.loc = loc;
    this.speed = speed;
  }
  
  void setLocX(float x) {
    this.loc.x += x;
  }
  void setLocY(float y){
    this.loc.y += y;
  }
  
  float getLocX() {
    return this.loc.x;
  }
  float getLocY() {
    return this.loc.y;
  }
  
   void draw() {
    noStroke();
    fill(255, 0, 0);
    ellipse(loc.x, loc.y, diameter, diameter);
  } 
}

class Bullet{
  PVector loc;
  PVector speed;
  
  Bullet(PVector loc, PVector speed) {
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
}

class Enemy {
  PVector loc;
  PVector speed;
  int diameter = 80;
  
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
    fill(255, 0, 0);
    ellipse(loc.x, loc.y, diameter, diameter);
  }
}

Character c;
boolean [] keys = new boolean[128];
ArrayList<Enemy> enemies;

void setup() {
  size(600,600);
  
  PVector loc = new PVector(50, 50);
  PVector speed = new PVector(0, 0);
  c = new Character(loc, speed);
  
  enemies = new ArrayList();
  for (int i = 0; i < 5; i++) {
    float x = random(0, width);
    float y = random(0, height);
    PVector locE = new PVector(x, y);
    PVector speedE = new PVector(1, 1);
    enemies.add(new Enemy(locE, speedE));
  }
}

void draw() {
  
  background(255, 255, 255);
  
  move();
  
  noStroke();
  fill(255, 0, 0);
  ellipse(c.getLocX(), c.getLocY(), 60, 60);
  
  // draw targets
  for (int i = 0; i < enemies.size(); i++) {
    enemies.get(i).update(c.getLocX(),c.getLocY());
    enemies.get(i).draw();
  }
  
}

void move() {
  if (keys['a']) {
    c.setLocX(-2);
  }
  if (keys['d']) {
    c.setLocX(2);
  }
  if (keys['w']) {
    c.setLocY(-2);
  }
  if (keys['s']) {
    c.setLocY(2);
  }
}

void keyPressed() {
  keys[key] = true; 
}

void keyReleased() {
  keys[key] = false;
}