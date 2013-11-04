// Test of camera view scene calculations.
// Kevin Marinelli
// This tests the calculations for changing the position of the camera view in a scene.
// The vew change for the moment is a simple rotation around the Y axis.
//
// Pressing the "v" key changes the scene view to the side of the camera and draws the camera location in the scene.
// The input focus must be set to the window for the 'v' key to work.
//
//
// NOTE: This program works in both Java and JavaScript environments for Processing2.
//

//import java.awt.AWTException;
//import java.awt.Robot;

float eyeX, eyeY,eyeZ;  // location of the eye (camera).
float atX,atY,atZ;      // location if the viewpoint, the center of the viewing plane that the eye is looking at.
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
 
// Robot is not available in JavaScript mode! Need to find an alternative!
//Robot robot;    // Robot class is used for positioning the mouse cursor. (may be useful when changing to offset view to reposition the mouse pointer to keep
                // the same UV coordinate position, instead of the mouse position having a new UV coordinate after the view change.
 
void setup() 
{
  float d;
  
  size(800, 800, OPENGL);
 
 /*  Does not work in JavaScript mode- need to find an alternatice technique.
  try 
  { 
    robot = new Robot();
  } 
  catch (AWTException e) 
  {
    e.printStackTrace();
  }
  robot.mouseMove(width/2, height/2);      // Initialize the mouse position to the center of the screen.
*/
  noCursor();                              // Turn off the normal mouse pointer.
   
  atX=0.0;
  atY=0.0;
  atZ=0.0;
  
  eyeX=atX-R;
  eyeZ=atZ;
  eyeY=0.0;
  
  eyeD=sqrt((eyeX-atX)*(eyeX-atX)+(eyeY-atY)*(eyeY-atY)+(eyeZ-atZ)*(eyeZ-atZ) );
  eyeTheta=0.0;
  
  // Invert the Y axis up component so that we have a sensible view of the scene in a right-hand coordinate system.
  // By default, Processing uses a left-handed coordinate system.
  upX=0.0;
  upY=-1.0;
  upZ=0.0;
  
  frameRate(30);
  noStroke();
  ASPECTRATIO=(float)width/(float)height;
  
  println(ASPECTRATIO);
  
  perspective(FOV,ASPECTRATIO,0.1,1000);  // Set the perspective transform. The default clips the znear plane too close.
  f = createFont("Arial",16,true);        // Arial, 16 point, anti-aliasing on
}

void draw() 
{
   float d;
   background(128,128,255,255);   // Draw a non-black background, light blue
   
   // Note! This code is in error for arbitrary location. It should be
   // a rotation around the V axis, which affects all of eyeX,eyeY,eyeZ.
   //
   eyeX=cos(eyeTheta)*R+atX;  // Compute the eye rotation around the Y axis.
   eyeZ=sin(eyeTheta)*R+atZ;
   
   rotateEye=0.0;
   camera(eyeX,eyeY,eyeZ,atX,atY,atZ,upX,upY,upZ); // If no 'v' key is pressed, look at the scene from the camera view.

   dx=atX-eyeX;
   dy=atY-eyeY;
   dz=atZ-eyeZ;
   d=sqrt(dx*dx+dy*dy+dz*dz);
   if( d == 0) d=1.0; // Note d should never be allowed to be zero under any circumstances! This is a failsafe!
  
   dx=dx/d;
   dy=dy/d;
   dz=dz/d;
  
   ProcessUserInput();

   if( DRAWEYEMODE)  camera(atX-d*dx*3+U.x*5.0+V.x*2.0, atY-d*dy*3+U.y*5.0+V.y*2.0,atZ-d*dz*3+U.z*5.0+V.z*2.0,atX,atY,atZ,upX,upY,upZ);  // If someone pressed 'v', look at the scene from the side instead of from the camera view.

   ComputeUV();
   ComputeWindowProjection();

   if(DRAWSCENE)drawScene();
   
   drawSceneUnitAxes();  // Draw the unit axes at the "at" location.
   DrawWindowProjection();      // Draw the window projected onto the viewing plane

   drawPlane();          // Draw unit grid lines in UV coordinates on the viewing plane.
  

  if( DRAWEYEMODE) drawEye();   // If looking from the side of the camera, draw the eye.


//
//  Note! This is NOT accurate for arbitrary 3D rotation of the eye yet!!
//  It should be a rotation in the (U,Lookat) plane
   if(rotateEye!=0.0)
   {
      eyeTheta= (eyeTheta+PI/36.0*rotateEye);  // update the camera location.
      if( eyeTheta>TWO_PI) eyeTheta=0.0;
      if( eyeTheta<0) eyeTheta=TWO_PI;
   }
   resetMatrix();
   fill(0, 102, 153);
   textSize(32);
   text("word", 10, 30); 
}

