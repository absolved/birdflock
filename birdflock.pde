
/******
Hotkeys
'1' - Start/Stop
'2' - Lightning Strike : toggles high winds on and off!
'3' - Color Gradient : toggle the color gradient. If you like a color press 3 again to stay that color!
'4' - Drum Beat : scatters the flock, has them come back after around 5 seconds
'5' - Line formation - toggle the birds traveling in a line together
'q' - 'Frenzied behavior' - still need to figure a lot out here...
*******/

//sound imports
import ddf.minim.*;

//creates the sound players
Minim minim_crows;
Minim minim_startmusic;
Minim minim_drum;
Minim minim_clap;
Minim minim_thunder;
Minim minim_thunder2;
Minim minim_highwinds;
Minim minim_desk_bell;
Minim minim_pianoscale;
Minim minim_pianodiscord;
Minim minim_whistleup;
Minim minim_whistledown;
Minim minim_deep_horn;
Minim minim_fiddle;
AudioPlayer crows;
AudioPlayer startmusic;
AudioPlayer drum;
AudioPlayer clap;
AudioPlayer thunder;
AudioPlayer thunder2;
AudioPlayer highwinds;
AudioPlayer desk_bell;
AudioPlayer pianoscale;
AudioPlayer pianodiscord;
AudioPlayer whistleup;
AudioPlayer whistledown;
AudioPlayer deep_horn;
AudioPlayer fiddle;


// This number will be used to keep the drum active for a few seconds, then have flocking behavior return to normal
float drum_time;
boolean drumPressed=false;

//creates the image objects for the backgrounds.
PImage testmap;
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
ButtonRect controls;
ButtonRect credits;
boolean rectPressed = false;
boolean controlsPressed = false;
boolean creditsPressed = false;

/*motion_values is a list of integers that keeps track of which key is pressed and since it is associated with the flock, the flock 'knows' 
which key is toggled. 
*/
ArrayList<Integer> motion_values = new ArrayList<Integer>();
// destinations will be used to control nonflocking behavior
ArrayList<Vector> destinations = new ArrayList<Vector>();
Radio[] radioButtons = new Radio[5];

int start_button = 0;
ArrayList<Bird> flocklist = new ArrayList<Bird>();

//this controls the size of the flock. Be careful with large numbers of birds! 
Flock flock = new Flock(200,flocklist,motion_values,destinations);

