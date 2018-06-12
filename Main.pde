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
int screen = 0;
int maxHealth = 100;
float health = 100;
float healthDecrease = 1;
int healthBarWidth = 60;
int score = 0;

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
  if (screen == 0) {
    initScreen();
  } else if (screen == 1) {
    gameScreen();
  } else if (screen == 2) {
    gameOverScreen();
  }
}

void initScreen() {
  background(0);
  textAlign(CENTER);
  fill(255);
  textSize(15);
  text("Click to start", height/2, width/2);
}

void gameScreen() {
  background(255);
 
  c.loc.add(c.speed);
  fill(255, 0, 0);
  ellipse(c.loc.x, c.loc.y, 20, 20);
  fill(255);
  ellipse(c.loc.x, c.loc.y, 10, 10);
 
  PVector mouse = new PVector(mouseX, mouseY);
  fill(0);
  ellipse(mouse.x, mouse.y, 5, 5);
 
  if (frameCount % 5 == 0 && mousePressed) {
    PVector dir = PVector.sub(mouse, c.loc);
    dir.normalize();
    dir.mult(maxSpeed * 3);
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
  
  healthBar();
  printScore();
}

void gameOverScreen() {
  background(0);
  textAlign(CENTER);
  fill(255);
  textSize(30);
  text("Game Over", height/2, width/2 - 20);
  textSize(15);
  text("Click to Restart", height/2, width/2 + 10);
}

void startGame() {
  screen=1;
}

void gameOver() {
  screen = 2;
}

void restart() {
  score = 0;
  health = maxHealth;
  c.loc.x = width/2;
  c.loc.y = height/2;
  screen = 0;
}

public void mousePressed() {
  if (screen==0) {
    startGame();
  }
  if (screen==2) {
    restart();
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

void healthBar() {
  noStroke();
  fill(236, 240, 241);
  rectMode(CORNER);
  rect(c.loc.x - (healthBarWidth/2), c.loc.y - 30, healthBarWidth, 5);
  if (health > 60) {
    fill(46, 204, 113);
  } else if (health > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  rect(c.loc.x - (healthBarWidth/2), c.loc.y - 30, healthBarWidth*(health/maxHealth), 5);
}

void decreaseHealth() {
  health -= healthDecrease;
  if (health <= 0) {
    gameOver();
  }
}

void score() {
  score++;
}

void printScore() {
  textAlign(CENTER);
  fill(0);
  textSize(30);
  text(score, height/2, 50);
}
