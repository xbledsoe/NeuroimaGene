#!/usr/bin/env Rscript

library(data.table)
library(DBI)
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied ", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = 3
}

gn = args[1]
mod = args[2]
atl = args[3]
typ = args[4]
mtc = args[5]
num = args[6]
resource = args[7]

if(mtc == 'nom') {
    colnm = 'pvalue'
} else {
colnm = paste0(typ, '_', mtc, 'pval')
}



nimg <- dbConnect(RSQLite::SQLite(), resource)

sqlcmd = paste0( "SELECT gene, gene_name, zscore, gwas_phenotype, training_model, ", 
                            colnm, 
                        " FROM associations WHERE gene ='", gn,  
                            "' OR gene_name = '", gn,
                        "' AND ", colnm, "< 0.05 AND atlas='", atl, "' AND modality='", mod,"'")


dt = dbGetQuery(nimg, sqlcmd)
setDT(dt)

if (num < dim(dt)[1]){
    rws = sample(1:dim(dt)[1], num)
    dt2 = dt[rws,]
    } else {
        dt2 = dt
    }

print(dt2)

Assoc = dim(dt)[1]
NIDPs = length(unique(dt$gwas_phenotype))
TMs = length(unique(dt$training_model))
maxZ = max(dt$zscore)
if (dim(dt[zscore == maxZ, c('gwas_phenotype')])[1] == 1) {
    maxznidp = dt[zscore == maxZ, c('gwas_phenotype')]
    maxztm = dt[zscore == maxZ, c('training_model')]
    maxes = paste0("\tMax z-score NIDP: \t", maxznidp ," in ",maxztm,"\n")
    } else {
        maxes = "\tMax z-score NIDP:\tNA => multiple NIDPs\n"
    }



np = dt[, .(.N), by = c('gwas_phenotype')]
maxnidp = max(np$N)
maxNIDP = np[N == maxnidp,]
cat('\n\n\t-----Summary-----\n------------------\n')
cat( paste0("\tNumber of Assoc: \t\t", Assoc ,"\n"))
cat( paste0("\tNumber of NIDPs: \t\t", NIDPs ,"\n"))
cat( paste0("\tNumber of Tissue Models: \t", TMs ,"\n"))
cat('------------------\n')
cat( maxes)
cat( paste0("\tMax z-score: \t\t", maxZ ,"\n\n"))
cat('------------------\n')
cat( paste0('\tMost repeated NIDPs\n\n'))

if (maxnidp >= 4){
    print(np[N == maxnidp,])
    
    } else {
        cat("\t** No NIDPs repeated in more than 3 tissue models**\n\n")
}


