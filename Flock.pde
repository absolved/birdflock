// A flock object is a list of bird objects with two methods, moveFlock, which moves the birds according to several rules defined in the bird class,
// and boundFlock, which attempts to keep birds on the screen smoothly
// This class is structured so that motion_values is a set of integers controlling which behaviors are controlling the movement of the flock 
class Flock
  {
    int size;
    ArrayList<Bird> flocklist;
    ArrayList<Integer> motion_values;
    
    Flock() 
      {
        int size = 0;
        ArrayList<Bird> flocklist = new ArrayList<Bird>();
        ArrayList<Integer> motion_values = new ArrayList <Integer>();
      }
      
    Flock(int _size, ArrayList<Bird> _flocklist, ArrayList<Integer> _motion_values)
    
      {
        size = _size;
        flocklist = _flocklist;
        motion_values = _motion_values;
        
        
        // initializes the flock
        ArrayList<Integer> color_vector= new ArrayList<Integer>();
          color_vector.add(245);
          color_vector.add(245);
          color_vector.add(245);
        for (int i=0; i<size; i++) 
          {
            Vector vel = new Vector(random(-.1,.1),random(-.1,.1));
            Vector pos = new Vector(random(500),random(500));
            Vector accel = new Vector(0,0);
            float mass = 1;            
            flocklist.add(new Bird(pos,vel,accel,mass,color_vector));
            
            
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
          
          // this sounds stops the flocking behavior hotkey is '2'
          if (motion_values.get(1) != 1)
            {
              v1 = bird.center(bird,flocklist);
              if (motion_values.get(3) == 1)
                {
                  v1 = v1.scalarmult(-1000,v1);
                }  
              v2 = bird.collide(bird,flocklist);
              v3 = bird.align(bird,flocklist);
              v4 = bird.destination(bird,destiny);
            }
          // rules for whatever. makes the birds change along a color gradient hotkey is '3'
          if (motion_values.get(2) == 1)
            {
              
              float floatshift=random(3);
              int shift=int(floatshift);
              int multiplier = 1;
              
              float color_sum = bird.color_vector.get(0)+bird.color_vector.get(1)+bird.color_vector.get(2);
              if (color_sum <= 382)
                {
                  bird.color_vector.set(shift,bird.color_vector.get(shift)+1);  
                }
              else
                {
                  bird.color_vector.set(shift,bird.color_vector.get(shift)-1);  
                }  
             
            }
          // rules for drum; causes a scattering effect
          if (motion_values.get(3) == 1 && motion_values.get(1) == 1)
            {
              v1 = bird.center(bird,flocklist);
              v1 = v1.scalarmult(-1000,v1);   
            }
        //  else if (motion_values.get(1) == 1 
        
          // rules for whatever
          if (motion_values.get(2) == 1)
            {
              
            }
          // rules for bass drop
          if (motion_values.get(3) == 1)
            {
              
            }  
            
            
            
            
          totalcorrection = totalcorrection.addition(v1,v2);
          totalcorrection = totalcorrection.addition(totalcorrection,v3);
          totalcorrection = totalcorrection.addition(totalcorrection,v4);
          
      
          // this factor smooths out the movement
          
          totalcorrection = totalcorrection.scalarmult(.0002,totalcorrection);
          //bird.accel = bird.accel.addition(bird.accel,totalcorrection);
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