class Method {
//What does a method do?
//It does the sorting
//Can it manipulate its own LUT?

// A list of methods comprise the totality of what is done to the image.
// Every cycle every method is activated through a function called... activate
//  - This method can call other internal methods, such as keep a tally, skipping every x step etc.
// The method directly alters the image.

// What does it have?
// - a LUT
// - a bitwise mask
//   - Does the comparison run inside or outside the mask?
// - a comparison method
// - something it runs every time it's called

LUTi lut;
String mask;
int iterations;
int sortType;
Comparison_i c;

// CONSTRUCTORS:

// Completely random
Method() {
        this.lut = getRandomLUT();
        this.mask = getRandomMask();
        this.c = getRandomComparison();
}

// Perhaps a builder would be good for this?
// TODO: Fully defined (called by MethodBuilder?)

public void generate(PImage img) {
        this.lut.generate(img);
}

public PImage activate(PImage img) {
        //TODO
        iterations++;
        return sortImage(img);
}

private PImage sortImage(PImage img) {
        PImage result = img;

        // TODO: make a sort based on this.sortType

        int mask = unhex(this.mask);

        int pixelA;
        int pixelB;

        int w = img.width;
        int h = img.height;

        //Go through the image pixel by pixel
        // TODO: Decide whether to get the original values from img or from result.
        // Right now it's from result, BC this is non-destructive.
        for (int i=0; i<(h*w); i++) {
                int iA = i;
                int iB = this.lut.getData()[i];

                pixelA = result.pixels[iA];
                pixelB = result.pixels[iB];

                pixelA &= mask;
                pixelB &= mask;

                // Replace with conditional type
                if (this.c.compare(pixelA, pixelB)) {
                        result.pixels[iA] &= ~mask;
                        result.pixels[iA] |= pixelB;

                        result.pixels[iB] &= ~mask;
                        result.pixels[iB] |= pixelA;
                }
        }
        return result;
}

// Perhaps this belongs in LUT?
// The logic is, that this function needs to know how many different LUTs there are...
private LUTi getRandomLUT() {
        // TODO: Hardcoded bad
        int numberOfLUTs = 3;

        int choice = int(random(numberOfLUTs));
        LUTi selectedLUT;

        switch(choice) {
                case 0:
                        return new VectorLUT();
                case 1:
                        return new PolarLUT();
                case 2:
                        return new RandomVectorLUT();
                default:
                        println("WARNING: getRandomLUT defaulted. This is not supposed to happen.");
                        println("choice == " + choice);
                        return new VectorLUT();
        }
}

private String getRandomMask() {
        //Not a universal list, just some good defaults.
        StringList masks = new StringList();
        masks.append("FFFFFFFF");
        masks.append("FF0000FF");
        masks.append("FF00FF00");
        masks.append("FFFF0000");
        masks.append("FFFFFF00");
        masks.append("FFFF00FF");
        masks.append("FF00FFFF");
        masks.append("FF0F0F0F");
        masks.append("FFF0F0F0");
        masks.append("FF555555"); // 01010101
        masks.append("FFAAAAAA"); // 10101010

        int choice = int(random(masks.size()));

        return masks.get(choice);
}

private Comparison_i getRandomComparison(){
        // TODO: Hardcoded bad!
        int numberOfComparisons = 3;

        int choice = int(random(numberOfComparisons));
        switch(choice){
            case 0:
                return new Comparison();
            case 1:
                return new OnesComparison();
            case 2:
                return new BrightnessComparison();
            default:
                return new Comparison();
        }
}

public String toString() {

        // For recreating patterns when using random params.
        String output = "";
        output += "Method: ";

        output += this.lut;
        output += ", " + this.mask;
        output += ", " + this.c;

        return output;
}
}
