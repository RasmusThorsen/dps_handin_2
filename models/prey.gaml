/**
* Name: prey
* Based on the internal empty template. 
* Author: ralle
* Tags: 
*/


model prey

import "vegetation_cell.gaml"
import "animal.gaml"
/* Insert your model definition here */

global {
	int nb_preys_init <- 200;
    float prey_max_energy <- 1.0;
	float prey_max_transfert <- 0.1;
	float prey_energy_consum <- 0.05;
    float prey_proba_reproduce <- 0.01;
    int prey_nb_max_offsprings <- 5; 
    float prey_energy_reproduce <- 0.5; 
}

species prey parent: animal {
    rgb color <- #blue;
    float max_energy <- prey_max_energy;
    float max_transfert <- prey_max_transfert;
    float energy_consum <- prey_energy_consum;
    float proba_reproduce <- prey_proba_reproduce;
  	int nb_max_offsprings <- prey_nb_max_offsprings;
  	float energy_reproduce <- prey_energy_reproduce;
    image_file my_icon <- image_file("../includes/data/sheep.png");
    
//	old eat
//    reflex eat when: my_cell.food > 0 {
//    	// We can only eat the value of max, even though there is more food in the cell.
//    	float energy_transfer <- min([max_transfer, my_cell.food]);
//    	// Deduct the transfered energy from the cell...
//    	my_cell.food <- my_cell.food - energy_transfer;
//    	/// ... and add to the preys energy
//    	energy <- energy + energy_transfer;
//    }
    
    // Overwrite the eat-action (actions is like functions)
    float energy_from_eat {
	    float energy_transfert <- 0.0;
	    if(my_cell.food > 0) {
	    	// We can only eat the value of max, even though there is more food in the cell.
	        energy_transfert <- min([max_transfert, my_cell.food]);
	        
	        // Deduct the transfered energy from the cell...
	        my_cell.food <- my_cell.food - energy_transfert;
	    }           
	    return energy_transfert;
    }
    
    // GAMA has alot of different operators on list, both binary (where, first_with, ...) and unary (min, max, sum, ...)
    // For binary operators each element can be accesed with the pseudo-operator: each.
    // In this case each refers to a cell
    vegetation_cell choose_cell {
    	return (my_cell.neighbors2) with_max_of (each.food);
    }

} 