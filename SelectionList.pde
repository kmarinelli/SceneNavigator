class   SelectionList
{
  IntList listelements;
  
  SelectionList()
  { 
     listelements = new IntList();  // Create an empty ArrayList
  }

//  Add a new  selection to the list.
//  If the selection already exists in the list, remove it from the list.
  void add(int i)
  {
    if( i < 0) return;
    if( listelements.hasValue(i) == false)
    {
       println( "Selection is not listed! Adding selection "+i);
       listelements.append(i);
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
     return listelements.hasValue(i);
  }
  void list()
  {
     int i;
     for(i=0;i<listelements.size();i++)
     {
       println("Selection element "+i+" = "+listelements.get(i));
     }
     println("Listing complete!");
  }

  void sortReverse()
  {
    listelements.sortReverse();
  }
  
// Delete selection s from the list.
  void delete( int s)
  {
     int i;
     int q;

     for(i=0;i<listelements.size();i++)
     {
       q = listelements.get(i);
       if( q==s) 
       {
           listelements.remove(i);
           if( listelements.size()==0) 
           {
              selected=-1;
              return;
           }
       }
     }
  }
  
   void clear()
   {
      listelements.clear();
      selected=-1;
   }  
   
   int size()
   {
     return listelements.size();
   }
   
   int get(int i)
   {
     return listelements.get(i);
   }
}
