/**
* Name: predator
* Based on the internal empty template. 
* Author: ralle
* Tags: 
*/


model predator

import "prey.gaml"
import "animal.gaml"
/* Insert your model definition here */

global {
	int nb_predators_init <- 20;
    float predator_max_energy <- 1.0;
    float predator_energy_transfert <- 0.5;
    float predator_energy_consum <- 0.02;
    float predator_proba_reproduce <- 0.01;
    int predator_nb_max_offsprings <- 3;
    float predator_energy_reproduce <- 0.5;
}

species predator parent: animal {
	rgb color <- #red;
    float max_energy <- predator_max_energy;
    float energy_transfert <- predator_energy_transfert;
    float energy_consum <- predator_energy_consum;
    float proba_reproduce <- predator_proba_reproduce ;
  	int nb_max_offsprings <- predator_nb_max_offsprings ;
  	float energy_reproduce <- predator_energy_reproduce ;
  	image_file my_icon <- image_file("../includes/data/wolf.png") ;
  	
    float energy_from_eat {
    	// The list of prey inside my cell
	    list<prey> reachable_preys <- prey inside (my_cell);    
	    // If there is prey...
	    if(!empty(reachable_preys)) {
	    	// Ask one prey to call its die-action.
	        ask one_of (reachable_preys) {
	        	do die;
	        }
	        return energy_transfert;
	    }
	    return 0.0;
    }
    
    vegetation_cell choose_cell { 
    	// Shuffle neighbor cells, and find one with a prey inside it.
    	vegetation_cell tmp_cell <- shuffle(my_cell.neighbors2) first_with (!(empty (prey inside each)));
    	if tmp_cell != nil {
    		return tmp_cell;
    	} else {
    		// If no preys nearby pick randomly
    		return one_of (my_cell.neighbors2);
    	}
    }
}