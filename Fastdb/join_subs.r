library(data.table)
library(plyr)
library(DBI)

anno = fread('/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Masterscript/Reference/BIG40-IDPs_v4_discovery2_anno.tsv', header = TRUE)
DT = fread('/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/TWAS_33K/all_assocs_33K_nom.txt', header = TRUE)
#DT$nom = DT$pvalue

#mods = c(list.files(path = '/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets',
 #   pattern = 'BFsig|BHsig|nom', 
 #   full.names = TRUE))


    
#for (fil in mods) {
#    nm = unlist(strsplit(unlist(strsplit(fil, 'all_assocs_33K_'))[2], '.txt'))[1]
#    new = fread(fil, header = TRUE)
#    new = setnames(new,  names(new)[8], nm)
#    cols=c('gene', 'gwas_phenotype', 'training_model', nm)
#    DT2 = join(DT, new[, ..cols], by = c('gene', 'gwas_phenotype', 'training_model'), match = 'first')
    
#}

#atl = c(list.files( path = '/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets/atl', 
#    pattern = 'BFsig|BHsig|nom', full.names = TRUE))
    
new = fread('/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/TWAS_33K/all_assocs_33K_BHsig.txt', header = TRUE)   
new = setnames(new[, c('gene', 'gwas_phenotype', 'training_model', 'bhpval')], 'bhpval', 'all_BHpval')
DT = join(DT, new, by = c('gene', 'gwas_phenotype', 'training_model'), match = 'first')

new = fread('/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/TWAS_33K/all_assocs_33K_BFsig.txt', header = TRUE)   
new = setnames(new[, c('gene', 'gwas_phenotype', 'training_model', 'bfpval')], 'bfpval', 'all_BFpval')
DT = join(DT, new, by = c('gene', 'gwas_phenotype', 'training_model'), match = 'first')



new = fread('/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets/NeuroimaGene/BHmods.txt', header = TRUE)
new = setnames(new, names(new)[4], 'mod_BHpval')
DT = join(DT, new, by = c('gene', 'gwas_phenotype', 'training_model'), match = 'first')


new = fread('/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets/NeuroimaGene/BFmods.txt', header = TRUE)
new = setnames(new, names(new)[4], 'mod_BFpval')
DT = join(DT, new, by = c('gene', 'gwas_phenotype', 'training_model'), match = 'first')

new = fread('/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets/NeuroimaGene/BHatls.txt', header = TRUE)
new = setnames(new, names(new)[4], 'atl_BHpval')
DT = join(DT, new, by = c('gene', 'gwas_phenotype', 'training_model'), match = 'first')

new = fread('/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets/NeuroimaGene/BFatls.txt', header = TRUE)
new = setnames(new, names(new)[4], 'atl_BFpval')
DT = join(DT, new, by = c('gene', 'gwas_phenotype', 'training_model'), match = 'first')

cols=c('gwas_phenotype', 'modality', 'atlas')
DT = join(DT, anno[, ..cols], by = c('gwas_phenotype'), match = 'all')

write.table(DT, file = '/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets/NeuroimaGene/NeuroimaGene.txt', col.names = TRUE, row.names = FALSE, sep = '\t', quote = FALSE)


nimg <- dbConnect(RSQLite::SQLite(), "/gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets/NeuroimaGene/NeuroimaGene.db")
dbWriteTable(nimg, "associations", DT)

#tt = dbGetQuery(nimg, "SELECT gene_name, gwas_phenotype, training_model, atl_BHpval FROM associations WHERE gene='ENSG00000183336' AND atl_BHpval <0.05 AND atlas='AmygNuclei'")
dbDisconnect(nimg)


