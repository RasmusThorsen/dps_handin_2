/**
* Name: vegetationcell
* Based on the internal empty template. 
* Author: ralle
* Tags: 
*/


model vegetationcell

/* Insert your model definition here */

// neighbors => 4: Von Neumann, 6: hexagon, 8: Moore
// Facets are like operators. The '<-' is the initial value facet, while 'update' facet updates at each sim step
grid vegetation_cell width: 50 height: 50 neighbors: 4 {
    float max_food <- 1.0; // Maximum food a given cell can contain
    float food_prod <- rnd(0.01); // food produced at each simulation step 
    // Current amount of food - updated using the update-facet. Update is ran in each sim step.
    float food <- rnd(1.0) update: food + food_prod max: max_food;
    // The greener the more food in that cell. the format is rgb(r, g, b), 0-255.
    rgb color <- rgb(int(255 * (1 - food)), 255, int(255 * (1 - food))) 
         update: rgb(int(255 * (1 - food)), 255, int(255 * (1 - food)));
    
    // Contains a list of other vegationcells within a range of 2
    // the 'neighbors' attribute is built-in to grids.
    list<vegetation_cell> neighbors2 <- self neighbors_at 2;
    list<vegetation_cell> neighbors1 <- self neighbors_at 1;
}