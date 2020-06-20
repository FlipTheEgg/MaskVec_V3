PImage img;
boolean running;
boolean runOnlyOnce;
boolean fileIsSelected;
String filePath;
int saveIndex;

ArrayList<Method> methods = new ArrayList<Method>();

void setup() {
        fileIsSelected = false;
        // Selectinput opens a file selection dialogue, then calls the function fileSelected().
        selectInput("Select image file:", "fileSelected");

        // vv ADD YOUR METHODS HERE vv

        methods.add(new Method());
        methods.add(new Method());
        methods.add(new Method());
        /*
           methods.get(1).lut = new VectorLUT(1,0);
           methods.get(1).mask = "FF00FFFF";
         */
        // ^^ METHODS ABOVE ^^

        for(Method m : methods) println(m);

        // Jeg ved godt det er et shitty hack.
        saveIndex = int(random(0, 99999999));

        size(100, 100);
        surface.setResizable(true);
        running = false;
        runOnlyOnce = false;
}

void draw() {
        if (fileIsSelected == false) return;
        background(0);
        image(img, 0, 0);

        if (running) {
                for (Method method : methods) {
                        method.activate(img);
                }
                // Necessary, updates the image
                img.updatePixels();
                if (runOnlyOnce) {
                        running = false;
                        runOnlyOnce = false;
                }
        }
}

void fileSelected(File selection) {
        if (selection == null) {
                println("Window was closed or the user hit cancel.");
                println("exiting - goodbye!");
                exit();
        } else {
                println("File selected: \"" + selection.getAbsolutePath() + "\"");
                filePath = selection.getPath();
                if (filePath.toLowerCase().endsWith(".jpg") || filePath.toLowerCase().endsWith(".png")) {
                        img = loadImage(filePath);
                        println("Image info: w: " + img.width + " h: " + img.height + " Total: " + img.width*img.height);
                        fileIsSelected = true;
                        surface.setSize(img.width, img.height);

                        for (Method m : methods) {
                                m.generate(img);
                                println(m);
                        }

                        img.updatePixels();
                        background(0);
                        image(img, 0, 0);
                } else {
                        println("ERROR: Invalid file.");
                        println("exiting - goodbye!");
                        exit();
                }
        }
}

// INPUT HANDLING
void keyPressed() {

        if (key == ' ') { // START/STOP
                running = !running;
                if (running) println("running");
                else println("stopped");
        }
        if (key == 'f') { // ADVANCE ONE FRAME
                running = true;
                runOnlyOnce = true;
        }
        if (key == 's') { // SAVE IMAGE
                saveImage();
        }
        if (key == 'r') { // RELOAD IMAGE
                img = loadImage(filePath);
                running = false;
        }
}

void saveImage() {
        String savePath = sketchPath() + "/captures/";
        img.save(savePath + saveIndex++ + ".png");
        println("image saved as " + saveIndex + ".png");
        //Files not overwriting secured by faith alone
}
