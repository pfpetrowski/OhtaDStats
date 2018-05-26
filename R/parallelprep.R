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
parallelprep <- function(data_set, outfile = "ohtacomparisons.txt"){
	num_comparisons <- (ncol(data_set)*(ncol(data_set)-1))/2 + ncol(data_set)
	comparisons <- matrix(NA, nrow = num_comparisons, ncol = 2)

	row = 1
	for (i in 1:ncol(data_set)){
		for (j in i:ncol(data_set)){
			comparisons[row,1] <- i
			comparisons[row,2] <- j
			row = row + 1
  	}
	}
	write(x = t(comparisons), file = outfile, ncolumns = 2)
}




