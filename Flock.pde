// A flock object is a list of bird objects with two methods, moveFlock, which moves the birds according to several rules defined in the bird class,
// and boundFlock, which attempts to keep birds on the screen smoothly
class Flock
  {
    int size;
    ArrayList<Bird> flocklist; 
    
    Flock() 
      {
        int size = 0;
        ArrayList<Bird> flocklist = new ArrayList<Bird>();
      }
      
    Flock(int _size, ArrayList<Bird> _flocklist)
    
      {
        size = _size;
        flocklist = _flocklist;
        
        // initializes the flock
        for (int i=0; i<size; i++) 
          {
            Vector vel = new Vector(random(-.1,.1),random(-.1,.1));
            Vector pos = new Vector(random(500),random(500));
            float mass = 1;
            int bird_color=255;
            flocklist.add(new Bird(pos,vel,mass,bird_color));
            
            
          }  
          
          
      
      } 
   
    void moveFlock() 
    
      {
        //this vector will be a random point on the canvas that the birds attempt to move to at each time step
        
        float x=random(0,2*3.1415);
        Vector destiny = new Vector (500*cos(x)+500,500*sin(x)+500);        
        for (Bird bird : flocklist)
        
        {
          Vector v1 = new Vector(0,0);
          Vector v2 = new Vector(0,0);
          Vector v3 = new Vector(0,0);
          Vector v4 = new Vector(0,0);
          Vector totalcorrection = new Vector(0,0);          
          v1 = bird.center(bird,flocklist);
          v2 = bird.collide(bird,flocklist);
          v3 = bird.align(bird,flocklist);
          v4 = bird.destination(bird,destiny);          
          totalcorrection = totalcorrection.addition(v1,v2);
          totalcorrection = totalcorrection.addition(totalcorrection,v3);
          totalcorrection = totalcorrection.addition(totalcorrection,v4);
          // this factor smooths out the movement 
          totalcorrection = totalcorrection.scalarmult(.0002,totalcorrection);
          bird.vel = bird.vel.addition(bird.vel,totalcorrection);
          bird.limitvel();
          bird.pos = bird.pos.addition(bird.pos,bird.vel);
        
        }  
      }  
    void boundFlock()
      {
        int xmax = 1000;
        int xmin = 0;
        int ymax = 1000;
        int ymin = 0;
        for (Bird bird: flocklist)
          {
            Vector bound = new Vector(0,0);
            if (bird.pos.x > xmax)
              {
                bound.x = -.05;    
              }
            else if (bird.pos.x < xmin)
              {
                bound.x = .05;  
              }
            if (bird.pos.y > ymax)
              {
                bound.y = -.05;  
              }
            else if (bird.pos.y < ymax)
              {
                bound.y = .05;  
              }
          bird.vel = bird.vel.addition(bird.vel,bound);    
          }  
      }  
      
      
  }  