
/******
Hotkeys
'1' - Start/Stop
'2' - Lightning Strike : toggles the flocking behavior on/off
'3' - Color Gradient : toggle the color gradient. If you like a color press 3 again to stay that color!
'4' - Drum Beat : scatters the flock, has them come back after around 5 seconds
'5' Line formation - toggle the birds traveling in a line together
*******/

//sound imports
import ddf.minim.*;

//creates the sound players
Minim minim1;
Minim minim2;
Minim minim3;
Minim minim4;
AudioPlayer crows;
AudioPlayer music;
AudioPlayer drum;
AudioPlayer thunder;

// This number will be used to keep the drum active for a few seconds, then have flocking behavior return to normal
float drum_time;
boolean drumPressed=false;

//creates the image objects for the backgrounds.
PImage islands;
PImage delta;
PImage desert;
PImage ice;
PImage mountains;
PImage startscreen;
ArrayList<PImage> backgrounds = new ArrayList<PImage>();

//this will control which background is selected
Integer image_int=0;

// creates buttons
ButtonRect mute;
boolean rectPressed = false;

/*motion_values is a list of integers that keeps track of which key is pressed and since it is associated with the flock, the flock 'knows' 
which key is toggled. 
*/
ArrayList<Integer> motion_values = new ArrayList<Integer>();
Radio[] radioButtons = new Radio[5];

int start_button = 0;
ArrayList<Bird> flocklist = new ArrayList<Bird>();

//this controls the size of the flock. Be careful with large numbers of birds! 
Flock flock = new Flock(50,flocklist,motion_values);

//Initializes an experimental hawk
Vector a = new Vector (1,1);
Vector b = new Vector (0,0);
Hawk hawk = new Hawk(a,b,flock.flocklist,a);

void setup()

  {
    drum_time=millis();
    //loads in the background images, and adds them to backgrounds list
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
    
    for (int i =0; i <6; i++)
      {
        motion_values.add(i,0);
      }
    
    // use the settings function if size doesnt work here
    size(1000,1000);
    background(150);
    
    mute = new ButtonRect(850, 900, 80, 60, color(110), color(200));

    //loads in the sounds
    minim1 = new Minim(this);
    // use crows.wav if you have the improved soundfile, crows.mp3 if you have the smaller one
    crows = minim1.loadFile("crows.wav");
    minim2 = new Minim(this); 
    music = minim2.loadFile("musicloop.mp3");
    music.play();
    minim3 = new Minim(this);
    drum = minim3.loadFile("bassdrum.wav");
    minim4 = new Minim(this);
    thunder = minim4.loadFile("thunder.mp3");
    

    // creates the buttons for the background menu 
    for (int i = 0; i < radioButtons.length; i++) 
    {
    int x = 300 + i*100;
    radioButtons[i] = new Radio(x, 950, 20, color(#E413F0), color(0), i, radioButtons);
    }
    
  }

void draw()
  {      
    
    //sets the background based on which radio button is pressed
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
    if (drumPressed)
    {
      if ((millis()-drum_time) > 5000)
        {
          drumPressed=false;
          flock.motion_values.set(3,0);
        }  
    }
    
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
        rect(0, 0, width, height);
      }
      else
      {
        flock.motion_values.set(1, 0);
        thunder.pause();
        thunder.rewind();
      }
    }
    
  //this key causes the birds to change pseudorandomly according to a color gradient  
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
      if (flock.motion_values.get(3) == 1)
        {
          flock.motion_values.set(3,0);  
        }
      else
        {
          flock.motion_values.set(3,1);
          drumPressed=true;
          drum_time=millis();
          drum.play();
          drum.rewind();
        }
    }
  
  // this key will cause the flock to form a line   
  if (key == '5')
    {
      if (flock.motion_values.get(4) == 0)
      {
        flock.motion_values.set(4, 1);
    //    wat.play();
      }
      else
      {       
    //    wat.pause();
    //    wat.rewind();
        flock.motion_values.set(4, 0);      
      }
    }  

}  