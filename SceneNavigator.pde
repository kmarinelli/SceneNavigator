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

void setup() 
{
  float d;
  
  size(800, 800, OPENGL);
 
  noCursor();                              // Turn off the normal mouse pointer.
   
  at = new PVector(0.0,0.0,0.0);
  
  eye = new PVector(-R,0.0,0.0);
     
  mouseUV = new PVector(0.0,0.0,0.0);
  
  eyeD=sqrt((eye.x-at.x)*(eye.x-at.x)+
            (eye.y-at.y)*(eye.y-at.y)+
            (eye.z-at.z)*(eye.z-at.z) );
  eyeTheta=0.0;

 
  // Invert the Y axis up component so that we have a sensible view of the scene in a right-hand coordinate system.
  // By default, Processing uses a left-handed coordinate system.

  Up = new PVector(0.0, -1.0, 0.0);
  ComputeUV();

  Vdir = new PVector(at.x,at.y,at.z);
  Vdir.sub(eye);


  selected=-1;
  selections   = new SelectionList();
  Points       = new vertexlist();
  trianglelist = new TriangleList();
 
  frameRate(30);
  noStroke();
  ASPECTRATIO=(float)width/(float)height;
  
  println(ASPECTRATIO);

  SPHERERADIUS2=SPHERERADIUS*SPHERERADIUS;
 
  perspective(FOV,ASPECTRATIO,0.1,1000);  // Set the perspective transform. The default clips the znear plane too close.

f = createFont("Arial",16,true);        // Arial, 16 point, anti-aliasing on


}

void draw() 
{
   float d;
   background(128,128,255,255);   // Draw a non-black background, light blue
  

   // Note! This code is in error for arbitrary location. It should be
   // a rotation around the V axis, which affects the eye.
   //
   eye.x=cos(eyeTheta)*R+at.x;  // Compute the eye rotation around the Y axis.
   eye.z=sin(eyeTheta)*R+at.z;
   
   rotateEye=0.0;
 
   Vdir.x= at.x - eye.x;
   Vdir.y= at.y - eye.y;
   Vdir.z= at.z - eye.z;
   
   d=sqrt(Vdir.x*Vdir.x+Vdir.y*Vdir.y+Vdir.z*Vdir.z);
   if( d == 0) d=1.0; // Note d should never be allowed to be zero under any circumstances! This is a failsafe!
  
   Vdir.x=Vdir.x/d;
   Vdir.y=Vdir.y/d;
   Vdir.z=Vdir.z/d;


   if( DRAWEYEMODE) 
   { 
      camera(at.x-R*Vdir.x+U.x*3.0+V.x*2.0, 
             at.y-R*Vdir.y+U.y*3.0+V.y*2.0,
             at.z-R*Vdir.z+U.z*3.0+V.z*2.0,
             at.x,at.y,at.z,Up.x,Up.y,Up.z);  // If someone pressed 'v', look at the scene from the side instead of from the camera view.
   }
   else
   {
       camera(eye.x,eye.y,eye.z,at.x,at.y,at.z,Up.x,Up.y,Up.z); // If no 'v' key is pressed, look at the scene from the camera view.     
   }

   ComputeUV();
   ComputeWindowProjection();
   drawPlane();          // Draw unit grid lines in UV coordinates on the viewing plane.
    
   drawSceneUnitAxes();  // Draw the unit axes at the "at" location.
   DrawWindowProjection();      // Draw the window projected onto the viewing plane

        ProcessUserInput();    // Do not call before ComputeWindowProjection!

   if(DRAWSCENE)drawScene(); 

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
  
  PULeft=new PVector(at.x+U.x*W*scale+V.x*H*scale,
                     at.y+U.y*W*scale+V.y*H*scale,
                     at.z+U.z*W*scale+V.z*H*scale);
  
  PURight=new PVector(at.x-U.x*W*scale+V.x*H*scale,
                      at.y-U.y*W*scale+V.y*H*scale,
                      at.z-U.z*W*scale+V.z*H*scale);

  PLLeft=new PVector(at.x+U.x*W*scale-V.x*H*scale,
                     at.y+U.y*W*scale-V.y*H*scale,
                     at.z+U.z*W*scale-V.z*H*scale);
  
  PLRight=new PVector(at.x-U.x*W*scale-V.x*H*scale,
                      at.y-U.y*W*scale-V.y*H*scale,
                      at.z-U.z*W*scale-V.z*H*scale);
  
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
 //  directionalLight(255, 102, 126, 0, -1, 0);
  // directionalLight(51, 102, 255, 1, 0 , 0);
      directionalLight(200, 102, 255, 0, 0 , -1);
         directionalLight(204, 200, 204, 0, 0 , 1);
   noStroke();
   
   Points.draw();
   trianglelist.draw();
}

