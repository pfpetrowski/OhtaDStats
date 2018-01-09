#' Tomoka Ohta's D Statistics
#' 
#' Implements Ohta's D statistics for a pair of loci
#' 
#' @param index Vector of column names for which Ohta's D Statistics will be computed
#' @param sub Matrix containing genotype data with individuals or lines as rows and loci as columns
#' 
#' 
#' @return nPops Number of subpopulations present in the data set
#' @return D2it Measure of the correlation of the alleles at the specified loci
#' @return D2is Expected variance of LD in all subpopulations
#' @return Dp2st Variance of LD for the total population computed over alleles only
#' @return Dp2is Correlation of alleles at the specified loci relative to their expected correlation in the total population
#' 
#' 
#' @export
Ohta.D.Stats <- function(index,sub){
    sub <- sub[,c(index[1],index[2])]
    if(mean(sub[,1],na.rm=T)>=0.2 & mean(sub[,2],na.rm=T)>=0.2 & mean(sub[,1],na.rm=T)<=1.8 & mean(sub[,2],na.rm=T)<=1.8){
        freqs1 <- unlist(by(sub[,1],rownames(sub),mean,na.rm=T))  # unlist/by appears to do the same thing as tapply
        freqs2 <- unlist(by(sub[,2],rownames(sub),mean,na.rm=T))
        rm <- c(names(freqs1)[which(freqs1<0.1 | freqs1>1.9)], names(freqs2)[which(freqs2<0.1 | freqs2>1.9)])
        if(length(rm)>0) sub <- sub[-which(rownames(sub)%in%rm),]
        if(nrow(sub)>0){
            # Count number of pops
            nPops <- length(table(rownames(sub)))
        
            T <- function(sub){ ### T is a function to compute Tij.s, for any specific subpopulation.
                sub <- sub[which(is.na(sub[,1])==F & is.na(sub[,2])==F),] #Remove any rows with NA values
                length <- nrow(sub)
                s.00 <- length(which(sub[,1]==0 & sub[,2]==0))  # Getting haplotype counts for the designated loci
                s.01 <- length(which(sub[,1]==0 & sub[,2]==1))
                s.02 <- length(which(sub[,1]==0 & sub[,2]==2))
                s.10 <- length(which(sub[,1]==1 & sub[,2]==0))
                s.11 <- length(which(sub[,1]==1 & sub[,2]==1))
                s.12 <- length(which(sub[,1]==1 & sub[,2]==2))
                s.20 <- length(which(sub[,1]==2 & sub[,2]==0))
                s.21 <- length(which(sub[,1]==2 & sub[,2]==1))
                s.22 <- length(which(sub[,1]==2 & sub[,2]==2))
                T00 <- (2 * s.00 + s.01 + s.10 + 0.5 * s.11)/length  # Measure of homozygosity? Should talk to Tim. 
                T02 <- (2 * s.02 + s.01 + s.12 + 0.5 * s.11)/length  # I don't think it measures how often A & B appear in the same gamete.
                T20 <- (2 * s.20 + s.10 + s.21 + 0.5 * s.11)/length
                T22 <- (2 * s.22 + s.21 + s.12 + 0.5 * s.11)/length
                return(c(T00,T02,T20,T22))
            }
          
        
            P <- function(sub,out){
                sub <- sub[which(is.na(sub[,1])==F & is.na(sub[,2])==F),]
                length <- nrow(sub)
                p1.0 <- 1-sum(sub[,1],na.rm=T)/(2*length)
                p1.2 <- 1-p1.0
                p2.0 <- 1-sum(sub[,2],na.rm=T)/(2*length)
                p2.2 <- 1-p2.0
                if(out=="freq")  return(c(p1.0, p1.2, p2.0, p2.2))
                if(out=="manip1") return(c(2*p1.0*p2.0, 2*p1.0*p2.2, 2*p1.2*p2.0, 2*p1.2*p2.2))
                if(out=="manip2") return(c(p1.0*p2.0, p1.0*p2.2, p1.2*p2.0, p1.2*p2.2))
            } #P returns allele frequencies or manipulated frequencies
        
            ### Compute Tijs
            Tijs <- by(sub,rownames(sub),T)
            Tijs.n <- as.numeric(unlist(Tijs))
            
            ### Compute P manipulated1
            P1m <-  by(sub,rownames(sub),P,"manip1")
            P1m.n <- as.numeric(unlist(P1m))
            
            ### Compute P manipulated2
            P2m <-  by(sub,rownames(sub),P,"manip2")
            P2m.n <- as.numeric(unlist(P2m))
            
            ### Compute P freq
            Pf <- by(sub,rownames(sub),P,"freq")
            Pf.n <- as.numeric(unlist(Pf))
            
            ### Compute n.pops
            n.pops <- length(levels(as.factor(rownames(sub))))
            
            ### Compute D2is
            D2is <- sum((Tijs.n-P1m.n)^2)/n.pops
            
            ### Compute mean allele frequencies
            p1.0 <- mean(Pf.n[seq(1,length(Pf.n),4)]) # Compute mean frequencies
            p1.2 <- mean(Pf.n[seq(2,length(Pf.n),4)]) #
            p2.0 <- mean(Pf.n[seq(3,length(Pf.n),4)]) #
            p2.2 <- mean(Pf.n[seq(4,length(Pf.n),4)]) # done
            
            ### Create vector of mean allele frequencies (that is comparable to Tijs.n)
            Pf.v <- c()
            Pf.v[seq(1,length(Pf.n),4)] <- 2*p1.0*p2.0
            Pf.v[seq(2,length(Pf.n),4)] <- 2*p1.0*p2.2
            Pf.v[seq(3,length(Pf.n),4)] <- 2*p1.2*p2.0
            Pf.v[seq(4,length(Pf.n),4)] <- 2*p1.2*p2.2
            
            ### Compute mean T
            T00 <- mean(Tijs.n[seq(1,length(Tijs.n),4)]) # Compute mean T
            T02 <- mean(Tijs.n[seq(2,length(Tijs.n),4)]) #
            T20 <- mean(Tijs.n[seq(3,length(Tijs.n),4)]) #
            T22 <- mean(Tijs.n[seq(4,length(Tijs.n),4)]) # done
            
            ### Create vector of mean T (that is comparable to Tijs.n)
            Tijs.n2 <- c()
            Tijs.n2[seq(1,length(Tijs.n),4)] <- T00
            Tijs.n2[seq(2,length(Tijs.n),4)] <- T02
            Tijs.n2[seq(3,length(Tijs.n),4)] <- T20
            Tijs.n2[seq(4,length(Tijs.n),4)] <- T22
            
            ### Compute D2it
            D2it <- sum((Tijs.n-Pf.v)^2)/n.pops
            
            ### Compute D2st
            D2st <- sum((P2m.n-Pf.v/2)^2)/n.pops
            
            ### Compute Dp2st
            p0p0 <- 2*p1.0*p2.0
            p0p2 <- 2*p1.0*p2.2
            p2p0 <- 2*p1.2*p2.0
            p2p2 <- 2*p1.2*p2.2
            Dp2st <- (T00-p0p0)^2+(T02-p0p2)^2+(T20-p2p0)^2+(T22-p2p2)^2
            
            ### Compute Dp2is
            Dp2is <- sum((Tijs.n-Tijs.n2)^2)/n.pops
        }
        else{
            D2it <- NA; D2is <- NA; D2st <- NA; Dp2st <- NA; Dp2is <- NA; nPops <- NA
        }
    }
    else{
        D2it <- NA; D2is <- NA; D2st <- NA; Dp2st <- NA; Dp2is <- NA; nPops <- NA
    }
return(c(nPops, D2it, D2is, D2st, Dp2st, Dp2is))
}



