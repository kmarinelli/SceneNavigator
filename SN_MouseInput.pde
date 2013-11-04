//
// User interface processing for mouse inputs.
//
//  ProcessMouseInput()  - Process all mouse events.
//  TrackMouse()         - track the mouse pointer in the UV plane.
//  mousePressed()       - Handle mouse button pressed events.
//  mouseReleased()      - Handle mouse button released events.
//

float mX=0.0, mY=0.0,mZ=0.0;  // Mouse projection onto UV viewing plane.

int mouseMillis=0;           // millisecond time when mouse button was pressed.
float mDownX=0, mDownY=0, mDownZ=0;  // Mouse UV coordinates when button was pressed.

void ProcessMouseInput()
{
   TrackMouse();
   if( mousePressed)
   {
   }
   
}

void mousePressed()
{
     // Save the location of the down press.
     mouseMillis = millis();
     mDownX=mX;
     mDownY=mY;
     mDownZ=mZ;
  
}
void mouseReleased() 
{
  if( millis()-mouseMillis<250) // mouse click happened.
  {
    // addVertex(mX,mY,mZ);
  }

}

void TrackMouse()
{
//  Track the mouse pointer in UV coordinates.
  
    float x;
  float y;
  
  // Convert 2D window mouse position to 3D U,V world coordinates
  
  x=2*((float)mouseX-(float)width/2)/width*W; 
  y= 2*(-((float)mouseY-(float)height/2))/height*H;

 mX=atX-uX*x+vX*y;
 mY=atY-uY*x+vY*y;
 mZ=atZ-uZ*x+vZ*y;
 
     noStroke();
        lights();
   pushMatrix();
      translate(mX,mY,mZ);
      sphere(0.05);
   popMatrix();
}
