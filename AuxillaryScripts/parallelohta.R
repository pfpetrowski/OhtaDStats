#Paul  F. Petrowski
#June 1, 2018


### For each of the following variables, remove the comments and set them to the desired values. ###

#data_set = 							#Path to your dataset
#tot_maf =  							#Minor allele frequency threshold for the total population
#pop_maf =								#Minor allele frequency you would like to use for subpopulations
#comparisons_per_job = 		#Number of comparisons each job will perform
#outfile =  							#Prefix for the file name that results will be written to. Do not include extension. Default is "ohta", which will write to a file called "ohta.sqlite".



args <- commandArgs(TRUE)

ohtadstats::dparallel(data_set = data_set,
											tot_maf = tot_maf,
											pop_maf = pop_maf,
											comparisons_per_job = comparisons_per_job,
											job_id = as.integer(args[1]),
											outfile = outfile)