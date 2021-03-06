import processing.opengl.*;

float a; 
int spheres = 10;
int rad = 5;
int range = 10;
float[][] map = new float[spheres][3];
float[][] last_map = new float[spheres][3];
float[][] orig_map = new float[spheres][3];

void setup() {
  size(800, 600, OPENGL);
  fill(0, 50);
  noStroke();
  smooth();
  for (int x = 0; x < spheres; x++) {
     map[x][0] = orig_map[x][0] = last_map[x][0] = random(-range,range);
     map[x][1] = orig_map[x][1] = last_map[x][0] = random(-range,range);
     map[x][2] = orig_map[x][2] = last_map[x][0] = random(-range,range);
     
     draw_sphere(map[x]);
   }
   background(255);
   frameRate(30);
}

float spread = 0.0;

void draw() {
  background(0);  
  
//  fill(0,20);
//  translate(0,0,100);
//  rect(0,0,width,height);

  //rotateX(mouseY / -200.0);
  spread = mouseY / 40.0;
  translate(width / 2, height / 2);
  //rotateY(mouseX / 40.0);
  rotateY(a);
  for (int x = 0; x < spheres; x++) {
    last_map[x][0] = map[x][0];
    last_map[x][1] = map[x][1];
    last_map[x][2] = map[x][2];

    map[x] = update_pos(map[x], orig_map[x], spread);
    //draw_sphere(map[x]);
    draw_line(map[x], last_map[x]);
  }

  a += 1;
  
}

void draw_sphere(float[] xyz) {
  translate(xyz[0], xyz[1], xyz[2]);
  fill(200, 100);
  ellipse(0,0,rad,rad);
//  sphere(rad);
}

void draw_line(float[] xyz, float[] prev) {
  stroke(255);
  line(xyz[0], xyz[1], xyz[2], prev[0], prev[1], prev[2]);
}


float[] update_pos(float[] xyz, float[] orig_xyz, float spr) {
  xyz[0] = orig_xyz[0] * spr;
  xyz[1] = orig_xyz[1] * spr;
  xyz[2] = orig_xyz[2] * spr;  
  return xyz;
}
