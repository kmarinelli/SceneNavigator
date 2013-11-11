PVector eye;  // location of the eye (camera).
PVector at;      // location if the viewpoint, the center of the viewing plane that the eye is looking at.
PVector mouseUV;  // Mouse projection onto UV viewing plane.
float upX,upY,upZ;      // unit direction vector to call up in the 3D scene.
float dx,dy,dz;         // Unit direction vector from the eye to the viewpoint.
float dt=0.1;

float R=10.0;    // Radius of rotation for the eye (camera).
float RMIN=0.01;
float RMAX=100.0;
float eyeD;      // Distance from the eye to the viewing plane.
float eyeTheta;

float FOV=45.0; // Perspecive projection field of view.
float ASPECTRATIO; // Aspect ration  of the display window.

PVector U; // Unit U vector of the viewing plane in world coordinates.
float uX,uY,uZ; // Separate ordinated of U.

PVector V;  // Unit V vector of the viewing plane in world coordinates.
float vX,vY,vZ; // Separate ordinated of V.

float W;    // Width of display window projected onto the viewing plane in U coordinate.
float H;    // Height of display winidow projected onto the viewing plane in V coordinates;

float rotateEye=1.0;
boolean DRAWSCENE=true;     // True for drawing the scene.
boolean DRAWEYEMODE=false;  // True if drawing is offset from the eye.
PFont f;
 
vertexlist Points;
int selected;
SelectionList selections;

float SPHERERADIUS = 0.1;
float SPHERERADIUS2;  // Square of SPHERERADIUS.