// Handle User interface input.
void ProcessUserInput()
{
   ProcessKeyInput();
   ProcessMouseInput();
}

// Compute the range of U,V coordinates in the display window.
void ComputeWindowProjection()
{
  W=tan(FOV/2)*eyeD*ASPECTRATIO; // +/- U extent
  H=W/ASPECTRATIO;               // +/- V extent
}

/*
   Project the program's display window onto the viewing plane.
*/
void DrawWindowProjection()
{
  // Distance from the eye to the viewing plane is eyeD. (currently a constant of 10, but that may be user modifyable later).
  // Field of view is FOV.
  // Aspect ratio of the display window is ASPECTRATIO.
  //The center line to the left edge of the screen has an angle of FOV/2. 
  // The distance from the center of the screen to the edge of the screen, W, in the U axis is W=tan(FOV/2)*eyeD.
  // The distance from the center of the screen to the vertical edge of the screen, H, in the V axis is H=W*ASPECTRATIO.

  PVector PULeft,PURight;
  PVector PLLeft,PLRight;
  PVector UTemp;
  PVector VTemp;
  float scale=1.0;  // scaling to be able  to observe the projected window during testing.
 
  PVector mx;
  
   stroke(255,255,128);
  
  UTemp= new PVector(U.x,U.y,U.z);
  UTemp.mult(W);
  
  VTemp= new PVector(V.x,V.y,V.z);
  VTemp.mult(H);
  
  PULeft=new PVector(atX+U.x*W*scale+V.x*H*scale,
                     atY+U.y*W*scale+V.y*H*scale,
                     atZ+U.z*W*scale+V.z*H*scale);
  
  PURight=new PVector(atX-U.x*W*scale+V.x*H*scale,
                      atY-U.y*W*scale+V.y*H*scale,
                      atZ-U.z*W*scale+V.z*H*scale);

  PLLeft=new PVector(atX+U.x*W*scale-V.x*H*scale,
                     atY+U.y*W*scale-V.y*H*scale,
                     atZ+U.z*W*scale-V.z*H*scale);
  
  PLRight=new PVector(atX-U.x*W*scale-V.x*H*scale,
                      atY-U.y*W*scale-V.y*H*scale,
                      atZ-U.z*W*scale-V.z*H*scale);
  
  stroke(255,255,128);
  line(PULeft.x,PULeft.y,PULeft.z, PURight.x,PURight.y,PURight.z);
  stroke(255,128,128);
  line(PULeft.x,PULeft.y,PULeft.z,PLLeft.x,PLLeft.y,PLLeft.z);
  stroke(128,255,128);
  line(PLLeft.x,PLLeft.y,PLLeft.z,PLRight.x,PLRight.y,PLRight.z);
  stroke(0,0,0);
  line(PURight.x,PURight.y,PURight.z,PLRight.x,PLRight.y,PLRight.z);
}

// Draw the geometry of the scene. (fixed geopmetry of one vertex for now).
void drawScene()
{
   // Draw a simple sphere in the scene.
   lights();
   fill(128,64,64);
   noStroke();
   
   pushMatrix();
      translate(0,0,0);
      sphere(0.1);
   popMatrix();

}

