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
dparallel <- function(data_set, tot_maf = 0.1, pop_maf = 0.05, comparisons_per_job, job_id, outfile = "ohta"){
	# data_set will actually need to be an rda that is loaded in
	comparisons <- matrix(NA, nrow = comparisons_per_job, ncol = 2)
	comparisons[1,] <- determinejob(r = job_id * comparisons_per_job - (comparisons_per_job - 1), n = ncol(data_set))
	for (i in 2:nrow(comparisons)){      # Fill in the rest of the comparison matrix.
		a <- comparisons[i-1,][1]
		b <- comparisons[i-1,][2] + 1
		if (b > ncol(data_set)){               # Resets a and b to the next position when b names the last locus
			b <- a + 1
			a <- a + 1
		}
		if (a > ncol(data_set)){               # Truncates the list of comparisons if it goes beyond the possible comparisons.
			comparisons <- na.omit(comparisons)
			break
		}
		comparisons[i,] <- c(a,b)
	}
	results <- t(apply(comparisons, MARGIN = 1, dstat, data_set = data_set, tot_maf = tot_maf, pop_maf = pop_maf))
	results <- cbind(comparisons, results)
	colnames(results) <- c('Marker1', 'Marker2', 'nPops', 'D2it', 'D2is', 'D2st', 'Dp2st', 'Dp2is')
	database <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = paste(outfile, '.sqlite', sep = ''))     #Open database connection
	DBI::dbWriteTable(conn = database, name = "OhtasD", value = as.data.frame(results), append = TRUE)    #Dump results into the database
	DBI::dbDisconnect(database)                                                                           #Disconnect from database
}
