class Hawk
  {
    Vector pos = new Vector(0,0);
    Vector vel = new Vector(0,0);
    ArrayList<Bird> flocklist = new ArrayList<Bird>();  
    // this is the hawks target 
    Vector target = new Vector(0,0);
    Hawk(Vector _pos, Vector _vel, ArrayList<Bird> _flocklist,Vector _target)
      {
        pos=_pos;
        vel=_vel;
        flocklist=_flocklist;
        target = _target;
      }
    void chaseTarget()
      {
        target = getFlockCenter();
        for (Bird bird : flocklist)
          {
            if (pos.distance(bird.pos,pos)< 75)
              {
                target = bird.pos;
                break;
              }
            else
              {
                target = getFlockCenter();  
              }  
          }
        Vector displacement = target;
        displacement=displacement.subtraction(target,pos);
        displacement=displacement.scalarmult(.0001,displacement);
        vel=vel.addition(vel,displacement);
        limitvel();
        pos=pos.addition(pos,vel);
      }  
      
    // this chases the whole flock  
    void chaseCenter() 
      {     
        float size = flocklist.size();
        Vector displacement = getFlockCenter();      
        displacement=displacement.subtraction(displacement,pos);         
        displacement=displacement.scalarmult(.0001,displacement);
        displacement=displacement.scalarmult(10*pos.distance(displacement,pos)/size,displacement);
        vel = vel.addition(vel,displacement);
        limitvel();
        pos = pos.addition(pos,vel);
      }
    void limitvel()
      {
        float limit = 35;
        float norm = sqrt(pow(vel.x,2)+pow(vel.y,2)); 
        if (norm > limit)
          {
            vel = vel.scalarmult(limit/norm,vel);  
          }  
      }   
    // this chases individual birds
    void chaseBirds()
      {
        //float size = flocklist.size();
        Vector displacement = new Vector(0,0);
        //displacement = displacement.scalarmult(1/size,displacement); 
        for (Bird bird : flocklist)
          {
            float bird_dist = pos.distance(pos,bird.pos);
            Vector temp_vect = new Vector (bird.pos.x,bird.pos.y);
            if (bird_dist != 0)
              {
                    temp_vect = temp_vect.scalarmult(2.5/pow(bird_dist,2),temp_vect);
                    displacement = displacement.addition(displacement,temp_vect);
                    
              }  
              
          }
        //displacement=displacement.scalarmult(.001,displacement);
        vel=vel.addition(vel,displacement);
        limitvel();
        pos=pos.addition(pos,vel);  
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
    void scatterFlock()
      {
        if (pos.distance(pos, getFlockCenter()) < 200)
          {
            for (Bird bird: flocklist)               
              {
                if (bird.pos.distance(bird.pos,pos) < 300)
                  {
                    Vector scatter = new Vector(0,0);
                    scatter = bird.pos.subtraction(bird.pos,pos);
                    scatter = scatter.scalarmult(5000,scatter);
                    bird.vel = bird.vel.addition(bird.vel,scatter);  
                  }  
              }  
            
          }  
      }
      
    void boundHawk()
      {
        int xmax = 1000;
        int xmin = 0;
        int ymax = 1000;
        int ymin = 0;
        Vector bound = new Vector (0,0);
        if (pos.x > xmax)
          {
            bound.x=-.05;   
          }
        else if (pos.x < xmin)
          {
            bound.x=.05;  
          }
        if (pos.y > ymax)
          {
            bound.y=-.05;  
          }
        if (pos.y < ymin)
          {
            bound.y=.05;  
          }
        vel=vel.addition(vel,bound);
        limitvel();
      }  
        
    /* 
    void eatBirds()
        {
          for (Bird bird : flocklist)
            {
              if (pos.distance(pos,bird.pos) < 25 )
                {
                  // this crashes the program
                  flocklist.remove(bird);  
                }  
            }  
        }   
    */
    void eatBirds()
      {
        for (Bird bird : flocklist)
            {
              if (pos.distance(pos,bird.pos) < 25)
                {
                  bird.mass=0;                  
                } 
                
            }  
      }  
    
    
    void display()
      {
        fill(#F21616);
        ellipse(pos.x,pos.y,50,50);
      }  
  }  