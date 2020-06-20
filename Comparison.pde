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
public boolean compare(int a, int b) {

        int onesA = countSetBits(a);
        int onesB = countSetBits(b);

        if (onesA > onesB) return true;
        else return false;
}

private int countSetBits(int n) {
        if (n == 0) return 0;
        else return 1 + countSetBits(n & (n-1));
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
