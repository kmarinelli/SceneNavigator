class   SelectionList
{
  IntList selectionlist;
  
  SelectionList()
  { 
     selectionlist = new IntList();  // Create an empty ArrayList
  }

//  Add a new  selection to the list.
//  If the selection already exists in the list, remove it from the list.
  void add(int i)
  {
    if( i < 0) return;
    if( selectionlist.hasValue(i) == false)
    {
       println( "Selection is not listed! Adding selection "+i);
       selectionlist.append(i);
       println("Completed adding point, now listing!");

     }
    else
    {
      println("removing Selection!");
      delete(i);
    }
    list();
  }
  
  boolean find(int i)
  {
     return selectionlist.hasValue(i);
  }
  void list()
  {
     int i;
     for(i=0;i<selectionlist.size();i++)
     {
       println("Selection element "+i+" = "+selectionlist.get(i));
     }
     println("Listing complete!");
  }

  void sortReverse()
  {
    selectionlist.sortReverse();
  }
  
// Delete selection s from the list.
  void delete( int s)
  {
     int i;
     int q;

     for(i=0;i<selectionlist.size();i++)
     {
       q = selectionlist.get(i);
       if( q==s) 
       {
           selectionlist.remove(i);
           if( selectionlist.size()==0) 
           {
              selected=-1;
              return;
           }
       }
     }
  }
  
   void clear()
   {
      selectionlist.clear();
      selected=-1;
   }  
}
