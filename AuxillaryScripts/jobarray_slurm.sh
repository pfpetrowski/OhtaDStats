#Paul Petrowski
#June 1, 2018
#pfpetrowski@mail.missouri.edu

### For each of the variables below, remove the comments and insert your own values. ###

n=100			#Number of jobs to be run
runtime=0-01:00 	#Amount of time to allocate to each job. Format is days-hours:minutes (ie 1-02:33 indicates 1 day, 2 hours, and 33 minutes).
mem=11G			#Amount of memory to give each job. 


for i in `seq 1 n`;
	do
		srun -N 1 -n 1 -t runtime --mem-per-cpu mem Rscript parallelohta.R i
	done
