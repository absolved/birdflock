import ddf.minim.*;

import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer player;

boolean moving = false;
boolean button1 = false;
ButtonRect rect;
boolean rectPressed = false;
Vector a = new Vector (1,1);
Vector b = new Vector (0,0);
ArrayList<Bird> flocklist = new ArrayList<Bird>();
Flock flock = new Flock(50,flocklist);
Hawk hawk = new Hawk(a,b,flock.flocklist,a);
void setup()

  {
    // use the settings function if size doesnt work here
    size(1000,1000);
    background(150);
    
    rect = new ButtonRect(300, 100, 80, 60, color(110), color(200));

  minim = new Minim(this); 
  player = minim.loadFile("piano.mp3");
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
          //println(bird.pos.x);        
        }
      if (moving == true)
      {
        //hawk.display();
        //hawk.chaseCenter();
        //hawk.chaseTarget();
        //hawk.scatterFlock();
        flock.moveFlock(); 
        flock.boundFlock();    
        //hawk.eatBirds();
        //hawk.chaseBirds();
        //hawk.boundHawk();
        
        if ( player.position() == player.length() )
        {
          player.rewind();
          player.play();
        }
        else
        {
          player.play();
        }
      }
    }  
    rect.update(mouseX, mouseY);
    rect.display();
    
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
  if (key == 'q')
    {
      if (button1 == false)
      {
        button1 = true;
        moving = true;
      }
      else
      {
        player.pause();
        player.rewind();
        button1 = false;
        moving = false;        
      }
    }

}