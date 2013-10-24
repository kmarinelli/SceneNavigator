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

float eyeX, eyeY,eyeZ;
float atX,atY,atZ;
float upX,upY,upZ;

float eyeD;
float eyeTheta;

boolean drawEyeMode=false;

void setup() 
{
  size(800, 800, OPENGL);
  
  atX=1.0;
  atY=0.0;
  atZ=0.0;
  
  eyeY=0.0;
  eyeD=10.0;
  eyeTheta=0.0;
  
  // Invert the Y axis up component so that we have a sensible view of the scene in a right-hand coordinate system.
  // By default, Processing uses a left-handed coordinate system.
  upX=0.0;
  upY=-1.0;
  upZ=0.0;
  
  frameRate(20);
  noStroke();
  perspective(45.0,1.0,0.1,1000);  // Set the perspective transform. The default clips the znear plane too close.

}

void draw() 
{
   background(128,128,255,255);   // Draw a non-black background, light blue
   
   eyeX=cos(eyeTheta)*eyeD+atX;  // Compute the eye rotation around the Y axis.
   eyeZ=sin(eyeTheta)*eyeD+atZ;
   
   drawEyeMode=false;            // Default is to not draw a spehere at the eye with a vector to "at".
   
   if (keyPressed) 
   {
    if (key =='v')
    {
       camera(10,20.0,10.0,atX,atY,atZ,upX,upY,upZ);  // If someone pressed 'v', look at the scene from the side instead of from the camera view.
       drawEyeMode=true;
    }
  
   }
   else
   {
       camera(eyeX,eyeY,eyeZ,atX,atY,atZ,upX,upY,upZ); // If no 'v' key is pressed, look at the scene from the camera view.
   }

   drawScene();
   
   drawSceneUnitAxes();  // Draw the unit axes at the "at" location.
   drawPlane();          // Draw the UV plane for the screen.
  
  if( drawEyeMode) drawEye();   // If looking from the side of the camera, draw the eye.

   eyeTheta= (eyeTheta+PI/36.0);  // update the camera location.
   if( eyeTheta>TWO_PI) eyeTheta=0.0;
}

void drawScene()
{
   // Draw a simple sphere in the scene.
   lights();
   fill(128,64,64);
   noStroke();
   
   pushMatrix();
      translate(3,0,0);
      sphere(0.5);
   popMatrix();

}

void drawSceneUnitAxes()
{
   stroke(255,0,0);
   line(atX-1, atY-0, atZ-0, atX+1, atY+0, atZ+0);
   stroke(0,255,0);
   line(atX-0, atY-1, atZ-0, atX+0, atY+1, atZ+0);
   stroke(0,0,255);
   line(atX-0, atY-0, atZ-1, atX+0, atY+0, atZ+1);
}

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
}

void drawPlane()
{
  // Draw a plane tangent to the (eye-at),Up vectors. 
  // U is a unit vector perpendicular to  (eye-at),Up.
  // V is a unit vector perpendicular to the (eye-at),U .
  // A grid of lines is drawn in the plane in the U,V axes at unit intervals.
  
  PVector v1;  // vector for calculation.
  PVector v2;  // vector for calculation
  PVector U;  // Unit U vector
  PVector V;  // Unit V vector
  PVector Top;
  PVector Bottom;
  PVector PU;  // Scaled U vector.
  PVector PV;  // Scaled V vector.
  
  int i;
  
  v1=new PVector(eyeX-atX,eyeY-atY,eyeZ-atZ);
  v1.normalize();
  v2=new PVector(upX,upY,upZ);
  v2.normalize();
  U=v1.cross(v2);
  U.normalize();
  
  AT=new PVector(atX,atY,atZ);
  PU=new PVector(U.x,U.y,U.z);
  PU.mult(10);
    
  v1=new PVector(eyeX-atX,eyeY-atY,eyeZ-atZ);
  v1.normalize();
  V=v1.cross(U);
  V.normalize();
  
  PV=new PVector(V.x,V.y,V.z);
  PV.mult(10);
   
  stroke(200,200,200,64);
  for(i=-10;i<=10;i++)
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
  PU.mult(10);
  for(i=-10;i<=10;i++)
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

