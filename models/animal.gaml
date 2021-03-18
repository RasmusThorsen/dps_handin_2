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

	// Move
	reflex move {
		vegetation_cell old_cell <- my_cell;
		my_cell <- choose_cell();
		location <- my_cell.location;
		write name + " energy before move: " + energy;
		do update_energy(old_cell, my_cell);
		write name + " energy after move: " + energy;
	}

	// Eat
 	reflex eat {
    	energy <- energy + energy_from_eat();
    	write name + ' energy after eat: ' + energy;
    }

    // Reproduce
    reflex reproduce when: (energy >= energy_reproduce) and (flip(proba_reproduce)) and (mate_nearby()) {
    	int nb_offsprings <- rnd(1, nb_max_offsprings);

    	create species(self) number: nb_offsprings {
    		my_cell <- myself.my_cell;
    		location <- my_cell.location;
    		energy <- myself.energy / nb_offsprings;
    	}
    	energy <- energy / nb_offsprings;
    	write name + ' reproduced.';
    }

	// Die
	reflex die when: energy <= 0 {
    	write name + ' died.';
    	do die;
    }

	// Action used to calculate the energy gained from eating
	// Implementation depends on the type of animal - predator or prey
    float energy_from_eat {
    	return 0.0;
    }

    // Action used to choose a new cell to which an animal should move
	// Implementation depends on the type of animal - predator or prey
    vegetation_cell choose_cell {
    	return nil;
    }

    // Action used to update the energy of an animal with the energy consumed after moving
	// Implementation depends on the type of animal - predator or prey
    action update_energy (vegetation_cell old_cell, vegetation_cell new_cell);

	// Action used to determine if there is a mate within one field
	// Implementation depends on the type of animal - predator or prey
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