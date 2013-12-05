class VertexList
{
  VertexNode Head;
  VertexNode Tail;
  int count;
  
  VertexList()
  {
     count = 0;
  }
  
  void insert(VertexNode p)
  {
    println("In VertexList.insert()");
    if( Head==null)
    {
       println("Head is null!");
       Head=p;
       Tail=Head;
    } 
    else
    {
       Tail.Next=p;
       p.Prev=Tail;
       Tail=p; 
    }   
    list();
    count++;
  }
  
  void addVertex(PVector p)
  {  
     VertexNode N;
  
     N=new VertexNode(p);
     insert(N);
  }
  void add(float x, float y, float z)
  {
    PVector P;
    VertexNode N;
    
    println("In VertexList.add()");
    P = new PVector(x, y, z);
    N = new VertexNode(P);
    insert(N);
    
  }
  
  void list()
  {
    VertexNode N;
    PVector P;
    
    N = Head;
    while( N !=null)
    {
      P=(PVector) N.P;
      println(P.x+" "+P.y+" "+P.z);
      N=N.Next;
    }
  }
  
  // Find the ball with the smallest positive distance from the eye that the mouse is pointing at.
  PVector FindIntersection()
  {
      float t;
      PVector selected;
      float tselected;
      int i;
      
      VertexNode N;
      
      N=Head;
      
      selected=null;
      tselected=0;
      while( N!=null)
      {
         PVector q=N.P;
         PVector ray=new PVector(mouseUV.x,mouseUV.y,mouseUV.z);
         ray.sub(eye);
         t=BallRayIntersect(eye,ray,q,SPHERERADIUS2);
         
         if( t>0 && selected==null)  // this is the first ray interscetion found.
         {
           selected = q;
           tselected=t;
         }
         else   if( t < tselected && t > 0)
         {
           tselected=t;
           selected=q;
         }
         N=N.Next;
      }  
      return selected;
  }

  void draw()
  {
     PVector p;
     VertexNode N;
     
     p=FindIntersection();

     shininess(8.0);
     lightSpecular(255, 255, 255);
     specular(255, 0, 255);

     N=Head;
     
     while(N != null)
     {
      PVector q= N.P;
      pushMatrix();
      fill(128,64,64);  // Default node color.
      if(selections.find(q,false)) // Node is in selection list
          if( p !=null&&p==q) // Mouse is pointing at node
             fill(200,200,64); // Draw node in yellow
          else
             fill(200,200,200); //  draw node in off-white
       else if (p==q) // Node is not in delection listm but mouse is pointing at node
       {
         fill(128,128,200); // Draw node in blue.
       }

       translate(q.x,q.y,q.z);
       sphere(SPHERERADIUS);
       popMatrix();
       N=N.Next;
     }
  }
 
  
  void delete(PVector p)
  {
    VertexNode N;
    VertexNode tmp;
    
    println("In VertexList.delete()");
    if( p == null) 
    {
      println("Nothing to do, PVector is null");
      return;
    }
    
    N = Head;
    
    count--;
    while(N!=null)
    {
      if( N.equal( p) )
      {
        println("Nodes are equal!");
        if( N == Head)
        {
           println("Deleting Head node!");
           tmp = Head;
           Head.Prev=null;
           Head=Head.Next;

        }
        else if( N == Tail)
        {
           println("Deleting Tail node");
           Tail=N.Prev;
           if( N.Prev!=null)
           {
             N.Prev.Next=null;
           }
        }
        else
        {
          println("Deleting intermediate node");
          tmp=N;
          N.Next.Prev=N.Prev;
          N.Prev.Next=N.Next;
        }  
        println("Deletion is complete! Looking for additional nodes");
        //N.Next=null;
        //N.Prev=null;
        //N.P=null;
      }
      N=N.Next;
    }
  }
  
  void deleteSelectedVertices()
  {
      VertexNode N;
      N=selections.elements.Head;
      println("Deleting selections!");
      while( N !=null)
      {
        if( find(N.P))
             delete(N.P);
         N=N.Next;
      }
  }
  
  boolean find(PVector p)
  {
      VertexNode N;
      
      N=Head;
      while(N !=null)
      {
           if( N.equal(p)) return true;
           N=N.Next;
      }
      return false;
  }
}

class VertexNode
{  
  PVector P;
  VertexNode Next;  // Next node in the list.
  VertexNode Prev;  // Previous node in the list.
  
  
  VertexNode(PVector p)
  {
    P = p;
  }
  
  void list()
  {
    println(P.x+" "+P.y+" "+P.z);
  }
  
  boolean equal( PVector q)
  {
    
    if( q == null) return false;                           // Can't be equal to nothing!
    if( P == q) return true;                               // Pointers are equal; therefore, values must be equal.
    if( P.x == q.x && P.y == q.y && P.z==q.z) return true; // Values are equal.
    return false;
  }

}
