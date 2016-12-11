**IN ORDER TO RUN THIS:**
You will need java.
You will need at least 1000x1000 screen resolution.
You will need to download processing from processing.org.
You will have to create a folder called "data" in your birdflock folder and put all of the sounds into that folder. 
You will also have to install the Minim library within processing.

Application version coming soon. Making changes so frequently that I don't like uploading it constantly.
*************************

This program simulates flocking behavior using processing.
First, select an environment of choice using the radio buttons.
Press '1' to Start and stop the animation.
Press '2' to toggle a thunderstorm on and off
Press '3' to toggle the birds changing colors pseudorandomly along a gradient.
Press '4' to toggle a scattering effect that lasts for five seconds. Press again to toggle off.
Press '5' to toggle the line formation of the flock, like a train.
Press 'q' to toggle on/off frenzied motion 

-The drum('4') is a little bit buggy, but it looks pretty cool so we'll call it a feature.

Have fun and play around with different combinations of keys! 

There is a working hawk whos behavior is currently commented out. If you would like to mess around with the hawk, uncomment the
hawk functions within the draw loop in the birdflock file.

If you would like to mess with the flocking behavior, there are several parameters which can be edited in order to change how the flock looks
here is a short key: 
************************************
In the Bird file: (These line numbers may need to be edited)

convergence - this float controls the tendency towards the center, increases to tend more towards the center.
collision_mult - this float controls the birds tendency to avoid each other. Increase to make them dislike each other more..
align_correct - this controls the bird's tendency to line up their velocities. Increase this to make them more orderly.
dest_correct - controls their tendency towards a random point.
limit - this is the birds speed. Higher is faster.
***********************************
In the birdflock file:
Flock flock = new Flock(i,flocklist,motion_values); i controls the number of birds in the flock. Don't get crazy.





***IF IT ISN'T WORKING READ THIS***
On some computers, it gives some sort of error about "size(1000,1000)" being using in the setup function. If this happens, then 
take "size(1000,1000)" out of the setup function, and uncomment the settings function and it should work properly.
***********************************

Acknowledgements and Citations:

*******Image Sources***************
Background images taken from www.aerialwallpapers.tumblr.com
***********************************
**Sound Sources********************
Crow soundfile taken from alfdroid@freesound.org. http://freesound.org/people/alfdroid/sounds/265264/
***********************************
Thanks to Bryan Socha for mathing it up with me.
Shout out to Daniel DJ MOOSEBUMP Vuong for the intro/pause song! 
(Some) of the math is explained in the PDFs. May add more if I get bored.
