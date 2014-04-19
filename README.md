Red Fish, Blue Fish
======

Bryan Rainey
raineyb@purdue.edu

A fish simulator. Models the populations of two species of fish in a pond 
over time.


Getting and running the program:
------

Navigate to github.com/brainey421/redfishbluefish, and click "Download 
ZIP." Unzip "redfishbluefish-master.zip." In MATLAB, change the 
Current Folder to "redfishbluefish-master." In MATLAB's Command Window, 
type "redfishbluefish."


How the program works:
------

The left half of the window is a 50-by-50 grid that models a pond of red 
fish and blue fish. Each cell in the grid either is empty, contains one red 
fish, or contains one blue fish. At discrete time steps, each fish can 
move around, collide with other fish, and reproduce. The grid loops around 
so that a fish can move from one side of the grid to the other in one step. 
(Imagine that the grid is the surface of a sphere.)

Enter the initial populations of red fish and blue fish. P(reproduce) 
is the probability that a fish reproduces at each time step. P(die by 
collision w/ same color) is the probability that a fish will die if it 
collides with a fish of the same color. P(die by collision w/ other color) 
is the probability that a fish will die if it collides with a fish of 
the other color.

"Run" starts the simulation, and "Stop" ends the simulation. The number of 
each color of fish is always in the bottom right-hand corner. If the grid 
has a lot of fish, the program tends to run slowly.

Start with simple combinations of parameters. (I would recommend trying 
10 fish of each color and 0 for every probability.) Let me know if you try 
some combination of parameters and the results are nonsensical.

This is similar to Conway's Game of Life (Wikipedia has a nice article on 
this), except here, there are random elements, so this is called a 
stochastic cellular automaton.
