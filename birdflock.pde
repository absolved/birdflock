Vector a = new Vector (1,1);
Vector b = new Vector (0,0);
ArrayList<Bird> flocklist = new ArrayList<Bird>();
Flock flock = new Flock(200,flocklist);
Hawk hawk = new Hawk(a,b,flock.flocklist,a);
void setup()

  {
    // use the settings function if size doesnt work here
    size(1000,1000);
    background(150);
    
  }
/* use this if size malfunctions in the setup
void settings()

  {
    size(1000,1000);  
  }  
*/  
void draw()
  {
    background(150);
    if (flock.flocklist.size() > 0)
      {
        for (Bird bird : flock.flocklist) 
          {
            bird.display();            
            //println(bird.pos.x);        
          }
        hawk.display();
        //hawk.chaseCenter();
        hawk.chaseTarget();
        hawk.scatterFlock();
        flock.moveFlock();  
        flock.boundFlock();    
        hawk.eatBirds();
       // hawk.chaseBirds();
        //hawk.boundHawk();
      }
  }  