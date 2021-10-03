Squid s;
boolean isPaused;
void setup() {
  size(1000,1000);
  noCursor();
  s = new Squid(8);
}

void draw() {
  background(0, 0, 200);
  s.update();
  s.display();
}

class Squid {
  Tentacle [] tens;
  float x, y;

  Squid(int cnt) {
    tens = new Tentacle[cnt];

    for (int i = 0; i < tens.length; i++) {
      float theta = map(i, 0, tens.length, 0, TWO_PI);
      tens[i] = new Tentacle(theta);
    }
  }

  void update() {
    move();
    for (Tentacle t : tens) {
      t.update(x, y);
    }
  }

  void move() {
    x += (mouseX+(-.5+noise((mouseX + frameCount)*.008, 0)) * 120 - x) * .09;
    y += (mouseY+(-.5+noise(0, (mouseY + frameCount)*.008, 0)) * 120 - y) * .09;
  }

  void display() {
    for (int i = 0; i < tens.length; i++) {
      stroke(0);
      tens[i].display(7);
    }

    fill(200, 0, 0);
    strokeWeight(3.5);
    ellipse(x, y, 70, 70);
    
    for (int i = 0; i < tens.length; i++) {
      stroke(200, 0, 0);
      tens[i].display(0);
    }
    
    strokeWeight(2);
    stroke(0);
    fill(255);
    ellipse(x + 10, y - 6, 8, 5);
    ellipse(x - 10, y - 6, 8, 5);

    fill(0);
    ellipse(x + 10, y - 6, 1, 1);
    ellipse(x - 10, y - 6, 1, 1);

    noFill();
    arc(x, y + 6, 20, 20, QUARTER_PI, PI-QUARTER_PI);
  }
}

class Tentacle {
  Limb [] segments = new Limb[20];
  Tentacle(float theta) {
    for (int i = 0; i < segments.length; i++) {
      float size = segments.length + 25 -(i*1.75);
      segments[i] = new Limb(size, theta);
    }
  }
  void update(float x, float y) {
    for (int i = 0; i < segments.length; i++) {
      if (i == 0) {   
        segments[i].update(x, y);
      } else {   
        segments[i].update(segments[i-1].currentX, segments[i-1].currentY);
      }
    }
  }

  void display(int strokeWidth) {
    for (int i = 0; i < segments.length; i++) {
      segments[i].display(strokeWidth);
    }
  }
}

class Limb {
  float startX, startY, endX, endY;
  float offsetX, offsetY;
  float currentX, currentY;
  float size;
  float amt;

  Limb(float _size, float theta) {
    size = _size;
    offsetX = 6 * cos(theta);
    offsetY = 6 * sin(theta);
    amt = 0.4;
  }

  void update(float x, float y) {
    startX = x;   
    startY = y;
    endX = startX + offsetX;
    endY = startY + offsetY;

    shake();
    transition();
    checkEdge();
  }

  void transition() {
    currentX = lerp(currentX, endX, amt);
    currentY = lerp(currentY, endY, amt);
  }

  void shake() {
    endX += (.5-noise((endX+frameCount)*.008, 0))*20;
    endY += (.5-noise(0, (endY+frameCount)*.008))*20;
  }

  void checkEdge() {
    endX = endX > 0 ? endX < width ? endX : width : 0;
    endY = endY > 0 ? endY < height ? endY : height : 0;
  }

  void display(float strokeWidth) {
    strokeWeight(size + strokeWidth);
    line(startX, startY, currentX, currentY); 

    strokeWeight(size / 2 + strokeWidth);   
    point(startX + (offsetX*1.5), startY + (offsetY *1.5));
  }
}
