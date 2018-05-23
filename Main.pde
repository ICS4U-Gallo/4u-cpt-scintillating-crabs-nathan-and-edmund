class Character {
  PVector loc;
  PVector speed;
  int diameter = 50;
  
  Character(PVector loc, PVector speed) {
    this.loc = loc;
    this.speed = speed;
  }
  
  void draw() {
    noStroke();
    fill(255, 0, 0);
    ellipse(loc.x, loc.y, diameter, diameter);
  }
  
  
}


Character c;
boolean [] keys = new boolean[128];

void setup() {
  size(600, 600);
  
  PVector loc = new PVector(50, 50);
  PVector speed = new PVector(0, 0);
  c = new Character(loc, speed);
  
}

void draw() {
  background(255, 255, 255);
  
  move();
  
  noStroke();
  fill(255, 0, 0);
  ellipse(c.loc.x, c.loc.y, 60, 60);
  
}

void move() {
  if (keys['a']) {
    c.loc.x -= 2;
  }
  if (keys['d']) {
    c.loc.x += 2;
  }
  if (keys['w']) {
    c.loc.y -= 2;
  }
  if (keys['s']) {
    c.loc.y += 2;
  }
}

void keyPressed() {
  keys[key] = true; 
}

void keyReleased() {
  keys[key] = false;
}


