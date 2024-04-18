#!/usr/bin/env Rscript
if (!require('data.table')) install.packages('data.table'); library('data.table')
if (!require('DBI')) install.packages('DBI'); library('DBI')

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
num = as.integer(args[6])
resource = args[7]

if(mtc == 'nom') {
    colnm = 'pvalue'
    mtctbl = 'nomID'
} else {
colnm = paste0(typ, '_', mtc, 'pval')
mtctbl = paste0(typ, '_', mtc, 'ID')
}



nimg <- dbConnect(RSQLite::SQLite(), resource)

if (typ == 'atl') {
	sqlcmd = paste0("SELECT gene, gene_name, gwas_phenotype, training_model, zscore, ",colnm,
	" FROM (SELECT * FROM Parent WHERE geneID IN (SELECT geneID FROM Genes WHERE gene = '",gn,"' OR gene_name = '",gn,"')",
        " AND subsetID IN ( SELECT subsetID FROM Subset WHERE modality = '",mod,"' AND atlas = '",atl,"'))",
    " INNER JOIN ",mtctbl," USING(mainID)", 
    " INNER JOIN Tissue USING(training_modelID)", 
    " INNER JOIN Nidp USING(gwas_phenotypeID)" ,
    " INNER JOIN Genes USING(geneID);")
    
	} else if (typ == 'mod') {
	sqlcmd = paste0("SELECT gene, gene_name, gwas_phenotype, training_model, zscore, ",colnm,
	" FROM (SELECT * FROM Parent WHERE geneID IN (SELECT geneID FROM Genes WHERE gene = '",gn,"' OR gene_name = '",gn,"')",
        " AND subsetID IN ( SELECT subsetID FROM Subset WHERE modality = '",mod,"'))",
    " INNER JOIN ",mtctbl," USING(mainID)", 
    " INNER JOIN Tissue USING(training_modelID)", 
    " INNER JOIN Nidp USING(gwas_phenotypeID)" ,
    " INNER JOIN Genes USING(geneID);")
	} else {
sqlcmd = paste0("SELECT gene, gene_name, gwas_phenotype, training_model, zscore, ",colnm,
	" FROM (SELECT * FROM Parent WHERE geneID IN (SELECT geneID FROM Genes WHERE gene = '",gn,"' OR gene_name = '",gn,"'))",
    " INNER JOIN ",mtctbl," USING(mainID)", 
    " INNER JOIN Tissue USING(training_modelID)", 
    " INNER JOIN Nidp USING(gwas_phenotypeID)" ,
    " INNER JOIN Genes USING(geneID);")
}

#qq = paste0("SELECT * FROM (SELECT geneID, * FROM Parent WHERE geneID IN (SELECT geneID FROM Genes WHERE gene = '",gn,"' OR gene_name = '",gn,"')",
#        " AND subsetID IN ( SELECT subsetID FROM Subset WHERE modality = '",mod,"' AND atlas = '",atl,"'))",
#    " INNER JOIN ",mtctbl," USING(mainID)", 
#    " INNER JOIN Tissue USING(training_modelID)", 
#    " INNER JOIN Nidp USING(gwas_phenotypeID)" ,
#    " INNER JOIN Genes USING(geneID);")

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


