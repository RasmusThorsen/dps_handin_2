/**
* Name: prey
* Based on the internal empty template.
* Author: ralle
* Tags:
*/


model prey

import "vegetation_cell.gaml"
import "animal.gaml"
import "predator.gaml"
/* Insert your model definition here */

global {
	int nb_preys_init <- 200;
    float prey_max_energy <- 1.0;
	float prey_max_transfert <- 0.1;
	float prey_energy_consum_grazing <- 0.1;
	float prey_energy_consum_wandering <- 0.2; //TODO: add energy consumption for fleeing?
	float prey_proba_reproduce <- 0.01;
    int prey_nb_max_offsprings <- 5;
    float prey_energy_reproduce <- 0.5;
    float prey_viewable_radius <- 3.0;
}

species prey parent: animal {
    rgb color <- #blue;
    float max_energy <- prey_max_energy;
    float max_transfert <- prey_max_transfert;
    float proba_reproduce <- prey_proba_reproduce;
  	int nb_max_offsprings <- prey_nb_max_offsprings;
  	float energy_reproduce <- prey_energy_reproduce;
  	bool moving <- false;
    image_file sheep_icon <- image_file("../includes/data/sheep.png");
    image_file fear_icon <- image_file("../includes/data/poop.png");
    image_file my_icon <- sheep_icon;

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
    	list<vegetation_cell> predator_nearby <- my_cell.neighbors where (!(empty (predator inside each)));

    	if (empty(predator_nearby)) {
    		my_icon <- sheep_icon;
    		vegetation_cell best_neighbor <- (my_cell.neighbors) with_max_of (each.food);
    		vegetation_cell chosen_cell <- best_neighbor.food > my_cell.food ? best_neighbor : my_cell;
    		return chosen_cell;
    	} else {
    		my_icon <- fear_icon;
    		list<vegetation_cell> predator_cells <- my_cell.neighbors3 where (!(empty (predator inside each)));
    		list<vegetation_cell> neighbors3 <- my_cell.neighbors3;
    		list<vegetation_cell> available_cells <- neighbors3 - predator_cells - [my_cell];

    		// return available_cells with_max_of (each.food);
    		return one_of(available_cells);
    		// return nil;
    	}
    }

    action update_energy (vegetation_cell old_cell, vegetation_cell new_cell) {
		if old_cell = new_cell {
			energy <- energy - prey_energy_consum_grazing;
		}
		else{
			energy <- energy - prey_energy_consum_wandering;
		}
    }

    bool mate_nearby {
    	vegetation_cell tmp_cell <- shuffle(my_cell.neighbors) first_with (!(empty(prey inside each)));
    	if tmp_cell != nil {
    		return true;
    	}
    	return false;
    }

}