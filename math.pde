
// En samling funktioner der håndterer cartesiske og polære koordinater.

class Cartesian {
int x;
int y;

Cartesian(int x, int y) {
        this.x = x;
        this.y = y;
}

Cartesian() {
        this.x = 0;
        this.y = 0;
}

public String toString() {
        return "(" + x + ", " + y + ")";
}
} // end class Cartesian

class Polar {
float radius;
float angle;

Polar(float radius, float angle) {
        this.radius = radius;
        this.angle = angle;
}

Polar() {
        this.radius = 0;
        this.angle = 0;
}

public String toString() {
        return "(" + radius + ", " + angle + ")";
}

Polar add(Polar that) {
        Polar result = new Polar();
        result.radius = this.radius + that.radius;
        result.angle = this.angle + that.angle;
        return result;
}
} // end class Polar

Cartesian PolarToCartesian(Polar c, Cartesian offset) {
        Cartesian result = new Cartesian();
        result.x = int(c.radius * cos(c.angle)) + offset.x;
        result.y = int(c.radius * sin(c.angle)) + offset.y;
        return result;
}

Polar CartesianToPolar(Cartesian c, Cartesian offset) {
        Polar result = new Polar();
        int x = c.x - offset.x;
        int y = c.y - offset.y;
        result.radius = sqrt((x * x) + (y * y));
        result.angle = atan2(y, x);
        return result;
}

Cartesian GetCoordinateInBounds_wrap(PImage img, Cartesian c) {
        Cartesian result = new Cartesian();
        int xmax = img.width - 1;
        int ymax = img.height - 1;

        if (c.x < 0) result.x = c.x + xmax;
        else if (c.x > xmax) result.x = c.x - xmax;
        else result.x = c.x;

        if (c.y < 0) result.y = c.y + ymax;
        else if (c.y > ymax) result.y = c.y - ymax;
        else result.y = c.y;

        return result;
}

Cartesian GetCoordinateInBounds_bounce(PImage img, Cartesian c) {
        Cartesian result = new Cartesian();
        int xmax = img.width - 1;
        int ymax = img.height - 1;

        if (c.x < 0) result.x = -c.x - 1;
        else if (c.x > xmax) result.x = (2 * xmax) - c.x + 1;
        else result.x = c.x;

        if (c.y < 0) result.y = -c.y - 1;
        else if (c.y > ymax) result.y = (2 * ymax) - c.y + 1;
        else result.y = c.y;

        return result;
}

Cartesian IndexToCartesian(PImage img, int index) {
        Cartesian result = new Cartesian();
        result.x = index % img.width;
        result.y = index / img.width;
        return result;
}

int CartesianToIndex(PImage img, Cartesian c) {
        return (c.y * img.width) + c.x;
}
