class   vertexlist
{
  ArrayList pointlist;
  
  vertexlist()
  { 
     pointlist = new ArrayList();  // Create an empty ArrayList
  }
  
  int nElements()
  {
    return pointlist.size();
  }
  
  void add(float x, float y, float z)
  {
    println( "Adding point at "+x+" "+y+" "+z);
    PVector q = new PVector(x,y,z);
    pointlist.add(q);
    println("Completed adding point, now listing!");
    this.list();
  }
  
  void list()
  {
      int i;
      int n;
      println("In Point list");
      n=pointlist.size();
      println(n+" points in list!");
  }
  
  void delete( PVector p)
  {
     int i;
     for(i=0;i<pointlist.size();i++)
     {
       PVector q = (PVector) pointlist.get(i);
       if( q==p) pointlist.remove(i);
     }
  }
  
  void draw()
  {
     int i;
     int p;
     p=FindIntersection();
     for(i=0;i<pointlist.size();i++)
     {
       PVector q= (PVector) pointlist.get(i);
       pushMatrix();
       fill(128,64,64);
       if(selections.find(i))
          if( i == p)
             fill(250,250,64);
          else
             fill(200,200,200);
       else if (i == p)
       {
         fill(128,128,200);
       }

       translate(q.x,q.y,q.z);
       sphere(SPHERERADIUS);
       popMatrix();
     }
  }
  
  int FindIntersection()
  {
      float t;
      int selected;
      float tselected;
      int i;
      
      selected=-1;
      tselected=0;
      for(i=0;i<pointlist.size();i++)
      {
         PVector q=(PVector) pointlist.get(i);
         PVector ray=new PVector(mouseUV.x,mouseUV.y,mouseUV.z);
         ray.sub(eye);
         t=intersect(eye,ray,q,SPHERERADIUS2);
         
         if( t>0 && selected<0)  // this is the first ray interscetion found.
         {
           selected = i;
           tselected=t;
         }
         else   if( t < tselected && t > 0)
         {
           tselected=t;
           selected=i;
         }
      }  
     // println("Found "+selected);
      return selected;
  }

  void deleteSelected()
  {
      int i;
      selections.sortReverse();
      println("Deleting selections!");
      for(i=pointlist.size()-1;i>=0;i--)
      {
          if( selections.find(i))
             pointlist.remove(i);
      }
      selections.clear();
  }
}