void drawSceneUnitAxes()
{
   stroke(255,0,0);
   line(at.x-1,     at.y-0,   at.z-0, at.x+1, at.y+0, at.z+0);
   line(at.x+1-0.25,at.y+0.25,at.z,   at.x+1, at.y+0, at.z+0);
   line(at.x+1-0.25,at.y-0.25,at.z,   at.x+1, at.y+0, at.z+0);
   stroke(0,255,0);
   line(at.x-0,   at.y-1,     at.z-0, at.x+0, at.y+1, at.z+0);
   line(at.x-0.25,at.y+1-0.25,at.z,   at.x+0, at.y+1, at.z+0);
   line(at.x+0.25,at.y+1-0.25,at.z,   at.x+0, at.y+1, at.z+0);
   stroke(0,0,255);
   line(at.x-0, at.y-0,    at.z-1,      at.x+0, at.y+0, at.z+1);
   line(at.x+0, at.y-0.25, at.z+1-0.25, at.x+0, at.y+0, at.z+1);
   line(at.x+0, at.y+0.25, at.z+1-0.25, at.x+0, at.y+0, at.z+1);
   fill(0,0,0);
   textSize(10);
   pushMatrix();
      translate(at.x+1.0,at.y-0.15,at.z+0.0);
      scale(0.03,-0.03,0.03);
      text("X",0.0,0.0,0.0);
   popMatrix();
   pushMatrix();
      translate(at.x-0.13,at.y+1.0,at.z+0.0);

      scale(0.03,-0.03,0.03);
      text("Y",0,0,0.0);
   popMatrix();
   pushMatrix();
      translate(at.x+0,at.y-0.15,at.z+1.0);
      rotate(PI/2,0.0,-1.0,0.0);
      scale(0.03,-0.03,0.03);
      text("Z",0.0,0.0,0.0);
   popMatrix();

}

// Draw a sphere at the eye location and a magenta line from the eye to the viewpoint "at".
void drawEye()
{
   noStroke();
   fill(64,64,255);
   pushMatrix();
      translate(eye.x,eye.y,eye.z);
      sphere(0.25);
   popMatrix();
  
  stroke(255,0,255);
  line(eye.x,eye.y,eye.z,at.x,at.y,at.z);
  strokeWeight(1);
  stroke(128,0,128,64);
  line(at.x-Vdir.x*50.0, at.y-Vdir.y*50.0, at.z-Vdir.z*50.0, 
       at.x+Vdir.x*50.0, at.y+Vdir.y*50.0, at.z+Vdir.z*50.0);
}

// Compute ine unit UV coordinates of the viewing plane.
//
void ComputeUV()
{
  PVector v1;
  PVector v2;
  
  v1=new PVector(eye.x-at.x,eye.y-at.y,eye.z-at.z);
  v1.normalize();
  v2=new PVector(Up.x, Up.y, Up.z);
  v2.normalize();
  U=v1.cross(v2);
  U.normalize();

  v1=new PVector(eye.x-at.x,eye.y-at.y,eye.z-at.z);
  v1.normalize();
  V=v1.cross(U);
  V.normalize();

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
     Top=new PVector(at.x,at.y,at.z);
     Top.add(PV);
     Top.add(PU);
     Bottom= new PVector(at.x,at.y,at.z);
     Bottom.sub(PV);
     Bottom.add(PU);
     line(Top.x,Top.y,Top.z,Bottom.x,Bottom.y,Bottom.z);
  }
  
  PU=new PVector(U.x,U.y,U.z);
  PU.mult((int)W+1);
  for(i=-( (int)H+1);i<=(int)H+1;i++)
  {
     PV=new PVector(V.x*i,V.y*i,V.z*i);
     Top=new PVector(at.x,at.y,at.z);
     Top.add(PV);
     Top.add(PU);
     Bottom= new PVector(at.x,at.y,at.z);
     Bottom.add(PV);
     Bottom.sub(PU);
     line(Top.x,Top.y,Top.z,Bottom.x,Bottom.y,Bottom.z);
  }
}

