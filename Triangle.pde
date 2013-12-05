class TriangleList
{
  TriangleNode Head;
  TriangleNode Tail;
  
  TriangleList()
  {
    Head=null;
    Tail=null;
  }
  
  void insert(TriangleNode t)
  {
    println("In Triangle.insert()");
    if( Head==null)
    {
       Head=t;
       Tail=Head;
    }
    else
    { 
      Tail.Next=t;
      t.Prev=Tail;
      Tail=t;  
    }  
    list();
  }
  
  void add(PVector p1, PVector p2, PVector p3)
  {
    Triangle T;
    TriangleNode N;
    
    println("In Triangle.add()");
 
    T = new Triangle(p1, p2, p3);
    N = new TriangleNode(T);
    insert(N);
    
  }
  
  void list()
  {
    TriangleNode N;
    Triangle T;
    
    println("In TriangleList.list()");
    N = Head;
    while( N !=null)
    {
      T= N.T;
      T.print();
      N=N.Next;
    }
  }
  
  void draw()
  {
    TriangleNode N;
    
    N=Head;
    while( N!=null)
    {
      N.T.draw();
      N=N.Next;
    }
  }
  
  void deleteTriangle(TriangleNode p)
  {
    println("In delete triangle!");

    TriangleNode N;
    TriangleNode tmp;
    
    println("In TriangleList.delete()");
    if( p == null) 
    {
      println("Nothing to do, Triangle is null");
      return;
    }
    
    N = Head;
    while( N !=null)
    {
       if( N == p)
       {
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
           println("Deletion is complete!");
           return;
       }
       N=N.Next;
    }
 }

  
  TriangleNode findTrianglewithVertex(PVector p)
  {
      TriangleNode N;
      
      println("In findTrianglewithVertex()");
      if( p == null) return null;
      N=Head;
      while(N !=null)
      {
           if( N.T.HasVertex(p)) 
           {
                println("Found vertex from selection in triangle!");
                return N;
           }
           N=N.Next;
      }
      return null;
  }


  void deleteTrianglesWithSelectedVertices()
  {
      VertexNode N;
      TriangleNode Q;
      N=selections.elements.Head;
      println("Deleting Triangle selections!");
      while( N !=null)
      {
         Q=findTrianglewithVertex(N.P);
         while ( Q!=null) 
         {
           deleteTriangle(Q);
           Q=findTrianglewithVertex(N.P);
         }
         N=N.Next;
      }
  }

}

class TriangleNode
{  
  Triangle T;
  TriangleNode Next;  // Next node in the list.
  TriangleNode Prev;  // Previous node in the list.
  
  TriangleNode(Triangle t)
  {
    T = new Triangle(t.p1,t.p2, t.p3);
  }
}

class Triangle
{
  PVector p1;
  PVector p2;
  PVector p3;
  
   Triangle(PVector v1, PVector v2, PVector v3)
  {
      p1 = v1;
      p2 = v2;
      p3 = v3;
  }
  
  boolean HasVertex(PVector q)
  {
    if( q == p1 || q == p2 || q == p3) return true;
    return false;
  }
  
  void draw()
  {
    stroke(TRIANGLELINECOLOR);
    fill(TRIANGLEFILLCOLOR);
    beginShape();
       vertex(p1.x, p1.y, p1.z);
       vertex(p2.x, p2.y, p2.z);
       vertex(p3.x, p3.y, p3.z);
    endShape(CLOSE);
  }
  
  void print()
  {
    println("Triangle");
    println( p1.x+" "+ p1.y+" "+ p1.z);
    println( p2.x+" "+ p2.y+" "+ p2.z);
    println( p3.x+" "+ p3.y+" "+ p3.z);
    println();
  }

  int ccw(PVector p1, PVector p2, PVector p3)
  {
    PVector v1,v2;
    float a,b,c;
    float d,e,f;
    float det;
    
    a=p2.x-p1.x;
    b=p2.y-p1.y;
    c=p2.z-p1.z;
 
    d=p2.z-p3.x;
    e=p2.y-p3.y;
    f=p2.z=p3.z;
 
    det= ( (b*f)-(e*c))-( (a*f)-(d*c))+( (a*e)-(d*b)); 
  
    if( det == 0) return 0;
    if( det > 0) return 1;
    return -1;  

  }
  
  boolean inside(PVector q)
  {
    int ccw1;
    int ccw2;
    int ccw3;
    
    ccw1=ccw(p1,p2,q);
    ccw2=ccw(p2,p3,q);
    ccw3=ccw(p3,p1,q);
    
    if( abs( ccw1+ccw2+ccw3)==3) return true;
    return false;
    
  }
}
