/**
* Name: animal
* Authors:
* Alexander Mølsted Hulgaard Rasmussen - 201607814
* Deyana Atanasova - 202001352
* Jakob Dybdahl Andersen - 201607803
* Rasmus Østergaard Thorsen - 201608891
*/

model main

import "prey.gaml"
import "predator.gaml"

global {
	int nb_preys ->{length (prey)};
    int nb_predators -> {length (predator)};

    init {
    	create prey number: nb_preys_init;
        create predator number: nb_predators_init;
    }

    reflex stop_simulation when: (nb_preys = 0) or (nb_predators = 0) {
        do pause ;
    }
}

experiment prey_predator type: gui {
    parameter "Initial number of preys: " var: nb_preys_init min: 1 max: 1000 category: "Prey";
    parameter "Prey max energy: " var: prey_max_energy category: "Prey";
	parameter "Prey max transfer: " var: prey_max_transfer  category: "Prey";
	parameter "Prey energy consumption when grazing: " var: prey_energy_consum_grazing  category: "Prey";
	parameter "Prey energy consumption when wandering: " var: prey_energy_consum_wandering  category: "Prey";
	parameter "Prey probability reproduce: " var: prey_proba_reproduce category: "Prey" ;
	parameter "Prey nb max offsprings: " var: prey_nb_max_offsprings category: "Prey" ;
	parameter "Prey energy reproduce: " var: prey_energy_reproduce category: "Prey" ;

    parameter "Initial number of predators: " var: nb_predators_init min:0 max: 200 category: "Predator";
    parameter "Predator max energy: " var: predator_max_energy category: "Predator";
	parameter "Predator energy transfer: " var: predator_energy_transfer category: "Predator";
	parameter "Predator energy consumption when moving: " var: predator_energy_consum  category: "Predator";
	parameter "Predator energy consumption when sprinting: " var: predator_energy_consum_sprint  category: "Predator";
	parameter "Predator probability reproduce: " var: predator_proba_reproduce category: "Predator" ;
	parameter "Predator nb max offsprings: " var: predator_nb_max_offsprings category: "Predator" ;
	parameter "Predator energy reproduce: " var: predator_energy_reproduce category: "Predator" ;

    output {
    	display main_display {
    		grid vegetation_cell lines: #black;
        	species prey aspect: icon ;
        	species predator aspect: icon;
 		}

 		display info_display {
            grid vegetation_cell lines: #black;
            species prey aspect: info;
            species predator aspect: info;
        }

        display Population_information refresh:every(5#cycles) {
		    chart "Species evolution" type: series size: {1,0.5} position: {0, 0} {
		    	data "number_of_preys" value: nb_preys color: #blue ;
		    	data "number_of_predator" value: nb_predators color: #red ;
		    }
		    chart "Prey Energy Distribution" type: histogram background: #lightgray size: {0.5,0.5} position: {0, 0.5} {
		    	data "]0;0.25]" value: prey count (each.energy <= 0.25) color:#blue;
		    	data "]0.25;0.5]" value: prey count ((each.energy > 0.25) and (each.energy <= 0.5)) color:#blue;
		    	data "]0.5;0.75]" value: prey count ((each.energy > 0.5) and (each.energy <= 0.75)) color:#blue;
		    	data "]0.75;1]" value: prey count (each.energy > 0.75) color:#blue;
		    }

		    chart "Predator Energy Distribution" type: histogram background: #lightgray size: {0.5,0.5} position: {0.5, 0.5} {
		    	data "]0;0.25]" value: predator count (each.energy <= 0.25) color: #red ;
		    	data "]0.25;0.5]" value: predator count ((each.energy > 0.25) and (each.energy <= 0.5)) color: #red ;
		    	data "]0.5;0.75]" value: predator count ((each.energy > 0.5) and (each.energy <= 0.75)) color: #red ;
		    	data "]0.75;1]" value: predator count (each.energy > 0.75) color: #red;
		    }
		}

 		monitor "Number of preys" value: nb_preys;
 		monitor "Number of predators" value: nb_predators;
    }
}