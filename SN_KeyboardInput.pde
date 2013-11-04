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
                 eyeX = eyeX+V.x*0.1;
                 eyeY = eyeY+V.y*0.1;
                 eyeZ = eyeZ+V.z*0.1;
                 atX  = atX +V.x*0.1;
                 atY  = atY +V.y*0.1;
                 atZ  = atZ +V.z*0.1;
                 break;
              case DOWN: // pan viewing frustrum down
                 eyeX = eyeX-V.x*0.1;
                 eyeY = eyeY-V.y*0.1;
                 eyeZ = eyeZ-V.z*0.1;
                 atX  = atX -V.x*0.1;
                 atY  = atY -V.y*0.1;
                 atZ  = atZ -V.z*0.1;
                 break;
              case LEFT:  // pan viewing frustrum left.
                 eyeX = eyeX-U.x*0.1;
                 eyeY = eyeY-U.y*0.1;
                 eyeZ = eyeZ-U.z*0.1;
                 atX  = atX -U.x*0.1;
                 atY  = atY -U.y*0.1;
                 atZ  = atZ -U.z*0.1;
                 break;
              case RIGHT: // pan viewing frustrum right.
                 eyeX = eyeX+U.x*0.1;
                 eyeY = eyeY+U.y*0.1;
                 eyeZ = eyeZ+U.z*0.1;
                 atX  = atX +U.x*0.1;
                 atY  = atY +U.y*0.1;
                 atZ  = atZ +U.z*0.1;
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
           eyeX =eyeX+dx*0.1;
           eyeY =eyeY+dy*0.1;
           eyeZ =eyeZ+dz*0.1;
           atX  =atX+dx*0.1;
           atY  =atY+dy*0.1;
           atZ  =atZ+dz*0.1;
     }
     if(key== 's') // move viewing frustrum backwards.
     {
           eyeX =eyeX-dx*0.1;
           eyeY =eyeY-dy*0.1;
           eyeZ =eyeZ-dz*0.1;
           atX  =atX-dx*0.1;
           atY  =atY-dy*0.1;
           atZ  =atZ-dz*0.1;
     }
   }
}

// Handle key released events.
void keyReleased() 
{
      switch(key)
      {
         case 'D':  // toggle scene drawing.
            DRAWSCENE= !DRAWSCENE;
            break;
         case 'v':  // toggle offset view from the eye.
            DRAWEYEMODE= !DRAWEYEMODE;
            break;
      }
}


