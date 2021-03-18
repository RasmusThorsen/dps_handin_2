/**
* Name: predator
* Authors:
* Alexander Mølsted Hulgaard Rasmussen - 201607814
* Deyana Atanasova - 202001352
* Jakob Dybdahl Andersen - 201607803
* Rasmus Østergaard Thorsen - 201608891
*/

model predator

import "prey.gaml"
import "animal.gaml"

global {
	int nb_predators_init <- 20; // Initial number of predator agents
    float predator_max_energy <- 1.0; // Maximum energy of predator agents
    float predator_energy_transfer <- 0.5; // Maximum energy that can a predator agent can consume from preys per step
    float predator_energy_consum <- 0.02; // Energy used at each step by a prey agent when moving normally
    float predator_energy_consum_sprint <- 0.025; // Energy used at each step by a prey agent when sprinting
    float predator_energy_consum_resting <- 0.01;
    float predator_proba_reproduce <- 0.01; // Reproduction probability for predator agents
    int predator_nb_max_offsprings <- 3; // Maximum number of offspring for predator agents
    float predator_energy_reproduce <- 0.5; // Minimum energy required to reproduce for predator agents
    float predator_smell_radius <- 6.0; // Radius in which the predator can smell preys
    float predator_view_radius <- 2.0; // Radius in which the predator can see preys
}

species predator parent: animal skills: [moving] {
	rgb color <- #red;
    float max_energy <- predator_max_energy;
    float energy_transfer <- predator_energy_transfer;
    float proba_reproduce <- predator_proba_reproduce ;
  	int nb_max_offsprings <- predator_nb_max_offsprings ;
  	float energy_reproduce <- predator_energy_reproduce ;
  	image_file my_icon <- image_file("../includes/data/wolf.png");
  	image_file hunted_icon <- image_file("../includes/data/hunted.png");
  	
  	list<vegetation_cell> visible_vegetation -> my_cell.my_neighbors(predator_view_radius);
  	list smellable_animals -> (agents_inside(my_cell.my_neighbors(predator_smell_radius))) of_generic_species animal;
  	
    float energy_from_eat {
	    list<prey> reachable_preys <- prey inside (my_cell);    
	    if(!empty(reachable_preys)) {
	        ask one_of (reachable_preys) {
	        	do die;
	        }
	        // write name + ' caught a prey.';
	        return energy_transfer;
	    }
	    // write name + ' didn\'t catch a prey.';
	    return 0.0;
    }
    
    vegetation_cell choose_cell { 
    	// Try to find a prey within one field
    	vegetation_cell tmp_cell <- shuffle(my_cell.neighbors) first_with (!(empty (prey inside each)));
    	if tmp_cell != nil {
    		return tmp_cell;
    	}
    	// Try to find a prey within two fields
    	tmp_cell <- shuffle(my_cell.neighbors2) first_with (!(empty (prey inside each)));
    	if tmp_cell != nil {
    		return tmp_cell;
    	}
    	
    	else if !empty(smellable_animals of_species prey) {
    		// Pick the cell that is closest to the smell of the prey
    		float shortest_distance <- #infinity;
    		vegetation_cell new_cell <- nil;
    		prey hunted_prey <- (smellable_animals of_species prey) closest_to self;
    		// hunted_prey.my_icon <- hunted_icon;
    		
    		loop smellable_animal over: smellable_animals {
    			write self.name + ' smells animal at: ' + smellable_animal.my_cell.grid_x + ', ' + smellable_animal.my_cell.grid_y;
    		}
    		
    		loop neighbor over: my_cell.neighbors2 {
    			float current_distance <- neighbor.dist(hunted_prey.my_cell);
    			if current_distance < shortest_distance {
    				shortest_distance <- current_distance;
    				new_cell <- neighbor;
    			}
    		}
    		
    		return new_cell;
    	}
    	else {
    		// If we cannot smell any prey, then we can hunt in packs instead
    		predator pack <- one_of(smellable_animals of_species predator);
    		
    		if pack != nil {
    			list<predator> predators <- smellable_animals of_species predator;
    			vegetation_cell closest <- my_cell.neighbors closest_to pack;
    			return closest;
    		} else {
    			// If we cannot smell any other predator we just pick randomly
    			return (my_cell.neighbors + [my_cell]) with_max_of (each.food);
    		}
    	}
    }
    
    action update_energy (vegetation_cell old_cell, vegetation_cell new_cell) {
    	if (old_cell = new_cell) {
    		write 'Wolf reseting';
    		energy <- energy - predator_energy_consum_resting;
    		return;
    	}
    	
    	float dist <- old_cell.dist(new_cell);
    	write 'dist: ' + dist;
		if (dist = 1.0) {
			write 'Wolf moved normally.';
			energy <- energy - predator_energy_consum ;
		}
		else if (dist = 2.0) {
			write 'Wolf sprinted.';
			energy <- energy - predator_energy_consum_sprint;
		} else {
			write 'ERROR: Wrong dist';
		}
    }
    
    bool mate_nearby {
    	vegetation_cell tmp_cell <- shuffle(my_cell.neighbors) first_with (!(empty(predator inside each)));
    	if tmp_cell != nil {
    		return true;
    	}
    	return false;
    }
}