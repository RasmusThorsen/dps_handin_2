/**
* Name: animal
* Authors:
* Alexander Mølsted Hulgaard Rasmussen - 201607814
* Deyana Atanasova - 202001352
* Jakob Dybdahl Andersen - 201607803
* Rasmus Østergaard Thorsen - 201608891
*/

model vegetationcell

grid vegetation_cell width: 50 height: 50 neighbors: 4 {
    float max_food <- 1.0; // Maximum food a given cell can contain
    float food_prod <- rnd(0.01); // Food produced at each simulation step 
    float food <- rnd(1.0) update: food + food_prod max: max_food; 
    // The greener the more food in that cell.
    rgb color <- rgb(int(255 * (1 - food)), 255, int(255 * (1 - food)))
         update: rgb(int(255 * (1 - food)), 255, int(255 * (1 - food)));
    
    list<vegetation_cell> neighbors2 <- self neighbors_at 2;
    list<vegetation_cell> neighbors3 <- self neighbors_at 3;
    
    list<vegetation_cell> my_neighbors(float n) {
    	return self neighbors_at n;
    }
    
    float dist(vegetation_cell other) {
    	return self distance_to other;
    }
}