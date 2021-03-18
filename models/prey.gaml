/**
* Name: prey
* Authors:
* Alexander Mølsted Hulgaard Rasmussen - 201607814
* Deyana Atanasova - 202001352
* Jakob Dybdahl Andersen - 201607803
* Rasmus Østergaard Thorsen - 201608891
*/

model prey
import "vegetation_cell.gaml"
import "animal.gaml"
import "predator.gaml"

global {
	int nb_preys_init <- 200; // Initial number of prey agents
    float prey_max_energy <- 1.0; // Maximum energy of prey agents
	float prey_max_transfer <- 0.1; // Maximum energy that can a prey agent can consume from vegetation per step
	float prey_energy_consum_grazing <- 0.1;  // Energy used at each step by a prey agent when grazing
	float prey_energy_consum_wandering <- 0.2; // Energy used at each step by a prey agent when wandering
	//TODO: add energy consumption for fleeing?
	float prey_proba_reproduce <- 0.01; // Reproduction probability for prey agents
    int prey_nb_max_offsprings <- 5; // Maximum number of offspring for prey agents
    float prey_energy_reproduce <- 0.5; // Minimum energy required to reproduce for prey agents
    float prey_viewable_radius <- 3.0; // TODO: can sheep see 3 fields away?
}

species prey parent: animal {
    rgb color <- #blue;
    float max_energy <- prey_max_energy;
    float max_transfer <- prey_max_transfer;
    float proba_reproduce <- prey_proba_reproduce;
  	int nb_max_offsprings <- prey_nb_max_offsprings;
  	float energy_reproduce <- prey_energy_reproduce;
  	bool moving <- false; //TODO: why is this needed?
    image_file sheep_icon <- image_file("../includes/data/sheep.png");
    image_file fear_icon <- image_file("../includes/data/poop.png");
    image_file my_icon <- sheep_icon;

    float energy_from_eat {
	    float energy_transfert <- 0.0;
	    if(my_cell.food > 0) {
	        energy_transfert <- min([max_transfer, my_cell.food]);
	        my_cell.food <- my_cell.food - energy_transfert;
	    }
	    return energy_transfert;
    }

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

    		// return available_cells with_max_of (each.food); //TODO: remove these comments?
    		return one_of(available_cells);
    		// return nil;
    	}
    }

    action update_energy (vegetation_cell old_cell, vegetation_cell new_cell) {
		if new_cell = old_cell {
			write 'Sheep did not move.';
			energy <- energy - prey_energy_consum_grazing;
		}
		else{
			write 'Sheep moved.';
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