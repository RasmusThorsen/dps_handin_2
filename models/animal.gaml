/**
* Name: animal
* Authors:
* Alexander Mølsted Hulgaard Rasmussen - 201607814
* Deyana Atanasova - 202001352
* Jakob Dybdahl Andersen - 201607803
* Rasmus Østergaard Thorsen - 201608891
*/

model animal
import "vegetation_cell.gaml"

species animal {
	float size <- 1.0;
	rgb color;
	float max_energy;
	float max_transfer;
	float energy_consum;
	float proba_reproduce;
    int nb_max_offsprings;
    float energy_reproduce;
    image_file my_icon;
    
	vegetation_cell my_cell <- one_of (vegetation_cell);
	float energy <- rnd(max_energy)  max: max_energy;

	init {
		location <- my_cell.location;
	}
	
	reflex move {
		vegetation_cell old_cell <- my_cell;
		my_cell <- choose_cell();
		location <- my_cell.location;
		do update_energy(old_cell, my_cell);
	}
	
 	reflex eat {
    	energy <- energy + energy_from_eat();
    }
    
    reflex reproduce when: (energy >= energy_reproduce) and (flip(proba_reproduce)) and (mate_nearby()) {
    	int nb_offsprings <- rnd(1, nb_max_offsprings);
    	
    	create species(self) number: nb_offsprings {
    		my_cell <- myself.my_cell;
    		location <- my_cell.location;
    		energy <- myself.energy / nb_offsprings;	
    	}
    	energy <- energy / nb_offsprings;
    }
	
    reflex die when: energy <= 0 {
    	do die;
    }

    float energy_from_eat {
    	return 0.0;
    } 
    
    vegetation_cell choose_cell {
    	return nil;
    }
    
    action update_energy (vegetation_cell old_cell, vegetation_cell new_cell) {
    	// abstract method
    }

    bool mate_nearby {
    	return false;
    }
    
    aspect base {
    	draw circle(size) color: color ;
    }
    
    aspect icon {
        draw my_icon size: 2 * size ;
    }
    
    aspect info {
        draw square(size) color: color ;
        draw string(energy with_precision 2) size: 3 color: #black ;
    }
} 