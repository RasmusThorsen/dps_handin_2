/**
* Name: animal
* Based on the internal empty template. 
* Author: ralle
* Tags: 
*/


model animal
import "vegetation_cell.gaml"
/* Insert your model definition here */

species animal {
	float size <- 1.0;
	rgb color;
	float max_energy;
	float max_transfert;
	float energy_consum;
	float proba_reproduce;
    int nb_max_offsprings;
    float energy_reproduce;
    image_file my_icon;
    
	// Relate the prey with a random cell.
    // The name of a species returns the entire list - one_of picks one.
	vegetation_cell my_cell <- one_of (vegetation_cell);
	// randomized initialized. At each sim step the energy decreases.
	float energy <- rnd(max_energy) update: energy - energy_consum max: max_energy;
	// set the location to the randomly chosen cell.
	init {
		location <- my_cell.location;
	}
	
	// Reflexes is a block of statements that will be executed if the condition is true.
    // The when-facet is optional - no when = contionusly execution of the reflex.
	reflex basic_move {
		// I am moving to my current cells neighbor. Initial version (random chosen):
		// my_cell <- one_of(my_cell.neighbors2);
		// How a agent chooses a cell is implemented in the derived species.
		my_cell <- choose_cell();
		location <- my_cell.location;
	}
	
 	reflex eat {
    	energy <- energy + energy_from_eat();
    }
    
    // If we have energy for it, and if we 'flip' true - flip is a function that returns a bool based on the proba.
    reflex reproduce when: (energy >= energy_reproduce) and (flip(proba_reproduce)) {
    	// random between 1 and max_offsprings
    	int nb_offsprings <- rnd(1, nb_max_offsprings);
    	
    	// self: The agent that is currently executing the statements inside the block (for example a newly created agent)
    	create species(self) number: nb_offsprings {
    		// myself: The agent that is executing the statement that contains this block (for instance, the agent that has called the create statement)
    		my_cell <- myself.my_cell;
    		location <- my_cell.location;
    		energy <- myself.energy / nb_offsprings;	
    	}
    	energy <- energy / nb_offsprings;
    }
	
	// Use the built-in die-action.
    // Die is a primitive action - it is predefined.
    // Actions to species is like functions for classes
    reflex die when: energy <= 0 {
    	do die;
    }

    float energy_from_eat {
    	return 0.0;
    } 
    
    vegetation_cell choose_cell {
    	return nil;
    }

    
    aspect base {
    	draw circle(size) color: color ;
    }
    
    // defined an icon to be displayed
    aspect icon {
        draw my_icon size: 2 * size ;
    }
    
    // Draw a sqaure with the energy amount
    aspect info {
        draw square(size) color: color ;
        draw string(energy with_precision 2) size: 3 color: #black ;
    }
} 