**IN ORDER TO RUN THIS:**
You will need to download processing from processing.org.
You will have to create a folder called "data" in your birdflock folder and put all the sounds into that folder. 
You will also have to install the Minim library within processing.
*************************

This program simulates flocking behavior using processing.
Press '1' to Start and stop the animation.
Press '2' to toggle the flocking behavior on and off.

There is a working hawk whos behavior is currently commented out. If you would like to mess around with the hawk, uncomment the
hawk functions within the draw loop in the birdflock file.

If you would like to mess with the flocking behavior, there are several parameters which can be edited in order to change how the flock looks
here is a short key: 
*********
In the Bird file:

line 28: convergence - this float controls the tendency towards the center, increases to tend more towards the center.
line 53: collision_mult - this float controls the birds tendency to avoid each other. Increase to make them dislike each other more..
line 86: align_correct - this controls the bird's tendency to line up their velocities. Increase this to make them more orderly.
line 94: dest_correct - controls their tendency towards a random point.
line 155: limit - this is the birds speed. Higher is faster.
********
In the birdflock file:
line 24: controls the number of birds in the flock. Be careful with too many birds it doesn't seem to work well.
line 30: controls the screen size but note that the math was done assuming a screen size of 1000x1000.




***IF IT ISN'T WORKING READ THIS***
On some computers, it gives some sort of error about "size(1000,1000)" being using in the setup function. If this happens, then 
take "size(1000,1000)" out of the setup function, and uncomment the settings function and it should work properly.
***********************************
