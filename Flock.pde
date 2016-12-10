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
          color_vector.add(255);
          color_vector.add(255);
          color_vector.add(255);
        for (int i=0; i<size; i++) 
          {
            Vector vel = new Vector(random(-.1,.1),random(-.1,.1));
            Vector pos = new Vector(random(500),random(500));
            Vector accel = new Vector(0,0);
            float mass = 1;            
            flocklist.add(new Bird(pos,vel,accel,mass,color_vector));
            
            
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
    
    void moveFlock() 
    
      {
        //this vector will be a random point on the canvas that the birds attempt to move to at each time step
        
        
     // float x = millis();
        
        int bird_counter = 0;
        for (Bird bird : flocklist)
        
        {
          float x=random(0,2*3.1415);          
          Vector destiny = new Vector (500*cos(x)+500,500*sin(x)+500);            
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
          Vector totalcorrection = new Vector(0,0);
          
          // this sounds stops the flocking behavior hotkey is '2'
          if (motion_values.get(1) != 1)
            {
              
              if ( bird == flocklist.get(0) && motion_values.get(4) == 1)
                    {
                      v4 = bird.destination(bird,destiny);
                      v4 = v4.scalarmult(1000,v4);
                    }
              if (motion_values.get(4) != 1)
                {
                  v1 = bird.center(bird,flocklist);
                  v2 = bird.collide(bird,flocklist);
                  v3 = bird.align(bird,flocklist);
                  v4 = bird.destination(bird,destiny);
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
          // non-flocking behavior; still need to figure out how to get the triangles to work in this case..  
          if (motion_values.get(1) == 1)
            {
            //  v4 = bird.destination(bird,destiny);
              int coinflip= int(random(0,2));
              float destmult=0;
              if (coinflip == 0)
                {
                  destmult = .1;
                }
              else
                {
                  destmult=-.1;  
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
          // rules for drum; toggle a scatter effect on and off
          
        
        
  
       /*    rules for bass drop
          if (motion_values.get(3) == 1)
            {
              
            }  */
            
            
            
            
          totalcorrection = totalcorrection.addition(v1,v2);
          totalcorrection = totalcorrection.addition(totalcorrection,v3);
          totalcorrection = totalcorrection.addition(totalcorrection,v4);
          totalcorrection = totalcorrection.addition(totalcorrection,v5);
       
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