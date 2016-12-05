// all of the imports needed for sounds
// 'q' functions as a pause button
import ddf.minim.*;

import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer player;

// creates buttons
ButtonRect rect;
boolean rectPressed = false;
ArrayList<Integer> motion_values = new ArrayList<Integer>();



Vector a = new Vector (1,1);
Vector b = new Vector (0,0);
ArrayList<Bird> flocklist = new ArrayList<Bird>();
Flock flock = new Flock(20,flocklist,motion_values);
Hawk hawk = new Hawk(a,b,flock.flocklist,a);
void setup()

  {
    for (int i =0; i <5; i++)
    {
      motion_values.add(i,0);
    }
    
    // use the settings function if size doesnt work here
    size(1000,1000);
    background(150);
    
    rect = new ButtonRect(300, 100, 80, 60, color(110), color(200));

    minim = new Minim(this); 
    player = minim.loadFile("crows");
    println(player.length());
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
                    
          }
        //hawk.display();
        //hawk.chaseCenter();
        //hawk.chaseTarget();
        //hawk.scatterFlock();
        
        if (flock.motion_values.get(0) == 1)
          {
            flock.moveFlock();  
            flock.boundFlock();
            
          //hawk.eatBirds();
          //hawk.chaseBirds();
          //hawk.boundHawk();
          
            if (player.position() == player.length() )
              {
                player.rewind();
                player.play();
              }
            else
              {
                player.play();
              }
          }
          
    /*    if(flock.motion_values.get(1) == 1)
          {
          
          } */
        
      }
    rect.update(mouseX, mouseY);
   // rect.display(); 
  }
  
void mousePressed() 
{
  if (rect.isPressed()) 
  {
   rectPressed = !rectPressed;
  }
}

void mouseReleased() 
{
  rect.isReleased();
}

void keyReleased()
{
  if (key == '1')
    {
      if (flock.motion_values.get(0) == 0)
      {
        flock.motion_values.set(0, 1);
      }
      else
      {
        player.pause();
        player.rewind();
        flock.motion_values.set(0, 0);      
      }
    }
  if (key == '2')
    {
      if (flock.motion_values.get(1) == 0)
      {
        flock.motion_values.set(1, 1);
      }
      else
      {
        //player.pause();
        //player.rewind();
        flock.motion_values.set(1, 0); 
      }
    }
}  