interface Comparison_i {
    public boolean compare(int a, int b);
}

class Comparison implements Comparison_i{
// Is A larger than B, numerically
public boolean compare(int a, int b) {
        if (a > b) return true;
        else return false;
}

public String toString(){
    return("Comparison");
}
}

class OnesComparison implements Comparison_i {
// Does A contain more ones than B?
int num_to_bits[16] = (0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4);

public boolean compare(int a, int b) {
        // Solution from https://www.geeksforgeeks.org/count-set-bits-in-an-integer/
        int onesA = countSetBitsRec(a);
        int onesB = countSetBitsRec(b);

        if (onesA > onesB) return true;
        else return false;
}
private int countSetBitsRec(int num) {
    int nibble = 0;
    if (num == 0) return num_to_bits[0];

    niblle = num & 0xF;
    return num_to_bits[nibble] + countSetBitsRec(num >> 4);
}

public String toString(){
    return("OnesComparison");
}
}

class BrightnessComparison implements Comparison_i{
// Is A brighter than B? (r+g+b)
boolean compare(int a, int b) {
        int red, green, blue, brightnessA, brightnessB;

        red = (a >> 16) & 0xFF;
        green = (a >> 8) & 0xFF;
        blue = (a >> 0) & 0xFF;
        brightnessA = red + green + blue;

        red = (b >> 16) & 0xFF;
        green = (b >> 8) & 0xFF;
        blue = (b >> 0) & 0xFF;
        brightnessB = red + green + blue;

        if (brightnessA > brightnessB) return true;
        else return false;
}
public String toString(){
    return("BrightnessComparison");
}
}
