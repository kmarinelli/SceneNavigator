//
// User interface processing for mouse inputs.
//
//  ProcessMouseInput()  - Process all mouse events.
//  TrackMouse()         - track the mouse pointer in the UV plane.
//  mousePressed()       - Handle mouse button pressed events.
//  mouseReleased()      - Handle mouse button released events.
//
int mouseMillis=0;           // millisecond time when mouse button was pressed.
float mDownX=0, mDownY=0, mDownZ=0;  // Mouse UV coordinates when button was pressed.

void ProcessMouseInput()
{
   TrackMouse();
   if( mousePressed)
   {
   }
   
}

PVector mousePressedPoint;

void mousePressed()
{
     println("Mouse was pressed!\n");

     mousePressedPoint=Points.FindIntersection();  // If the mouse is pressed on a vertex, save the vertex pointer.

     // Save the location of the down press.
     mouseMillis = millis();
     mDownX=mouseUV.x;
     mDownY=mouseUV.y;
     mDownZ=mouseUV.z;
  
}

void mouseReleased() 
{
  println("Mouse was released!");
  if( millis()-mouseMillis<250) // mouse click happened.
  {
    if( mouseButton == LEFT )
    {
       if( mDownX==mouseUV.x && mDownY==mouseUV.y && mDownZ==mouseUV.z)
       {  println("Adding point!\n");
          Points.add(mouseUV.x,mouseUV.y,mouseUV.z);
       }
    }
    
    if( mouseButton==RIGHT)
    {
      println("Right mouse was pressed!");
      selected = Points.FindIntersection();
      println("Selection is "+selected);
      if( selected == null)
      {
             println("Clearing selections!");
             selections.clear();
      }
      else
      { 
           PVector tmp=selected;
          
           if( !keyPressed || (keyPressed&&keyCode != SHIFT))  // Clear the selection list if this is not a shift-click to append the selection to the list.
           {
              println("Clearing Selections list!");
              selections.clear();
           }
              
           println("Adding selection "+tmp+" to list");
           selected=tmp;
           selections.add(selected);
      }

    }
  }
}

void mouseDragged() 
{
   println("Mouse was dragged!");
   
   if( mousePressedPoint!=null)  // The mouse was dragged while pointing at a vertex.
   {
     mousePressedPoint.set(mouseUV.x,mouseUV.y,mouseUV.z); // Update the vertex location in the UV plane to the new mouse location.
   }
   
}

void TrackMouse()
{
//  Track the mouse pointer in UV coordinates.
  
  float x;
  float y;
  
  // Convert 2D window mouse position to 3D U,V world coordinates
  
  x=2*((float)mouseX-(float)width/2)/width*Width; 
  y= 2*(-((float)mouseY-(float)height/2))/height*Height;

  mouseUV.x=at.x-U.x*x+V.x*y;
  mouseUV.y=at.y-U.y*x+V.y*y;
  mouseUV.z=at.z-U.z*x+V.z*y;
 
   noStroke();
   lights();
   pushMatrix();
      translate(mouseUV.x,mouseUV.y,mouseUV.z);
      sphere(0.05);
   popMatrix();
}
