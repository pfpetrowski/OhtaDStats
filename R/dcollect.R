dcollect <- function(prefix = 'Ohta', outfile){
	#Sort by MArker1 then Marker2
	#Ensure length(table) == n*(n-1)/2 + n
	#Make list of missing comparisons?
	#Return table to an R matrix
	system2("tail", paste("-q -n +2 ", outfile, "* ", "> ", outfile, ".csv", sep = "" ))
}