class Character {
  PVector loc;
  PVector speed;
  int diameter = 50;
  int maxHealth = 100;
  int health = 100;
  
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
    this.loc.x = x;
  }
  void setLocY(float y){
    this.loc.y = y;
  }
  
  float takeDmg(float dmg) {
    return this.health -= dmg;
  }
  
  float getHp() {
    return this.health;
  }
}

class Bullet extends PVector {
  PVector vel;
  float bDmg = 1 + score/10;
  int radius = 6;
  int time = 0;
 
  Bullet(PVector loc, PVector vel) {
    super(loc.x, loc.y);
    this.vel = vel.get();
  }
 
  void update() {
    add(vel);
  }
 
  void timeAlive() {
    if(frameRate % 30 == 0) {
      this.time += 1;
    }
  }
  void display() {
    fill(0, 0, 255);
    ellipse(x, y, radius, radius);
  }
}

class Enemy {
  PVector loc;
  PVector speed;
  int diameter = 20;
  int index = 0;
  float eHp = 5 + score/10;
  float eDmg = 2;
  
  Enemy(PVector loc, PVector speed) {
    this.loc = loc;
    this.speed = speed;
  }
  
  void update(float x, float y, int score) {
    float diffX = x - this.loc.x;
    float diffY = y - this.loc.y;
    float angle = (float)Math.atan2(diffY, diffX);
    this.loc.x += this.speed.x * Math.cos(angle);
    this.loc.y += this.speed.y * Math.sin(angle);
    this.speed.x += score/100 ;
    this.speed.y += score/100;
  }
  
  float takeDmg(float dmgDone) {
    return this.eHp -= dmgDone;
  }
  
  boolean dead() {
    return (this.eHp <= 0);
  }
  
  String drugDrone() {
    
  String[] r= {"I love drugs"," I need drugs to live", "Try some drugs", " "};
    if (frameCount % 60 == 0) {
          int rindex = int(random(r.length));
          index = rindex;
     } 
    return r[index];
  }
  
  void draw() {
    noStroke();
    fill(0);
    ellipse(loc.x, loc.y, diameter, diameter);
    
    fill(255,0,0);
    ellipse(loc.x - 5, loc.y - 4, diameter/4, diameter/4);
    ellipse(loc.x + 5, loc.y - 4, diameter/4, diameter/4);

    textSize(10);
    text(drugDrone(), this.loc.x - diameter/2, this.loc.y - 30);
  }
}

Character c;
ArrayList <Bullet> bullets = new ArrayList <Bullet> ();
ArrayList<Enemy> enemies;
float maxSpeed = 3;
int screen = 0;
int healthBarWidth = 60;
int score = 0;
float xo;
float yo;

void setup() {
  size(600, 600);
  xo = width/2;
  yo = height/2;
    
  PVector loc = new PVector(0, 0);
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
  translate(xo,yo);
      
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
  text("Click to start", height/2 - yo, width/2 - xo);
}