//Initializes an experimental hawk
Vector a = new Vector (1,1);
Vector b = new Vector (0,0);
Hawk hawk = new Hawk(a,b,flock.flocklist,a);
Vector mapcenter = new Vector(0,0);
void setup()

  {
    
    testmap = loadImage("testmap.jpg");     
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
    mute = new ButtonRect(880, 945, 20, 20, color(110), color(255));
    
    controls = new ButtonRect(100,300,200,80,color(110),color(255));
    credits = new ButtonRect(650,300,200,80,color(110),color(255));
    //loads in the sounds
    minim_crows = new Minim(this);
    // use crows.wav if you have the improved soundfile, crows.mp3 if you have the smaller one
    crows = minim_crows.loadFile("crows.mp3");
    minim_startmusic = new Minim(this); 
    startmusic = minim_startmusic.loadFile("musicloop.mp3");
    startmusic.play();
    minim_drum = new Minim(this);
    drum = minim_drum.loadFile("bassdrum.wav");
    minim_clap = new Minim(this);
    clap = minim_clap.loadFile("clap.wav");
    minim_thunder = new Minim(this);
    thunder = minim_thunder.loadFile("thunder.mp3");
    minim_thunder2 = new Minim(this);
    thunder2 = minim_thunder2.loadFile("thunder2.wav");
    minim_highwinds = new Minim(this);
    highwinds = minim_highwinds.loadFile("high_winds.mp3");
    minim_desk_bell = new Minim(this);
    desk_bell = minim_desk_bell.loadFile("desk_bell.wav");
    minim_pianoscale = new Minim(this);     
    pianoscale = minim_pianoscale.loadFile("C_pianoscale.wav");
    minim_pianodiscord = new Minim(this);
    pianodiscord = minim_pianodiscord.loadFile("piano_discord.wav");
    minim_whistleup = new Minim(this);
    whistleup = minim_whistleup.loadFile("slide_whistleup.wav");
    minim_whistledown = new Minim(this);
    whistledown= minim_whistledown.loadFile("slide_whistledown.wav");
    minim_deep_horn = new Minim(this);
    deep_horn = minim_whistledown.loadFile("deep_horn.mp3");
    minim_fiddle = new Minim(this);
    fiddle = minim_fiddle.loadFile("fiddle.mp3");

    // creates the buttons for the background menu 
    for (int i = 0; i < radioButtons.length; i++) 
    {
    int x = 300 + i*100;
    radioButtons[i] = new Radio(x, 950, 20, color(#E413F0), color(0), i, radioButtons);
    }
    
  }

void draw()
  {  
 /*  This bit of code is an experiment in trying to get the birds to move around a large map. It's very laggy though.
    Need to figure out a different way of doing the image so that I only have to load the image once.
   mapcenter = flock.getFlockCenter();
 mapcenter = mapcenter.scalarmult(-1,mapcenter);  
  pushMatrix();
  translate(mapcenter.x,mapcenter.y);
  image(testmap,0,0);    
  popMatrix();  */
    
    
    background(backgrounds.get(image_int));
    //sets the background based on which radio button is pressed
    
    fill(#E413F0);    
    textSize(16);    
    text("Island            Delta           Desert            Ice          Mountains", 275, 900);
      
    if (controlsPressed && start_button == 0)
      {
        fill(#000000);
        text("Pick a map using the mouse, then",100,430);
        text(" '1' = Start/Stop ", 100,450);
        text(" '2' = Toggle thunderstorm ", 100,470);
        text(" '3' = Toggle color shift " , 100,490);
        text(" '4' = Toggle scatter on/off ",100,510);
        text(" '5' = Toggle line formation ", 100,530);
        text(" 'q' = Toggle frenzy behavior ", 100,550);
             
      }
    if (creditsPressed && start_button == 0)
      {
        fill(#000000);
        text("Math by Alex Sabol and Bryan Socha",600,430);
        text("Start menu song by Daniel Vuong",600,450);
        text("Background images from: ", 600,470); 
        text("http://aerialwallpapers.tumblr.com",600,490);
      }  
    for (Radio r : radioButtons) 
      {
        r.display();
      }      
    if(start_button == 0)
      {
        controls.update(mouseX, mouseY);
        controls.display();
        credits.update(mouseX,mouseY);
        credits.display();
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
              
         // hawk.display();
          //hawk.chaseCenter();
         //hawk.chaseTarget();
        // hawk.scatterFlock();
          
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
            
            if (startmusic.position() == startmusic.length() )
            {
              startmusic.rewind();
              startmusic.play();
            }
          
        }
      if (motion_values.get(1) == 1)
        {
          if (highwinds.position() == highwinds.length())
          {
            highwinds.rewind();
            highwinds.play();
          }          
          if (highwinds.position() % 6100 <= 25)
            {
              fill(#E3FFFD);
              rect(0, 0, width, height);
              thunder2.play();
              thunder2.rewind();
            }  
          }  
    }
    if (start_button == 0)
      {
        textSize(25);
        fill(#B70D0D);
        text("Controls", 150,350);
        text("Credits", 700,350);
      }
    mute.update(mouseX, mouseY);
    mute.display();
    fill(#B70D0D);
    textSize(25);
    text("Mute", 860, 940);
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
      startmusic.mute();
      drum.mute();
      clap.mute();
      thunder.mute();
      desk_bell.mute();
      whistleup.mute();
      whistledown.mute();
      pianoscale.mute();
      pianodiscord.mute();
      deep_horn.mute();
      fiddle.mute();
      thunder2.mute();
    }
    else
    {
      crows.unmute();
      startmusic.unmute();
      drum.unmute();
      thunder.unmute();
      desk_bell.unmute();
      clap.unmute();
      whistleup.unmute();
      whistledown.unmute();
      pianoscale.unmute();
      pianodiscord.unmute();
      deep_horn.unmute();
      fiddle.unmute();
      thunder2.unmute();
    }
  }
  if (controls.isPressed()) 
    {
      controlsPressed = !controlsPressed;
    }
  if (credits.isPressed())
    {
      creditsPressed = !creditsPressed;  
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
        startmusic.pause();
      }
      else
      {
        startmusic.play();
        crows.pause();
        crows.rewind();
        flock.motion_values.set(0, 0);      
      }
    }
  //this key toggles a thunderstorm on and off 
  if (key == '2')
    {
      pianoscale.pause();
      pianoscale.rewind();
      if (flock.motion_values.get(1) == 0)
      {
        
        flock.motion_values.set(1, 1);
        thunder.play();
        highwinds.play();          
        desk_bell.pause();
        desk_bell.rewind();
        fill(#E3FFFD);
        rect(0, 0, width, height);        
      }
      else
      {
        highwinds.pause();
        highwinds.rewind();
        desk_bell.play();        
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
        pianoscale.play();
        pianoscale.rewind();
        flock.motion_values.set(2, 1);
      }
      else
      {
        pianoscale.pause();
        pianoscale.rewind();
        pianodiscord.play();
        pianodiscord.rewind();
        flock.motion_values.set(2, 0); 
      }
    }
    
    
  if (key == '4')
    {
      if (flock.motion_values.get(3) == 1)
        {
          flock.motion_values.set(3,0);
          clap.play();
          clap.rewind();
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
  
  // this key will cause the flock to form a line, like a snake   
  if (key == '5')
    {
      if (flock.motion_values.get(4) == 0)
      {
        flock.motion_values.set(4, 1);
        whistleup.play();
        whistledown.pause();
        whistledown.rewind();
      }
      else
      { 
        whistledown.play();
        whistleup.pause();
        whistleup.rewind();
        flock.motion_values.set(4, 0);      
      }
    }
  // this will turn on the non flocking behavior  
  if (key == 'q')
    {
      if (flock.motion_values.get(5) == 0)
      {
        flock.motion_values.set(5, 1);
        deep_horn.play();
        fiddle.pause();
        fiddle.rewind();
      }
      else
      { 
        fiddle.play();
        deep_horn.pause();
        deep_horn.rewind();
        flock.motion_values.set(5, 0);      
      }
    }  

}  