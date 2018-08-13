#!/bin/bash
#Paul Petrowski
#June 1, 2018
#pfpetrowski@mail.missouri.edu

### For each of the variables below, remove the comments and insert your own values. ###

n=1000				#Number of jobs to be run
runtime=0-01:15 		#Amount of time to allocate to each job. Format is days-hours:minutes (ie 1-02:33 indicates 1 day, 2 hours, and 33 minutes).
mem=11G				#Amount of memory to give each job. 
log=logs/scaling-%A.out		#Where to put log files

module load r/r-3.4.2

for i in `seq 6 10`;
	do
		sbatch -N 1 -n 1 -t $runtime -p BioCompute --mem-per-cpu $mem --output $log --wrap "Rscript scripts/parallelohta.R $i; echo '### Starting at $(date) ###'; echo 'Job Number $i'; module list; echo '### Ending at $(date) ###'"
	done
