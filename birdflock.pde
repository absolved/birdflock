// all of the imports needed for sounds
import ddf.minim.*;

Minim minim1;
Minim minim2;
Minim minim3;
Minim minim4;
AudioPlayer crows;
AudioPlayer music;
AudioPlayer drum;
AudioPlayer thunder;
PImage islands;
PImage delta;
PImage desert;
PImage ice;
PImage mountains;
PImage startscreen;
ArrayList<PImage> backgrounds = new ArrayList<PImage>();

Integer image_int=0;

// creates buttons
ButtonRect mute;
boolean rectPressed = false;
ArrayList<Integer> motion_values = new ArrayList<Integer>();
Radio[] radioButtons = new Radio[5];

int start_button = 0;
Vector a = new Vector (1,1);
Vector b = new Vector (0,0);
ArrayList<Bird> flocklist = new ArrayList<Bird>();
Flock flock = new Flock(20,flocklist,motion_values);
Hawk hawk = new Hawk(a,b,flock.flocklist,a);
void setup()

  {
  //  startscreen = loadImage("archipelago.jpg");
    islands = loadImage("archipelago.jpg");
    delta = loadImage("delta.jpg");
    desert = loadImage("desert.jpg");
    ice = loadImage("ice.jpg");
    mountains = loadImage("mountains.jpg");
    startscreen = loadImage("titlescreen.jpg");
    backgrounds.add(0,startscreen);
    backgrounds.add(1,islands);
    backgrounds.add(2,delta);
    backgrounds.add(3,desert);
    backgrounds.add(4,ice);
    backgrounds.add(5,mountains);
    for (int i =0; i <5; i++)
    {
      motion_values.add(i,0);
    }
    
    // use the settings function if size doesnt work here
    size(1000,1000);
    background(150);
    
    mute = new ButtonRect(850, 900, 80, 60, color(110), color(200));

    minim1 = new Minim(this); 
    crows = minim1.loadFile("crows.mp3");
    minim2 = new Minim(this); 
    music = minim2.loadFile("musicloop.mp3");
    music.play();
    minim3 = new Minim(this);
    drum = minim3.loadFile("bassdrum.wav");
    minim4 = new Minim(this);
    thunder = minim4.loadFile("thunder.mp3");
    

    
    for (int i = 0; i < radioButtons.length; i++) 
    {
    int x = 300 + i*100;
    radioButtons[i] = new Radio(x, 950, 20, color(#E413F0), color(0), i, radioButtons);
    }
  }

void draw()
  {
    
    background(backgrounds.get(image_int));
    fill(#E413F0);
    textSize(16);
    text("Island            Delta           Desert            Ice          Mountains", 275, 900);
    for (Radio r : radioButtons) 
      {
        r.display();
      }
    if(start_button == 0)
    {
      
    for(int i =0; i <5; i++)
      {
      if(radioButtons[i].isChecked == true)
        {
          start_button = 1;
        }
      }
    }
    else
      {
        for(int i =0; i <5; i++)
      {
      if(radioButtons[i].isChecked == true)
        {
          image_int = i+1;
        }     
      }  
     
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
            
              if (crows.position() == crows.length() )
                {
                  crows.rewind();
                  crows.play();
                }
              else
                {
                  crows.play();
                }
                  
            }
            
            if (music.position() == music.length() )
            {
              music.rewind();
              music.play();
            }
          
        }
    }
    mute.update(mouseX, mouseY);
    mute.display();
    fill(#B70D0D);
    textSize(25);
    text("Mute", 855, 885);
    fill(255);
  }
  
void mousePressed() 
{
  if (mute.isPressed()) 
  {
    rectPressed = !rectPressed;
    if (rectPressed)
    {
      crows.mute();
      music.mute();
      drum.mute();
      thunder.mute();
    }
    else
    {
      crows.unmute();
      music.unmute();
      drum.unmute();
      thunder.unmute();
    }
  }
  for (Radio r : radioButtons) 
  {
    r.isPressed(mouseX, mouseY);
  }
}

void mouseReleased() 
{
  mute.isReleased();
}

void keyReleased()
{
  //this key starts/stops the animation
  if (key == '1')
    {
      if (flock.motion_values.get(0) == 0)
      {
        flock.motion_values.set(0, 1);
        music.pause();
      }
      else
      {
        music.play();
        crows.pause();
        crows.rewind();
        flock.motion_values.set(0, 0);      
      }
    }
  //this key toggles the flocking behavior on and off  
  if (key == '2')
    {
      if (flock.motion_values.get(1) == 0)
      {
        flock.motion_values.set(1, 1);
        thunder.play();
        fill(#E3FFFD);
        rect(0, 0, 1000, 1000);
      }
      else
      {
        flock.motion_values.set(1, 0);
        thunder.pause();
        thunder.rewind();
      }
    }
    
  //this key causes them to change pseudorandomly according to a color gradient  
  if (key == '3')
    {
      if (flock.motion_values.get(2) == 0)
      {
        flock.motion_values.set(2, 1);
      }
      else
      {
        //crows.pause();
        //crows.rewind();
        flock.motion_values.set(2, 0); 
      }
    }
    
    
  if (key == '4')
    {
      if (flock.motion_values.get(3) == 0)
      {
        flock.motion_values.set(3, 1);
        drum.play();
        drum.rewind();
      }
      else
      {
        flock.motion_values.set(3, 0); 
      }
    }
}  