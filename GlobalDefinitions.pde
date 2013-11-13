float SPHERERADIUS = 0.1;   // Size of sphere when drawing points.
float SPHERERADIUS2;        // Square of SPHERERADIUS.
float dt=0.1;               // Movement speed.
float R=10.0;               // Initial distance from eye to viewpoint.
float RMIN=0.01;            // Distance to near viewing plane.
float RMAX=100.0;           // Distance to far viewing plane.
float FOV=45.0;             // Perspecive projection field of view.
float ASPECTRATIO;          // Aspect ration  of the display window.
color   TRIANGLELINECOLOR=0x000000;
color   TRIANGLEFILLCOLOR=0x10EFEF10;

float rotateEye=1.0;        // Eye rotation rate in degrees.
boolean DRAWSCENE=true;     // True for drawing the scene.
boolean DRAWEYEMODE=false;  // True if drawing is offset from the eye.

float W;                    // Width of display window projected onto the viewing plane in U coordinates.
float H;                    // Height of display winidow projected onto the viewing plane in V coordinates;

PVector eye;                // location of the eye (camera).
PVector at;                 // location if the viewpoint in the center of the viewing plane.
PVector Up;                 // unit direction vector to call up in the 3D scene.
PVector Vdir;               // Unit direction vector from the eye to the viewpoint.
PVector U;                  // Unit U vector of the viewing plane in world coordinates.
PVector V;                  // Unit V vector of the viewing plane in world coordinates.
PVector mouseUV;            // Mouse projection onto UV viewing plane.  

vertexlist Points;           // List of points.
int selected;                // Currently selected point.
SelectionList selections;    // List of selected points.
TriangleList trianglelist;   // List of triangles.

float eyeD;                  // Distance from the eye to the viewing plane.
float eyeTheta;              // Current eye rotation angle.

PFont f;         // Font for drawing.