void gameScreen() {
  background(255);

  c.loc.add(c.speed);
  fill(255, 0, 0);
  ellipse(c.loc.x, c.loc.y, 20, 20);
  fill(255);
  ellipse(c.loc.x, c.loc.y, 10, 10);
 
  PVector mouse = new PVector(mouseX - xo, mouseY - yo);
  fill(0);
  ellipse(mouse.x, mouse.y, 5, 5);
 
  if (frameCount % 10 == 0 && mousePressed) {
    PVector dir = PVector.sub(mouse, c.loc);
    dir.normalize();
    dir.mult(maxSpeed * 3);
    Bullet b = new Bullet(c.loc, dir);
    bullets.add(b);
  }
  
  if(frameCount % 60 == 0) {
    float x = random(0, width);
    float y = random(0, height);
    PVector locE = new PVector(x, y);
    PVector speedE = new PVector(1, 1);
    enemies.add(new Enemy(locE, speedE));
  }
   
  for (Bullet b : bullets) {
    b.update();
    b.display();
    b.timeAlive();
  }
  
   for (int i = 0; i < bullets.size() - 1; i ++) {
     for(int j = 0; j < enemies.size() - 1; j++) {
          float dx = enemies.get(j).loc.x - bullets.get(i).x;
          float dy = enemies.get(j).loc.y - bullets.get(i).y;
          float dist = sqrt(dx * dx + dy * dy);
          if (dist < (enemies.get(j).diameter/2 + bullets.get(i).radius)) {
            enemies.get(j).takeDmg(bullets.get(i).bDmg);
            bullets.remove(i);
              
            if(enemies.get(j).dead()) {
              enemies.remove(j);
              score();
            } else if( bullets.get(i).time > 2){
              bullets.remove(i);
            }
          }
     }
   }
  
  for (int i = 0; i < enemies.size(); i++) {
    enemies.get(i).update(c.getLocX(),c.getLocY(),score);
    enemies.get(i).draw();
  }
  
   for (int i = 0; i < enemies.size(); i++) {
        for (int j = i + 1; j < enemies.size(); j++) {
            float dx = enemies.get(j).loc.x - enemies.get(i).loc.x;
            float dy = enemies.get(j).loc.y - enemies.get(i).loc.y;
            float dist = sqrt(dx * dx + dy * dy);
            if (dist < (enemies.get(j).diameter/2 + enemies.get(i).diameter/2)) {                
                float normalX = dx / dist;
                float normalY = dy / dist;
                float midpointX = (enemies.get(i).loc.x + enemies.get(j).loc.x) / 2;
                float midpointY = (enemies.get(i).loc.y + enemies.get(j).loc.y) / 2;
                enemies.get(j).loc.x = midpointX - normalX * enemies.get(i).diameter/2;
                enemies.get(i).loc.y = midpointY - normalY * enemies.get(i).diameter/2;
                enemies.get(j).loc.x = midpointX + normalX * enemies.get(j).diameter/2;
                enemies.get(j).loc.y = midpointY + normalY * enemies.get(j).diameter/2;
                float dVector = (enemies.get(i).speed.x - enemies.get(j).speed.x) * normalX;
                dVector += (enemies.get(i).speed.y - enemies.get(j).speed.y) * normalY;
                float dvx = dVector * normalX;
                float dvy = dVector * normalY;
                enemies.get(i).speed.x -= dvx;
                enemies.get(i).speed.y -= dvy;
                enemies.get(j).speed.x += dvx;
                enemies.get(j).speed.y += dvy;
            }
        }
    }
    
    for (int i = 0; i < enemies.size(); i++) {
            float dx = enemies.get(i).loc.x - c.loc.x;
            float dy = enemies.get(i).loc.y - c.loc.y;
            float dist = sqrt(dx * dx + dy * dy);
            
            if (dist < (enemies.get(i).diameter/2 + c.diameter/2)) { 
               if( frameCount % 20 == 0) {
                c.takeDmg(enemies.get(i).eDmg);
               }                                
               gameoverCheck();
            }
    }
  
  healthBar();
  printScore();
  
}

void gameOverScreen() {
  background(0);
  textAlign(CENTER);
  fill(255);
  textSize(30);
  text("Game Over", height/2 - yo, width/2 - 20 - xo);
  textSize(15);
  text("Click to Restart", height/2 - yo, width/2 + 10 - xo);
}

void startGame() {
  screen=1;
}

void gameOver() {
  screen = 2;
}

void restart() {
  score = 0;
  c.health = c.maxHealth;
  c.loc.x = width/2;
  c.loc.y = height/2;
  screen = 0;
  for(int i = 0; i < enemies.size(); i ++) {
    enemies.remove(i);
  }
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
  if (key == 'w') { 
    c.speed.y = -maxSpeed; 
   }
  if (key == 's')  { 
    c.speed.y = maxSpeed;  
  }
  if (key == 'a')  { 
  c.speed.x = -maxSpeed; 
  }
  if (key == 'd') { 
    c.speed.x = maxSpeed;
  }
  
  if(key == ' ') {

  xo = -c.loc.x + width/2;
  yo = -c.loc.y + height/2;
  }
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
  if (c.health > 60) {
    fill(46, 204, 113);
  } else if (c.health > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  rect(c.loc.x - (healthBarWidth/2), c.loc.y - 30, healthBarWidth*(c.getHp()/c.maxHealth), 5);
}

void gameoverCheck() {
  if (c.health <= 0) {
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
  text(score, c.loc.x, c.loc.y - 50);
}