########################################################################
### This script house a function that can be used to compute Ohta's  ###
### 1982 D statistics.                                               ###
########################################################################

### Timothy M. Beissinger

### Citation: Beissinger, T. M., Gholami, M., Erbe, M., et al. (2015). Using the
### variability of linkage disequilibrium between subpopulations to infer sweeps
### and epistatic selection in a diverse panel of chickens. Heredity.    
### doi: 10.1038/hdy.2015.81      

####################################################################################################
########################### All-In-One #############################################################
####################################################################################################

### The input for this function is a matrix of genotypes, coded 0, 1, or 2. (AA, AB, or BB)
### Row names are breed/population identifiers. NA values should be coded as NA.
### The index parameter is a two element vector in the form c(col1, col2) that specifies
### between which columns D stats should be computed.    
### Output is a vector of Ohta's D statistics, in the following order  :
### D2it; D2is D2st; Dp2st; Dp2is

### NOTE: THE BELOW FILTERS TO REMOVE ANY COMBINATIONS FROM ANALYSIS FOR WHICH BOTH LOCI DO NOT HAVE ALLELE FREQUENCY >= 0.1
### NOTE: THE BELOW FILTERS TO REMOVE ANY POPS FROM ANALYSIS THAT DO NOT HAVE ALLELE FREQUENCY AT LEAST 0.05
