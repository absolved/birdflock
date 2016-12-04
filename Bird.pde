// Bird objects have positions and velocities, and every time step the position is updated with the formula pos=pos+vel, where vel is changing according to several rules.
// Birds will be composed of two "pieces" a circle, and a triangle. The circles move relative to the other birds and the triangles move relative to the circles within each individual bird.
class Bird
  {
    //These refer to the position and velocity of the circle
    Vector pos = new Vector(0,0);
    Vector vel = new Vector(0,0);  
    float mass = 0.0;
    // this is the birds greyscale color
    int bird_color = 255;
    // vector representing a moving point in a random spot on the canvas which the birds will disperse from if the center of mass is too close to this point
    Vector screen_center = new Vector(random(0,500),random(0,500));
    Bird(Vector _pos,Vector _vel, float _mass,int bird_color)
      {
        pos = _pos;
        vel = _vel;
        mass = _mass; 
      }
    
    // this creates a displacement vector, which will be added to each birds velocity vector in order to move it towards the perceived center of the flock   
    Vector center(Bird bird, ArrayList <Bird> flocklist) 
      {
        float flocknum=flocklist.size()-1;
        //this controls the convergence towards the center and adds a random degree of convergence for each bird 
        float convergence = random(10,15);
        Vector center_correct = new Vector(0,0);
        for (Bird boid : flocklist)
          {
            if (boid != bird && boid.mass != 0)
              {
                center_correct=center_correct.addition(center_correct,boid.pos);                
              }  
          }
        center_correct=center_correct.scalarmult(1/flocknum,center_correct);
        if (center_correct.distance(center_correct, screen_center) < 150) 
          {
            convergence=convergence*-10;
          }  
        center_correct=center_correct.subtraction(center_correct,bird.pos);
        // This next statement causes the correction factor to be a movement towards or away from the perceived center 
        center_correct=center_correct.scalarmult(convergence,center_correct);
        return center_correct;
      } 
    
    // this creates a displacement vector which will be added to each birds velocity vector in order to simulate collision detection for each bird
    Vector collide(Bird bird, ArrayList <Bird> flocklist)
    
      {
        // this controls the degree of collision detection, and adds a random element for each bird
        float collision_mult=random(500,1000);
        Vector collide_correct = new Vector(0,0);
        for (Bird boid: flocklist)
          {
            Vector bird_dist = new Vector(0,0);
            if (boid != bird && boid.mass != 0)
              {
                if (boid.pos.distance(boid.pos,bird.pos) < 25 )
                  {
                    bird_dist = bird_dist.subtraction(boid.pos,bird.pos);
                    collide_correct = collide_correct.subtraction(collide_correct,bird_dist);  
                  }  
              }  
          }  
        return collide_correct.scalarmult(collision_mult,collide_correct);
      }
    
    // this creates a displacement vector which will be added to each birds velocity vector in order to align their direction of movement  
    Vector align(Bird bird, ArrayList <Bird> flocklist)
    
      {
        Vector align_correct = new Vector(0,0);
        float flocknum = flocklist.size()-1;
        for (Bird boid : flocklist) 
          {
            if (boid != bird && boid.mass !=0)
              {
                align_correct=align_correct.addition(align_correct,boid.vel);  
              }  
          }  
        align_correct=align_correct.scalarmult(1/flocknum,align_correct);
        align_correct=align_correct.subtraction(align_correct,bird.vel);
        // this controls the degree of flock alignment
        align_correct=align_correct.scalarmult(500,align_correct);
        return align_correct;
      }
      
    Vector destination(Bird bird, Vector destiny)
      {
        Vector dest_correct = bird.pos.subtraction(destiny,bird.pos);
        //this controls the flocks tendency towards a random point 
        return dest_correct.scalarmult(10,dest_correct);
      }
      
    //The following Vectors will be used to build the triangles, which will move relative to the circles  
    Vector tri_head()
      {
        //this amounts to solving some quadratic equations
        float m = (vel.y- pos.y)/(vel.x-pos.x);        
        float a = 1 + (m*m);      
        float b = -2*pos.x*(1+m*m);         
        float c = (pos.x*pos.x)*a-100;        
        float tri_x = (-b + sqrt((b*b)-4*a*c))/(2*a);
        float tri_y = m*(tri_x-pos.x)+pos.y;
        return new Vector (tri_x,tri_y); 
      }
    // This involves doing more geometry and more quadratic equations tri is the triangle head from which the feet will be calculated    
    Vector tri_foot1(Vector tri)
    
      {
        float A= 2*(tri.x-pos.x);
        float B= 2*(tri.y-pos.y);
        float C= pos.x*pos.x+pos.y*pos.y-tri.x*tri.x-tri.y*tri.y+100;
        float a = 1+((B*B)/(A*A));
        float b = 2*C*B/(A*A)+2*pos.x*B/A-2*pos.y;
        float c = pos.x*pos.x+pos.y*pos.y+2*pos.x*C/A+((C*C)/(A*A))-100;
        float foot_y = (-b+sqrt(b*b-4*a*c))/(2*a);
        float foot_x = -C/A-(B/A)*foot_y;
        return new Vector (foot_x,foot_y);
      }
    Vector tri_foot2(Vector tri)
      {
        float A= 2*(tri.x-pos.x);
        float B= 2*(tri.y-pos.y);
        float C= pos.x*pos.x+pos.y*pos.y-tri.x*tri.x-tri.y*tri.y+100;
        float a = 1+((B*B)/(A*A));
        float b = 2*C*B/(A*A)+2*pos.x*B/A-2*pos.y;
        float c = pos.x*pos.x+pos.y*pos.y+2*pos.x*C/A+((C*C)/(A*A))-100;
        float foot_y = (-b-sqrt(b*b-4*a*c))/(2*a);
        float foot_x = -C/A-(B/A)*foot_y;
        return new Vector (foot_x,foot_y); 
      }
      
    
    void limitvel()
      {
        float limit = 5;
        float norm = sqrt(pow(this.vel.x,2)+pow(this.vel.y,2)); 
        if (norm > limit)
          {
            this.vel = this.vel.scalarmult(limit/norm,this.vel);  
          }  
      }  
    void display()
      {
        if (mass != 0)
          {
            fill(bird_color);
           // ellipse(pos.x,pos.y,20,20);
            Vector triheadvect = this.tri_head();          
            Vector trifoot1vect = this.tri_foot1(triheadvect);
            Vector trifoot2vect = this.tri_foot2(triheadvect);
            println(triheadvect.distance(triheadvect,trifoot2vect));
            fill(0);
            triangle(triheadvect.x,triheadvect.y,trifoot1vect.x,trifoot1vect.y,trifoot2vect.x,trifoot2vect.y);
            stroke(#DB0F0F);                  
            stroke(0);
            
          }
      
      }  
    

  } 
  