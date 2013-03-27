ArrayList nodes;

float minr = 4;

int time = 0;
int maxage = 550;

float treeheight;

void setup() {
	size(800, 600);
	frameRate(60);	
	ellipseMode(CENTER);
	treeheight = height*0.5;
	nodes = new ArrayList();
	nodes.add(new Node(width/2, height-treeheight, 80, 0));
	noStroke();
}

void draw() {
	background(255);
	int cc = frameCount % 60;
	if(frameCount % 60 < 30) {
		fill(lerpColor(color(51, 88, 23), color(138, 65, 23), cc*(1.0/60)));
	} else {
		fill(lerpColor(color(51, 88, 23), color(138, 65, 23), 1.0-cc*(1.0/60)));
	}

	rect(width/2-width/16, height-constrain(frameCount, 0, treeheight), width/8, height);
	if(frameCount > treeheight) {
		for(int i=1; i<nodes.size(); i++) {
			n = nodes.get(i);
			n.update();
			if(n.l < 2) continue;
			if(n.age > maxage) 	fill(n.l*68%255, 255/n.l, n.l*10);
			else 				fill(n.l*68%25, 255/n.l, n.l*100%32);
			ellipse(n.x, n.y, n.r*2, n.r*2);
		}
		if(frameCount < treeheight+3) {
			for(int i=0; i<6; i++) branch(nodes.get(0)); 
		}
		else if(frameCount % 20 == 0) branch(nodes.get(0));

		if(frameCount % 61 == 0) {
			for(int i=0; i<nodes.size(); i++) {
				n = nodes.get(i);
				if(!n.alive) nodes.remove(i);
			}
		}
	}
}

void branch(Node n, int level) {
	if(n.r < minr) return;
	int amnt = int(random(4));
	for(int i=0; i<amnt; i++) {
		float rx = random(0, width);
		float ry = random(0, height);

		float a = atan2(n.y-ry, n.x-rx);
		nodes.add(new Node(	n.x+(cos(a)*n.r),
							n.y+(sin(a)*n.r), 
							n.r*0.7,
							n.l+1));
		branch(nodes.get(nodes.size()-1));
	}
}

class Node {
	float x;
	float y;
	float r;
	int   l;
	int age;
	boolean alive;

	Node(float x, float y, float r, int l) {
		this.x = x;
		this.y = y;
		this.r = r;
		this.l = l;
		alive = true;
		age = 0;
	}

	void update() {
		age++;
		if(age > maxage) y+=r/10;
		if(y > height+r) alive = false;
	}
}