
boolean solveQuadratic(float a, float b, float c, float x0, float x1) 
{ 
   float t;
   float discr = b * b - 4 * a * c; 
   if (discr < 0) 
      return false; 
   else if (discr == 0) 
      x0 = x1 = - 0.5 * b / a; 
   else 
   { 
      float q = (b > 0) ? -0.5 * (b + sqrt(discr)) : -0.5 * (b - sqrt(discr)); 
      x0 = q / a; 
      x1 = c / q; 
   } 
   
   if (x0 > x1) 
   {
     t=x0;
     x0=x1;
     x1=t;
   } 
   return true; 
}

float intersect( PVector rayorig, PVector raydir, 
                 PVector center,float radius2) 
{
   float t0, t1; // solutions for t if the ray intersects 
   
   PVector L = new PVector(center.x,center.y,center.z);
   L.sub(rayorig); 
   float tca = L.dot(raydir); 
   
   if (tca < 0) 
      return 0.0; 
      
   float d2 = L.dot(L) - tca * tca;
   
   if (d2 > radius2) 
      return 0.0; 
      
   float thc = sqrt(radius2 - d2); 
   t0 = tca - thc; 
   t1 = tca + thc; 

   float a = raydir.dot(raydir); 
   float b = 2 * raydir.dot(L); 
   float c = L.dot(L) - radius2; 
   
   if (!solveQuadratic(a, b, c, t0, t1)) 
      return 0.0; 

/*
   if (t0 > ray.tmax) 
      return 0.0; 
*/
   return t0; 
}
