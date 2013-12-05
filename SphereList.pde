class SphereList
{
  SphereNode Head;
  SphereNode Tail;
  
  SphereList()
  {
    Head=null;
    Tail=null;
  }
  
  void insert(SphereNode s)
  {
    println("In Sphere.insert()");
    if( Head==null)
    {
       Head=s;
       Tail=Head;
    }
    else
    { 
      Tail.Next=s;
      s.Prev=Tail;
      Tail=s;  
    }  
    list();
  }
  
  void add(PVector p1, PVector p2, PVector p3, PVector p4)
  {
    Sphere S;
    SphereNode N;
    
    println("In Sphere.add()");
 
    S = new Sphere(p1, p2, p3, p4);
    N = new SphereNode(S);
    insert(N);
    
  }
  
  void list()
  {
    SphereNode N;
    Sphere S;
    
    println("In SphereList.list()");
    N = Head;
    while( N !=null)
    {
      S= N.S;
      S.print();
      N=N.Next;
    }
  }
  
  void draw()
  {
    SphereNode N;
    
    N=Head;
    while( N!=null)
    {
      N.S.draw();
      N=N.Next;
    }
  }
}

class SphereNode
{  
  Sphere S;
  SphereNode Next;  // Next node in the list.
  SphereNode Prev;  // Previous node in the list.
  
  SphereNode(Sphere s)
  {
    S = new Sphere(s.p1,s.p2, s.p3, s.p4);
    Next=null;
    Prev=null;
  }
}

class Sphere
{
  PVector p1;
  PVector p2;
  PVector p3;
  PVector p4;
  PVector center;
  PVector radius;
  
   Sphere(PVector v1, PVector v2, PVector v3, PVector v4)
  {
      p1 = new PVector(v1.x, v1.y, v1.z);
      p2 = new PVector(v2.x, v2.y, v2.z);
      p3 = new PVector(v3.x, v3.y, v3.z);
      p4 = new PVector(v4.x, v4.y, v4.z);
  }
  
  void draw()
  {
    stroke(TRIANGLELINECOLOR);
    fill(TRIANGLEFILLCOLOR);
    beginShape();
       vertex(p1.x, p1.y, p1.z);
       vertex(p2.x, p2.y, p2.z);
       vertex(p3.x, p3.y, p3.z);
       vertex(p4.x, p4.y, p4.z);
    endShape(CLOSE);
  }
  
  void print()
  {
    println("Sphere");
    println( p1.x+" "+ p1.y+" "+ p1.z);
    println( p2.x+" "+ p2.y+" "+ p2.z);
    println( p3.x+" "+ p3.y+" "+ p3.z);
    println( p4.x+" "+ p4.y+" "+ p4.z);
    println();
  }
}