void drawSceneUnitAxes()
{
   stroke(255,0,0);
   line(atX-1, atY-0, atZ-0, atX+1, atY+0, atZ+0);
   line(atX+1-0.25,atY+0.25,atZ,atX+1,atY+0,atZ+0);
   line(atX+1-0.25,atY-0.25,atZ,atX+1,atY+0,atZ+0);
   stroke(0,255,0);
   line(atX-0, atY-1, atZ-0, atX+0, atY+1, atZ+0);
   line(atX-0.25,atY+1-0.25,atZ,atX+0,atY+1,atZ+0);
   line(atX+0.25,atY+1-0.25,atZ,atX+0,atY+1,atZ+0);
   stroke(0,0,255);
   line(atX-0, atY-0, atZ-1, atX+0, atY+0, atZ+1);
   line(atX+0, atY-0.25, atZ+1-0.25, atX+0, atY+0, atZ+1);
   line(atX+0, atY+0.25, atZ+1-0.25, atX+0, atY+0, atZ+1);
   fill(0,0,0);
   textSize(10);
   pushMatrix();
      translate(atX+1.0,atY-0.15,atZ+0.0);
      scale(0.03,-0.03,0.03);
      text("X",0.0,0.0,0.0);
   popMatrix();
   pushMatrix();
      translate(atX-0.13,atY+1.0,atZ+0.0);

      scale(0.03,-0.03,0.03);
      text("Y",0,0,0.0);
   popMatrix();
   pushMatrix();
      translate(atX+0,atY-0.15,atZ+1.0);
      rotate(PI/2,0.0,-1.0,0.0);
      scale(0.03,-0.03,0.03);
      text("Z",0.0,0.0,0.0);
   popMatrix();

}

// Draw a sphere at the eye location and a magenta line from the eye to the viewpoint (atX, atY, atZ).
void drawEye()
{
   noStroke();
   fill(64,64,255);
   pushMatrix();
      translate(eyeX,eyeY,eyeZ);
      sphere(0.25);
   popMatrix();
  
  stroke(255,0,255);
  line(eyeX,eyeY,eyeZ,atX,atY,atZ);
  strokeWeight(1);
  stroke(128,0,128,64);
  line(atX-dx*50.0, atY-dy*50.0, atZ-dz*50.0, atX+dx*50.0, atY+dy*50.0, atZ+dz*50.0);
}

// Compute ine unit UV coordinates of the viewing plane.
//
void ComputeUV()
{
  PVector v1;
  PVector v2;
  
  v1=new PVector(eyeX-atX,eyeY-atY,eyeZ-atZ);
  v1.normalize();
  v2=new PVector(upX,upY,upZ);
  v2.normalize();
  U=v1.cross(v2);
  U.normalize();
  uX=U.x;
  uY=U.y;
  uZ=U.z;

  v1=new PVector(eyeX-atX,eyeY-atY,eyeZ-atZ);
  v1.normalize();
  V=v1.cross(U);
  V.normalize();
  vX=V.x;
  vY=V.y;
  vZ=V.z;

}

void drawPlane()
{
  // Draw a plane tangent to the (eye-at),Up vectors. 
  // U is a unit vector perpendicular to  (eye-at),Up.
  // V is a unit vector perpendicular to the (eye-at),U .
  // A grid of lines is drawn in the plane in the U,V axes at unit intervals.
  
  PVector v1;  // vector for calculation.
  PVector v2;  // vector for calculation
  PVector Top;
  PVector Bottom;
  PVector PU;  // Scaled U vector.
  PVector PV;  // Scaled V vector.
  
  int i;
  
  PU=new PVector(U.x,U.y,U.z);
  PU.mult((int)W+1);
    
  
  PV=new PVector(V.x,V.y,V.z);
  PV.mult((int)H+1);
   
  stroke(200,200,200,64);
//  for(i=-( (int)W+1);i<=(int)(W+1);i++)
  for(i=-( (int)W+1);i<=(int)W+1;i++)
  {
     PU=new PVector(U.x*i,U.y*i,U.z*i);
     Top=new PVector(atX,atY,atZ);
     Top.add(PV);
     Top.add(PU);
     Bottom= new PVector(atX,atY,atZ);
     Bottom.sub(PV);
     Bottom.add(PU);
     line(Top.x,Top.y,Top.z,Bottom.x,Bottom.y,Bottom.z);
  }
  
  PU=new PVector(U.x,U.y,U.z);
  PU.mult((int)W+1);
  for(i=-( (int)H+1);i<=(int)H+1;i++)
  {
     PV=new PVector(V.x*i,V.y*i,V.z*i);
     Top=new PVector(atX,atY,atZ);
     Top.add(PV);
     Top.add(PU);
     Bottom= new PVector(atX,atY,atZ);
     Bottom.add(PV);
     Bottom.sub(PU);
     line(Top.x,Top.y,Top.z,Bottom.x,Bottom.y,Bottom.z);
  }
}

