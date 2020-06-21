//<>//
// A LUT is a table of alternative index values for the pixels of a given image.
// the constructor sets the values, and generate() makes a table based on a specific image.

interface LUTi {
public void generate(PImage img);
public int[] getData();
public void setData(int[] data);
}

class LUTbase {
protected int[] data;
protected boolean generated = false;

public int[] getData() {
        return this.data;
}

public void setData(int[] data) {
        this.data = data;
}

public String toString() {
        return "LUTbase";
}
}

class VectorLUT extends LUTbase implements LUTi {
private Cartesian vec;

// Constructor 1 - randomises variables.
VectorLUT() {
        int x = int(random(-5, 5));
        int y = int(random(-5, 5));
        this.vec = new Cartesian(x, y);
}
// Constructor 2 - set variables.
VectorLUT(int vecX, int vecY) {
        this.vec = new Cartesian(vecX, vecY);
}

public String toString() {
    String out = "VectorLUT" + this.vec;
    if(!generated) out += ", not generated";
    return out;
}

public void generate(PImage img) {

        int w = img.width;
        int h = img.height;

        this.data = new int[w*h];

        for (int i=0; i<(h*w); i++) {
                Cartesian A = IndexToCartesian(img, i);
                Cartesian B = new Cartesian();

                B.x = A.x + vec.x;
                B.y = A.y + vec.y;

                B = GetCoordinateInBounds_bounce(img, B);
                this.data[i] = CartesianToIndex(img, B);
        }
        this.generated = true;
}   // end generate
} // end class VectorLUT

// POLAR LUT:
// Set by the user through a polar vector, and an proportional offset (centre of rotation.)
// The offset is between 0 and 1, and is modulo'ed internally.

class PolarLUT extends LUTbase implements LUTi {
private Polar vec;
private Cartesian offset;
float xOffsetRatio, yOffsetRatio;

// Constructor 1 - Random vec, default offset:
PolarLUT() {
        float radius = random(-5, 5);
        float angle = random(-0.1, 0.1);
        this.vec = new Polar(radius, angle);
        this.xOffsetRatio = random(1);
        this.yOffsetRatio = random(1);
}

// TODO: Half-defined constructors? EVT just one with optional parameters
// Maybe the ability to set parameters externally covers this.
// Maybe a ---BuIlDeR---?!

// Fully user-defined:
PolarLUT(float radius, float angle, float xOffsetRatio, float yOffsetRatio) {
        this.vec = new Polar(radius, angle);
        this.xOffsetRatio = abs(xOffsetRatio % 1);
        this.yOffsetRatio = abs(yOffsetRatio % 1);
}

public String toString() {
    String out = "";
    out += "PolarLUT(" + nf(this.vec.radius, 0, 3) + ", " + nf(this.vec.angle, 0, 3) + "), ";
    out += "offset(" + nf(this.xOffsetRatio, 0, 3) + ", " + nf(this.yOffsetRatio, 0, 3) + ")";
    if(!generated) out += ", not generated";
    return out;
}

public void generate(PImage img) {

        int w = img.width;
        int h = img.height;

        this.data = new int[w*h];

        this.offset = new Cartesian();
        this.offset.x = int(w * (this.xOffsetRatio));
        this.offset.y = int(h * (this.yOffsetRatio));

        //Go through the image pixel by pixel
        for (int i=0; i<(h*w); i++) {
                Cartesian A_c, B_c;
                Polar A_p, B_p;

                A_c = IndexToCartesian(img, i);
                A_p = CartesianToPolar(A_c, this.offset);
                B_p = A_p.add(this.vec);
                B_c = PolarToCartesian(B_p, this.offset);

                B_c = GetCoordinateInBounds_bounce(img, B_c);

                this.data[i] = CartesianToIndex(img, B_c);
        }
        this.generated = true;
}   //end generate
} //end class PolarLUT

class RandomVectorLUT extends LUTbase implements LUTi {
    private Cartesian xRange, yRange;

    // Every pixel gets a random vector within the set range. The default constructor sets a random range.

    // constructor 1, randomized
    RandomVectorLUT() {
        int lower, upper;

        lower = int(random(-5, 5));
        upper = int(random(-5, 5));
        this.xRange = new Cartesian(lower, upper);

        lower = int(random(-5, 5));
        upper = int(random(-5, 5));
        this.yRange = new Cartesian(lower, upper);
    }
    // constructor 2, user-defined
    RandomVectorLUT(int lowerX, int upperX, int lowerY, int upperY){
        this.xRange = new Cartesian(lowerX, upperX);
        this.yRange = new Cartesian(lowerY, upperY);
    }

    private int getRandomInRange(Cartesian range){
        // corrects for if lower > upper, and for the rounding of casting random to int.
        int lower, higher;

        if range.x > range.y{
            lower = range.y;
            upper = range.x + 1;
        } else {
            lower = range.x;
            upper = range.y + 1;
        }

        if(lower < 0) lower -= 1;

        return int(random(lower, higher));
    }

    public void generate(PImage img) {
            int w = img.width;
            int h = img.height;
            this.data = new int[w*h];
            for(int i = 0; i < w*h; i++){

                Cartesian c = IndexToCartesian(img, i);
                int x = getRandomInRange(xRange);
                int y = getRandomInRange(yRange);
                Cartesian vec = new Cartesian(x,y);
                c = c.add(vec);
                c = GetCoordinateInBounds_bounce(img, c);
                int j = CartesianToIndex(img, c);
                this.data[i] = j;
                //println("i: " + i + ", j: " + j + ", vec:" + vec);
            }
            this.generated = true;
    }

    public String toString() {
        String out = "";
        out += "RandomVectorLUT ";
        out += "x" + this.xRange + ", y" + this.yRange;
        if(!generated) out += ", not generated";
        return out;
    }
}
