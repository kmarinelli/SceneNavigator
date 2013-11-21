class   SelectionList
{
  IntList listelements;
  
  SelectionList()
  { 
     this.listelements = new IntList();  // Create an empty ArrayList
  }

//  Add a new  selection to the list.
//  If the selection already exists in the list, remove it from the list.
  void add(int i)
  {
    if( i < 0) return;
    if( this.listelements.hasValue(i) == false)
    {
       println( "Selection is not listed! Adding selection "+i);
       this.listelements.append(i);
       println("Completed adding point, now listing!");

     }
    else
    {
      println("removing Selection!");
      this.delete(i);
      if( this.listelements.size()==0) selected=-1;
    }
    this.list();
  }
  
  boolean find(int i)
  {
     if( this.listelements.size()==0) return false;
     return this.listelements.hasValue(i);
  }
  
  void list()
  {
     int i;
     for(i=0;i<this.listelements.size();i++)
     {
       println("Selection element "+i+" = "+this.listelements.get(i));
     }
     println("Listing complete!");
  }

  void sortReverse()
  {
    if( this.listelements.size()> 0)
       this.listelements.sortReverse();
  }
  
// Delete selection s from the list.
  void delete( int s)
  {
     int i;
     int q;

     for(i=0;i<this.listelements.size();i++)
     {
       q = this.listelements.get(i);
       if( q==s) 
       {
           this.listelements.remove(i);
           if( this.listelements.size()==0) 
           {
              selected=-1;
              return;
           }
       }
     }
  }
  
   void clear()
   {
      if( this.listelements.size()>0)
         this.listelements.clear();
      selected=-1;
   }  
   
   int size()
   {
     if( this.listelements.size() > 0)
        return this.listelements.size();
     return 0;
   }
   
   int get(int i)
   {
     if( i>=0 && i < this.listelements.size())
        return this.listelements.get(i);
     return -1;
   }
}
