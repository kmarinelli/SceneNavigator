class   SelectionList
{
  VertexList elements;
  
  SelectionList()
  { 
     elements = new VertexList();  // Create an empty VertexList
  }

//  Add a new  selection to the list.
//  If the selection already exists in the list, remove it from the list.
  void add(PVector p)
  {
    if( p == null) return;
    if( !find(p,true))
    {
       println( "Selection is not listed! Adding selection "+p.x+" "+p.y+" "+p.z);
       //elements.add(p.x,p.y,p.z);
       elements.addVertex(p);
       println("Completed adding point, now listing!");

     }
    else
    {
      println("removing Selection!");
      elements.delete(p);
      if( elements.Head==null) selected=null;
    }
    list();
  }
  
  boolean find(PVector p,boolean debug)
  {
     VertexNode N;
 
     if( p == null) return false;
    
     N=elements.Head;
     if( N==null) return false;
     
     while( N !=null)
     {
       if( debug)
       {
          println("Comparing:");
          println("  "+N.P.x+" "+N.P.y+" "+N.P.z);
          println("  "+p.x+" "+p.y+" "+p.z);
       }
       if( N.equal(p)) 
       {  
          if( debug) println("Found match!");
          return true;
       }
       N=N.Next;
     }
     return false;
  }
  
  void list()
  {
     VertexNode N;
     
     println("Size = "+elements.count);
     N=elements.Head;
     while( N!=null)
     {
       N.list();
       N=N.Next;
     }
     println("Listing complete!");
  }

  
   void clear()
   {
       VertexNode N;
       VertexNode tmp;
       
       println("In SelectionList.clear()");
       if( elements==null)
       {
         println("The SelectionList is empty! elements==null");
         return;
       }
       println("Continuing: elements is not null!");
       N=elements.Head;
       while(N != null)
       {
         print("Node =");
         N.list();
         tmp=N;
         N=N.Next;
         tmp.P=null;
         tmp.Next=null;
         tmp.Prev=null;
       }
       elements.Head=null;
       elements.Tail=null;
       elements.count = 0;
   }  
   
   int size()
   { 
     println("In SelectionList.size");
     println("Size = "+elements.count);
     return elements.count;
   }
   
}
