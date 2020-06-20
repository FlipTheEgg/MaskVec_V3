//<>//
// A LUT is a table of alternative index values for the pixels of a given image.
// the constructor sets the values, and generate() makes a table based on a specific image.


//interface iLUT
// hvad skal alle LUT kunne udefra?
// gen skal op i interfacet
// vectorlut im

interface LUTi {
public void generate(PImage img);
public int[] getData();
public void setData(int[] data);
}

class LUTbase {
protected int[] data;
protected String infoString;
protected boolean generated = false;

public int[] getData() {
        return this.data;
}

public void setData(int[] data) {
        this.data = data;
}

public String toString() {
        return infoString;
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
        setInfoString();
}

private void setInfoString() {
        this.infoString = "VectorLUT" + this.vec + ", " + generated;
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
        setInfoString();
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

private void setInfoString() {
        String offsetString = "offset(" + this.xOffsetRatio + ", " + this.yOffsetRatio + ")";
        this.infoString = "PolarLUT" + this.vec + ", " + offsetString + ", " + generated;
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
        setInfoString();
}   //end generate
} //end class PolarLUT
