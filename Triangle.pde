
class Triangle
{
  PVector p1;
  PVector p2;
  PVector p3;
  
   Triangle(PVector v1, PVector v2, PVector v3)
  {
      this.p1 = new PVector(v1.x, v1.y, v1.z);
      this.p2 = new PVector(v2.x, v2.y, v2.z);
      this.p3 = new PVector(v3.x, v3.y, v3.z);
  }
  
  void draw()
  {
    stroke(TRIANGLELINECOLOR);
    fill(TRIANGLEFILLCOLOR);
    beginShape();
       vertex(this.p1.x, this.p1.y, this.p1.z);
       vertex(this.p2.x, this.p2.y, this.p2.z);
       vertex(this.p3.x, this.p3.y, this.p3.z);
    endShape(CLOSE);
  }
  
  void print()
  {
    println("Triangle");
    println( this.p1.x+" "+this.p1.y+" "+this.p1.z);
    println( this.p2.x+" "+this.p2.y+" "+this.p2.z);
    println( this.p3.x+" "+this.p3.y+" "+this.p3.z);
    println();
  }
}

class TriangleList
{
  ArrayList trianglelist;
  
  TriangleList()
  { 
     this.trianglelist = new ArrayList();  // Create an empty ArrayList
  }

  void add(PVector v1, PVector v2, PVector v3)
  {
    Triangle T= new Triangle(v1, v2, v3);
    this.trianglelist.add(T);
    println("Completed adding triangle, now listing!");
    this.list();
  }
  
  void list()
  {
    Triangle T;
    
    int i;
    for(i=0;i<this.trianglelist.size();i++)
    {
      T=(Triangle) this.trianglelist.get(i);
      T.print();
    }
  }
  void draw()
  {
     int i;
     for(i=0;i<this.trianglelist.size();i++)
     {
       Triangle T= (Triangle) this.trianglelist.get(i);
       T.draw();
     }
  }
}
