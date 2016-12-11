// A flock object is a list of bird objects with two methods, moveFlock, which moves the birds according to several rules defined in the bird class,
// and boundFlock, which attempts to keep birds on the screen smoothly
// This class is structured so that motion_values is a set of integers controlling which behaviors are controlling the movement of the flock 
class Flock
  {
    int size;
    ArrayList<Bird> flocklist;
    ArrayList<Integer> motion_values;
    ArrayList<Vector> destinations;
    
    Flock() 
      {
        int size = 0;
        ArrayList<Bird> flocklist = new ArrayList<Bird>();
        ArrayList<Integer> motion_values = new ArrayList <Integer>();
        ArrayList<Vector> destinations = new ArrayList <Vector>();
      }
      
    Flock(int _size, ArrayList<Bird> _flocklist, ArrayList<Integer> _motion_values,ArrayList<Vector> _destinations)
    
      {
        size = _size;
        flocklist = _flocklist;
        motion_values = _motion_values;
        destinations = _destinations;  
        
        // initializes the flock
        ArrayList<Integer> color_vector= new ArrayList<Integer>();
          color_vector.add(255);
          color_vector.add(255);
          color_vector.add(255);
        for (int i=0; i<size; i++) 
          {
            Vector vel = new Vector(random(-.1,.1),random(-.1,.1));
            Vector pos = new Vector(random(1000),random(1000));
            Vector accel = new Vector(0,0);
            float mass = 1;            
            flocklist.add(new Bird(pos,vel,accel,mass,color_vector));
            destinations.add(pos);
            
          }  
          
          
      
      } 
      
    Vector getFlockCenter()
      {
        float size = flocklist.size();
        Vector center = new Vector(0,0);
        for (Bird bird : flocklist)
          {
            if ( bird.mass !=0)
              {
                center=center.addition(center, bird.pos);
              }
          }  
        center=center.scalarmult(1/size,center);
        return center;
      }
    
    //changes the destination of the flock, they will attempt to go to points along the boundary
    void changeDestinations()
      {
        
        for (Vector dest : destinations)
          {            
            float x=random(2*3.1415);          
            dest.x=500*cos(x)+500;
            dest.y=500*sin(x)+500;
            if(motion_values.get(5) == 1)  
            
              {
                float temp = int(random(4));            
                if (temp == 0)
                  {
                    dest.x=0;
                    dest.y=random(1000);
                  }
                else if (temp == 1)
                  {
                    dest.x=random(1000);
                    dest.y=0;
                  }
                else if (temp == 2)
                  {
                    dest.x=1000;
                    dest.y=random(1000);
                  }
                else
                  {
                    dest.x=random(1000);
                    dest.y=1000;
                  }                           
              }
           }              
      }  
        
    
    void moveFlock() 
    
      {        
        int flock_time = second();
        
        if (motion_values.get(5) != 1)
          {
            changeDestinations();
          }
        else if (flock_time % 2 == 0)
          {
            changeDestinations();  
          }  
        int bird_counter = 0;
        
        for (Bird bird : flocklist)
        
        {                      
          //v1 is the displacement for the center convergence 
          Vector v1 = new Vector(0,0);
          //v2 is the displacement for the collision detection
          Vector v2 = new Vector(0,0);
          //v3 is the displacement for the alignment convergence
          Vector v3 = new Vector(0,0);
          //v4 is the displacement for the convergence to a point about the circle of radius 500 centered at 500,500.
          Vector v4 = new Vector(0,0);
          //v5 is the vector for the line formation motion
          Vector v5 = new Vector(0,0);
          //v6 is the vector for non convergent flocking motion
          Vector v6 = new Vector(0,0);
          //this will be the sum of all rule displacement vectors 
          Vector totalcorrection = new Vector(0,0);
          
          // this sounds starts the storm behavior. right now it is set up to take priority over all behavior
          if (motion_values.get(1) != 1 && motion_values.get(5) != 1)
            {
              
              // if it is the first bird in the list, and line behavior is on, converge towards destiny about a circle
              if ( bird == flocklist.get(0) && motion_values.get(4) == 1)
                    {
                      v4 = bird.destination(bird,destinations.get(bird_counter));
                      v4 = v4.scalarmult(1000,v4);
                    }
              if (motion_values.get(4) != 1)
                {
                  v1 = bird.center(bird,flocklist);
                  v2 = bird.collide(bird,flocklist);
                  v3 = bird.align(bird,flocklist);
                  v4 = bird.destination(bird,destinations.get(bird_counter));
                  if (motion_values.get(3) == 1)
                    {
                      v1 = v1.scalarmult(-1000,v1);
                    }
                }
              else if (motion_values.get(4) == 1 && bird != flocklist.get(0))
                {
                  v5 = (v5.subtraction(flocklist.get(bird_counter-1).pos,bird.pos));
                  // adjust this multiplier to change how 'tight' the birdsnake is 
                  v5 = v5.scalarmult(100,v5);
                  
                  if (motion_values.get(3) == 1)
                    {
                      v1 = bird.center(bird,flocklist);
                      v1 = v1.scalarmult(-1000,v1);
                    }
                }  
                
   
            }
            
          // heavy winds 
          if (motion_values.get(1) == 1)
            {
            
              int coinflip= int(random(0,2));
              float destmult=0;
              if (coinflip == 0)
                {
                  destmult = 10;
                }
              else
                {
                  destmult=-10;  
                }  
              v4=v4.addition(v4,bird.vel.subtraction(bird.vel,getFlockCenter()));
              v4 = v4.scalarmult(destmult,v4);
              if (motion_values.get(3) == 1)
                {
                  v1 = bird.center(bird,flocklist);
                  v1 = v1.scalarmult(-500,v1);   
                }
            } 
          //makes the birds change along a color gradient hotkey is '3'
          if (motion_values.get(2) == 1)
            {                           
              int shift=int(random(3));              
              float direction_mult=random(0,2);
                           
                
              float color_sum = bird.color_vector.get(0)+bird.color_vector.get(1)+bird.color_vector.get(2);
              if (color_sum <= 5)
                {
                  bird.color_vector.set(shift,bird.color_vector.get(shift)+1);  
                }
              else
                {
                  if (color_sum >= 760)
                    {
                      bird.color_vector.set(shift,bird.color_vector.get(shift)-1);
                    }
                  else
                    {
                      if (direction_mult == 0)
                        {
                          bird.color_vector.set(shift,bird.color_vector.get(shift)-1);  
                        }
                      else
                        {
                          bird.color_vector.set(shift,bird.color_vector.get(shift)+1);  
                        }  
                      
                    }  
             
                }
            }
          
          //rules for frenzied behavior
          if (motion_values.get(5) == 1)  
            {                           
              v6 = bird.destination(bird,destinations.get(bird_counter));
              v6 = v6.scalarmult(10,v6);
              
            }  
          
        
        
  
     
            
            
            
            
          totalcorrection = totalcorrection.addition(v1,v2);
          totalcorrection = totalcorrection.addition(totalcorrection,v3);
          totalcorrection = totalcorrection.addition(totalcorrection,v4);
          totalcorrection = totalcorrection.addition(totalcorrection,v5);
          totalcorrection = totalcorrection.addition(totalcorrection,v6);
       
          // this factor smooths out the movement          
          totalcorrection = totalcorrection.scalarmult(.0002,totalcorrection);
         // bird.accel = bird.accel.addition(bird.accel,totalcorrection);
          bird.vel = bird.vel.addition(bird.vel,totalcorrection);
          bird.limitvel();
             
            
          bird.pos = bird.pos.addition(bird.pos,bird.vel);
          bird_counter += 1; 
        }  
      }  
      
    // this function is used to keep the birds within the screen  
    void boundFlock()
      {
        
        int xmax = width;
        int xmin = 0;
        int ymax = height;
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
            else if (bird.pos.y < ymin)
              {
                bound.y = .05;  
              }
          bird.vel = bird.vel.addition(bird.vel,bound);    
          }  
      }  
      
      
  }  