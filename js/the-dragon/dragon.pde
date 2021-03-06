// processing.js version
/*
    The dragon curve drawn using an L-system.

    Here, F means "draw forward", - means "turn left 90°", and + means "turn
    right 90°". X and Y do not correspond to any drawing action and are only
    used to control the evolution of the curve.


    A simple tree:

    0: draw a line segment ending in a leaf
    1: draw a line segment
    [: push position and angle, turn left 45 degrees
    ]: pop position and angle, turn right 45 degrees

 */

var RULESET;

class Pen {
  int x, y, q, fx, fy;
  int r = 2; // line length
  int turn = 90; // turn
  ArrayList __state;

  Pen(angle, length) {
    turn = angle || 90;
    r = length || 2;
    reset();
  }

  void reset() {
    x = 0;
    y = 0;
    fx = 0;
    fy = 0;
    q = 0;
    __state = [];
  }

  void drawForward() {
    float t = q * (PI / 180.0);
    fx = x + round(r * sin(t));
    fy = y + round(r * cos(t));

    line(x, y, fx, fy);

    x = fx;
    y = fy;
  }

  void turnLeft() {
    q -= turn;
  }

  void turnRight() {
    q += turn;
  }

  void leaf() {
    // nothing yet
  }

  String stateString() {
    return "x:" + x + " y:" + y + " q:" + q;
  }

  // return state or set-and-return
  Array state(other) {
    if (typeof(other) != "undefined") {
      x  = other[0];
      y  = other[1];
      fx = other[2];
      fy = other[3];
      q  = other[4];
    }

    return [x, y, fx, fy, q];
  }

  void pushState() {
    __state.push(state());
    return state();
  }

  void popState() {
    state(__state.pop());
    return state();
  }

  // render a single instruction
  void render(chr) {
    RULESET.render(this, chr);
  }
}


// return next string
String evolve (str) {
  var out_string = [], result;
  for (int i=0; i < str.length(); i++) {
    result = RULESET.evolve[str[i]];
    if (typeof result == "undefined")
      out_string.push(str[i]);
    else
      out_string.push(result);
  }
  return out_string.join('');
}

String s;
Pen pen;
float rot;
int instr;
Object currentRuleset;

void resize(float X, float  Y) {
  size(X,Y);
}

void init(rules) {
  RULESET = rules;

  int n = 0;
  s = RULESET.axiom;
  pen = new Pen(RULESET.angle, RULESET.length);
  while (n < RULESET.generations) {
    s = evolve(s);
    n++;
  }
  instr = 0;

  setStrokeToRuleset();

  // show resulting string
  // console.log(s);

  // progress bar
  fadr = 0;

  strokeWeight(1);
  background(#141414);
}

void drawProgress(completion) {
  var prog_height = 20,
      prog_width = 280,
      prog_padding = 2,
      inset = 0,
      edge_padding = 8;

  var bx = width - prog_width - edge_padding,
      by = height - prog_height - edge_padding,
      ex = bx + prog_width;

  if (completion < 0) {
    fill(20, 20, 20, 30);
    noStroke();
    // fader
    rect(bx - 1, by - 1, prog_width + 2, prog_height + 2);
  } else if (completion <= 1.0) {
    rect(bx, by, prog_width, prog_height);
    noStroke();
    fill(#eeeeee);
    rect(bx, by,
         prog_width * completion,
         prog_height);
    setStrokeToRuleset();
  }
}

void setStrokeToRuleset() {
  if (typeof RULESET.color == "string") {
    var c = rgb2color(RULESET.color);
    stroke(c.r, c.g, c.b);
  } else {
    stroke(RULESET.color.r, RULESET.color.g, RULESET.color.b);
  }
}

void setup () {
  size(800, 800);
  ProcessingInit();
}

int fadr;
boolean completed = false;
void draw () {
  pushMatrix();
  translate(width * RULESET.start.x, height * RULESET.start.y);
  rotate(RULESET.start.r || 0);

  // several steps per draw loop
  for (int r=0; r < 16; r++) {
    if (instr < s.length()) {
      pen.render(s.charAt(instr));
    }
    instr++;
  }
  popMatrix();

  stroke(#888888);
  noFill();

  if (instr < s.length()) {
    drawProgress(1.0 * instr / s.length());
    completed = true;
  } else {
    // draw completed once
    if (completed) {
      drawProgress(100.0);
      completed = false;
    }
    // 20 frames for fading
    if (fadr < 40) {
      drawProgress(-1);
      fadr++;
    }
  }
}
