
class Triangle
{
  PVector p1;
  PVector p2;
  PVector p3;
  
   Triangle(PVector v1, PVector v2, PVector v3)
  {
      p1 = new PVector(v1.x, v1.y, v1.z);
      p2 = new PVector(v2.x, v2.y, v2.z);
      p3 = new PVector(v3.x, v3.y, v3.z);
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
    println( p1.x+" "+p1.y+" "+p1.z);
    println( p2.x+" "+p2.y+" "+p2.z);
    println( p3.x+" "+p3.y+" "+p3.z);
    println();
  }
}

class TriangleList
{
  ArrayList trianglelist;
  
  TriangleList()
  { 
     trianglelist = new ArrayList();  // Create an empty ArrayList
  }

  void add(PVector v1, PVector v2, PVector v3)
  {
    Triangle T= new Triangle(v1, v2, v3);
    trianglelist.add(T);
    println("Completed adding triangle, now listing!");
    list();
  }
  
  void list()
  {
    Triangle T;
    
    int i;
    for(i=0;i<trianglelist.size();i++)
    {
      T=(Triangle) trianglelist.get(i);
      T.print();
    }
  }
  void draw()
  {
     int i;
     for(i=0;i<trianglelist.size();i++)
     {
       Triangle T= (Triangle) trianglelist.get(i);
       T.draw();
     }
  }
}
