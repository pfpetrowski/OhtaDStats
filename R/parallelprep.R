#' Make prep file for parallelization
#' 
#' Builds a table of pairwise locus comparisons that need to be made. This table can then be used by a workload manager such as 
#' slurm or condor to distribute the tasks among many instances of the dstat function. 
#' 
#' @param data_set The data set that is to be analysed. 
#' @param outfile The name of the file to save the table to. May also be a path.
#' 
#' @examples 
#' data(beissinger_data)
#' parallelprep(data_set = beissinger_data, outfile = "beissinger_comparisons.txt")
#' 
#' 
#### @export when ready
parallelprep <- function(data_set, tot_maf = 0.1, pop_maf = 0.05, comparisons_per_job = 1000, job_id = 1, outfile = "ohta"){
	comparisons <- matrix(NA, nrow = comparisons_per_job, ncol = 2)
	comparisons[1,] <- determinejob(r = job_id * comparisons_per_job - (comparisons_per_job - 1), n = ncol(data_set))
	for (i in 2:nrow(comparisons)){
		a <- comparisons[i-1,][1]
		b <- comparisons[i-1,][2] + 1
		if (b > ncol(data_set)){
			b <- a + 1
			a <- a + 1
		}
		comparisons[i,] <- c(a,b)
	}
	results <- t(apply(comparisons, MARGIN = 1, dstat, data_set = data_set, tot_maf = tot_maf, pop_maf = pop_maf))
	return(cbind(comparisons, results))
}



