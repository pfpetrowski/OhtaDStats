#Paul  F. Petrowski
#August 10, 2018


### For each of the following variables, remove the comments and set them to the desired values. ###

data_set = "rawdata/TroyFullData.rds"				#Path to your dataset
tot_maf = 0.1  							#Minor allele frequency threshold for the total population
pop_maf = 0.05							#Minor allele frequency you would like to use for subpopulations
comparisons_per_job = 26146					#Number of comparisons each job will perform
outfile =  "outputs/Ohta"					#Prefix for the file name that results will be written to. Do not include extension. Default is "ohta", which will write to a file called "ohta.sqlite".

data_set <- readRDS(data_set)

job_id <- commandArgs(TRUE)


ohtadstats::dparallel(data_set = data_set,
		      tot_maf = tot_maf,
		      pop_maf = pop_maf,
		      comparisons_per_job = comparisons_per_job,
		      job_id = as.integer(job_id[1]),
		      outfile = outfile)
