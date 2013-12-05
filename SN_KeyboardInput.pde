// User interface processing for keyboard commands
//
//  ProcessKeyInput()  - Handle all keyboard events
//  keyreleased()      - Handle key released evects.

void ProcessKeyInput()
{
   // Programming Note! 
   // JavaScript cannot handle 'key' being in a switch for the value CODED.
   // CODED has the value 65535, which seems to break the switch comparison. 
   // A switch statement does work properly in JAVA mode!   
   if (keyPressed)   // Handle key pressed events (key is held down).
   {
     //println("Key = "+key+" "+CODED);
     if( key== CODED)   // Special key events such as shift key, arrow keys, return, etc.
     {
           //println("Key code = "+keyCode);
           switch(keyCode)  
           {
              case UP:  // pan viewing frustrum up.
                 eye.x = eye.x+V.x*0.1;
                 eye.y = eye.y+V.y*0.1;
                 eye.z = eye.z+V.z*0.1;
                 at.x  = at.x +V.x*0.1;
                 at.y  = at.y +V.y*0.1;
                 at.x  = at.z +V.z*0.1;
                 break;
              case DOWN: // pan viewing frustrum down
                 eye.x = eye.x-V.x*0.1;
                 eye.y = eye.y-V.y*0.1;
                 eye.z = eye.z-V.z*0.1;
                 at.x  = at.x -V.x*0.1;
                 at.y  = at.y -V.y*0.1;
                 at.z  = at.z -V.z*0.1;
                 break;
              case LEFT:  // pan viewing frustrum left.
                 eye.x = eye.x-U.x*0.1;
                 eye.y = eye.y-U.y*0.1;
                 eye.z = eye.z-U.z*0.1;
                 at.x  = at.x -U.x*0.1;
                 at.y  = at.y -U.y*0.1;
                 at.z  = at.z -U.z*0.1;
                 break;
              case RIGHT: // pan viewing frustrum right.
                 eye.x = eye.x+U.x*0.1;
                 eye.y = eye.y+U.y*0.1;
                 eye.z = eye.z+U.z*0.1;
                 at.x  = at.x +U.x*0.1;
                 at.y  = at.y +U.y*0.1;
                 at.z  = at.z +U.z*0.1;
                 break;
              }
     }
     if( key== 'd')  // rotate eye right.
     {
        rotateEye=1.0;
     }
     if( key== 'a') // rotate eye left.
     {
           rotateEye= -1.0;
     }
     if( key=='w')  // move viewing frustrum forward.
     {
           eye.x =  eye.x+W.x*0.1;
           eye.y =  eye.y+W.y*0.1;
           eye.z =  eye.z+W.z*0.1;
           at.x  =  at.x +W.x*0.1;
           at.y  =  at.y +W.y*0.1;
           at.z  =  at.z +W.z*0.1;
     }
     if(key== 's') // move viewing frustrum backwards.
     {
           eye.x =  eye.x-W.x*0.1;
           eye.y =  eye.y-W.y*0.1;
           eye.z =  eye.z-W.z*0.1;
           at.x  =  at.x -W.x*0.1;
           at.y  =  at.y -W.y*0.1;
           at.z  =  at.z -W.z*0.1;
     }
     if( key == DELETE)
     {
        println("Deleting selected points!");
        trianglelist.deleteTrianglesWithSelectedVertices();
        Points.deleteSelectedVertices();
        selections.clear();
     }

   }
}

// Handle key released events.
void keyReleased() 
{
      switch(key)
      {
         case 'v':  // toggle offset view from the eye.
            DRAWEYEMODE= !DRAWEYEMODE;
            break;
         case 't':
           println("Creating a triangle!");
           if(selections.size()==3)
           {
             PVector p1,p2,p3;
             Triangle T;
             
             println("3 vertices selected: Adding triangle!");
             p1= (selections.elements.Head).P;
             p2 = selections.elements.Head.Next.P;
             p3 = selections.elements.Head.Next.Next.P;
             trianglelist.add(p1,p2,p3);       
           }
           break;
      }
}


