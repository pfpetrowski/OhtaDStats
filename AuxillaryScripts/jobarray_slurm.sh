#Paul Petrowski
#June 1, 2018
#pfpetrowski@mail.missouri.edu

### For each of the variables below, remove the comments and insert your own values. ###

#n = 				#Number of jobs to be run 
#time = 			#Amount of time to allocate to each job. Format is days-hours:minutes (ie 1-02:33 indicates 1 day, 2 hours, and 33 minutes).
#mem =				#Amount of memory to give each job. 


for i in `seq 1 n`;
	do
		srun -t time --mem-per-cpu mem Rscript parallelohta.R i
	done