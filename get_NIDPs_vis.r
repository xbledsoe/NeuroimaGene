if (!require('ggplot2')) install.packages('ggplot2'); library('ggplot2')
if (!require('data.table')) install.packages('data.table'); library('data.table')
if (!require('DBI')) install.packages('DBI'); library('DBI')
if (!require('stringr')) install.packages('stringr'); library('stringr')
library(ggseg)

# The aim here is to curate lists of the top UKBB gwas phenotypes from individual genes or 
# lists of genes  
#
# I'll collect all the associations across training models and genes and then, for each group, 
# I'll characterize the distribution of zscore magnitude, zscore direction correlation, NIDP
# replication across multiple genes and across multiple training_models. 

# Get user parameters
library("optparse")
option_list = list(
  make_option(c("-f", "--filename"), type="character", default=NA, 
              help="file containing genes", metavar="character"),
  make_option(c("-r", "--resource"), type="character", default=NA, 
              help="neuroimaGene resource file", metavar="character"),
  make_option(c("-o", "--output"), type="character", default=getwd(), 
              help="output directory", metavar="character"),
  make_option(c("-g", "--genes"), type="character", default="N", 
              help="Do you want individual gene data? [y/n]", metavar="character"),
  make_option(c("-m", "--modality"), type="character", default= NA, 
              help="NIDP modality of interest", metavar="character"),    
  make_option(c("-a", "--atlas"), type="character", default= NA, 
              help="NIDP atlas of interest", metavar="character"),
  make_option(c("-p", "--mtc"), type="character", default= NA, 
              help="pvalue threshold", metavar="character"),
  make_option(c("-t", "--typ"), type="character", default= NA, 
              help="type of analysis (modality, atlas, all)", metavar="character"),
  make_option(c("-s", "--short_name"), type="character", default= NA, 
              help="annotations", metavar="character"),
  make_option(c("-b", "--fs_annotation"), type="character", default= NA, 
              help="annotation file for geom_brain", metavar="character"),
  make_option(c("-n", "--nm"), type="character", default= 'noname', 
              help="tag name of analysis", metavar="character")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

anno = fread(opt$short_name, header = TRUE)
fil = opt$filename
gns = setDT(read.table(fil, header = FALSE, stringsAsFactors = TRUE))
if (opt$nm == 'noname') {
  nm = tail(unlist(strsplit(unlist(strsplit(fil, '\\.[a-z]'))[1], '/')), 1)
  noquote('Extracted analysis tag from gene file...') 
  noquote(paste('Using', nm, 'as tag name for this analysis.'))
  noquote("Custom analysis tags can be provided via the flag '-n'")
} else {
  nm=opt$nm
}
otpt = paste0(opt$output, nm,'_NIDPs/')
var = opt$genes
mtc = opt$mtc
mod = opt$modality
atl = opt$atlas
typ = opt$typ
fs_anno = fread(opt$fs_annotation, header = TRUE)


dir.create(otpt)

if(mtc == 'nom') {
  colnm = 'pvalue'
  mtctbl = 'nomID'
} else {
  colnm = paste0(typ, '_', mtc, 'pval')
  mtctbl = paste0(typ, '_', mtc, 'ID')
}


# read in TWAS data
nimg <- dbConnect(RSQLite::SQLite(), opt$resource)

if (typ == 'atl') {
  sqlcmd = paste0("SELECT gene, gene_name, gwas_phenotype, training_model, zscore, ", colnm,
                  " FROM (SELECT * FROM Parent WHERE geneID IN (SELECT geneID FROM Genes", 
                  " WHERE gene IN (", paste(shQuote(gns$V1, type = "sh"), collapse = ', '), 
                  ") OR gene_name IN (", paste(shQuote(gns$V1, type = "sh"), collapse = ', '),")) ",
                  " AND subsetID IN ( SELECT subsetID FROM Subset WHERE modality = '",mod,"' AND atlas = '",atl,"'))",
                  " INNER JOIN ",mtctbl," USING(mainID)", 
                  " INNER JOIN Tissue USING(training_modelID)", 
                  " INNER JOIN Nidp USING(gwas_phenotypeID)" ,
                  " INNER JOIN Genes USING(geneID);")
  
} else if (typ == 'mod') {
  sqlcmd = paste0("SELECT gene, gene_name, gwas_phenotype, training_model, zscore, ", colnm,
                  " FROM (SELECT * FROM Parent WHERE geneID IN (SELECT geneID FROM Genes", 
                  " WHERE gene IN (", paste(shQuote(gns$V1, type = "sh"), collapse = ', '), 
                  ") OR gene_name IN (", paste(shQuote(gns$V1, type = "sh"), collapse = ', '),"))",
                  " AND subsetID IN ( SELECT subsetID FROM Subset WHERE modality = '",mod,"'))",
                  " INNER JOIN ",mtctbl," USING(mainID)", 
                  " INNER JOIN Tissue USING(training_modelID)", 
                  " INNER JOIN Nidp USING(gwas_phenotypeID)" ,
                  " INNER JOIN Genes USING(geneID);")
} else {
  sqlcmd = paste0("SELECT gene, gene_name, gwas_phenotype, training_model, zscore, ", colnm,
                  " FROM (SELECT * FROM Parent WHERE geneID IN (SELECT geneID FROM Genes", 
                  " WHERE gene IN (", paste(shQuote(gns$V1, type = "sh"), collapse = ', '), 
                  ") OR gene_name IN (", paste(shQuote(gns$V1, type = "sh"), collapse = ', '),")))",
                  " INNER JOIN ",mtctbl," USING(mainID)", 
                  " INNER JOIN Tissue USING(training_modelID)", 
                  " INNER JOIN Nidp USING(gwas_phenotypeID)" ,
                  " INNER JOIN Genes USING(geneID);")
}





assoc = dbGetQuery(nimg, sqlcmd)
setDT(assoc)

tab_nm = paste0(otpt, nm, '_raw_assocs.txt')
write.table(assoc, file = tab_nm, append = FALSE, quote = FALSE, sep = "\t", eol = "\n", na = '0', dec = ".", row.names = FALSE, col.names = TRUE)


# iterate over all genes in the file


gns = setDT(read.table(fil, header = FALSE, stringsAsFactors = TRUE))
gn_nm = unique(gns$V1)
assoc_nm = unique(assoc$gene_name)
assoc_gn = unique(assoc$gene)
missed = gn_nm[!(gn_nm %in% assoc_nm | gn_nm %in% assoc_gn)]
if (length(missed) > 0 ) {
  print(paste('WARNING:', length(missed), 'genes in --', fil,'-- do not correspond to an NIDP'))
  print(missed)
}
# get total repeats and zscore stats for all NIDPs
allR = assoc[, .(N = .N, meanZ = mean(zscore), sdZ = sd(zscore)), by = c('gwas_phenotype')]
allR$ciZ = 1.96 * (allR$sdZ / sqrt(allR$N))

# get NIDP repeats across genes
gnR = assoc[, .(gn_ct = length(unique(gene_name)), GN_names = paste(as.list(unique(as.character(gene_name))), collapse = ", ")), by = c('gwas_phenotype')] 

# get NIDP repeats across training_models
tmR = assoc[, .(tm_ct = length(unique(training_model)), TM_names = paste(as.list(unique(as.character(training_model))), collapse = ", ")), by = c('gwas_phenotype')]

stats = setDT(merge(allR, gnR, by = 'gwas_phenotype'))
stats = setDT(merge(stats, tmR, by = 'gwas_phenotype'))

# Next, I need to sort these according to the mean Z-score

stats = stats[order(abs(stats$meanZ), decreasing = TRUE), ]

# Then to draw the lines of the two-sided 95% of the mean zscore to get the top 5% phenotypes by magnitude. 
qhigh = unname(quantile(abs(stats$meanZ), prob = c(0.025, .95)))[2]

p = ggplot(stats, aes(x = seq_along(meanZ), y = abs(meanZ))) +
  geom_point()+
  geom_errorbar( aes(x=seq_along(meanZ), ymin=abs(meanZ)-ciZ, ymax=abs(meanZ)+ciZ), width=0.2, colour="black", alpha=0.9, size=0.1) +
  theme_light()+
  #geom_hline(yintercept=qlow, colour="red") +
  #annotate("text", y=qlow, label='2.5th percentile\n', x= dim(stats)[1]/2, colour="blue") +
  geom_hline(yintercept=qhigh, colour="grey") +
  annotate("text", y=qhigh, label='95th percentile\n', x= dim(stats)[1]/2, colour="blue") +
  ggtitle(paste("scores of NIDPs associated with genes from", nm)) +
  ylab('Mean normalized prediction effect size') +
  xlab('Neuroimaging Derived Phenotypes (NIDPs)')


name = paste0(otpt, nm, '_rank.png')

png(filename = name, width = 800, height = 600, units = "px", pointsize = 12, bg = "white", type = 'cairo')
print(p)
dev.off()

# Print Brain regions for Desikan Atlas and subcortical regions. 
getlabel <- function(column) {
  column2 = lapply(column, str_remove, pattern='aparc-Desikan_')
  column3 = lapply(column2, str_remove, pattern = 'volume_')
  column4 = lapply(column3, str_remove, pattern = 'area_')
  column5 = lapply(column4, str_remove, pattern = 'thickness_')
  column5 = as.character(column5)
}

atl = as.character('Desikan')

atl_dir = data.table(source = c('Desikan', 'desikan', 'DKT', 'dktatlas', 'aparc', 'dkt', 'DKTatlas', 'a2009s', 'destrieux', 'Destrieux', 'aparc.a2009s'), 
                     fs_atlas = c('aparc', 'aparc', 'aparc', 'aparc', 'aparc', 'aparc', 'aparc', 'aparc.a2009s', 'aparc.a2009s', 'aparc.a2009s', 'aparc.a2009s'),
                     atl_name = c('Desikan', 'Desikan', 'DKTatlas', 'DKTatlas', 'Desikan', 'DKTatlas', 'DKTatlas', 'a2009s', 'a2009s', 'a2009s', 'a2009s'))

atlas = atl_dir[source == atl,fs_atlas]
atlnm = atl_dir[source == atl,atl_name]

fs_anno = fread('/Users/xbledsoe/fsbrain/fs_anno.txt', header = TRUE)
stat_vis = setDT(merge(stats, fs_anno, by = 'gwas_phenotype'))
#Subset the data that is of the correct atlas
print('subsetting data by atlas')
stat_vis = stat_vis[atlas == atlnm,-c('atlas', 'region')]

for (measure in c('volume', 'area', 'thickness')){
  
  stat_vis2 = stat_vis[gwas_phenotype %like% measure,]
  stat_vis2$label = as.character(getlabel(stat_vis2$gwas_phenotype))
  tt=ggplot(stat_vis2) +
    geom_brain(atlas = dk, 
               position = position_brain(side ~ hemi),
               aes(fill = meanZ)) +
    #scale_fill_viridis_c(option = "rocket", direction = 1) +
    scale_fill_gradient2(low = "darkred", mid = "white", high = "blue4") +
    theme_void() +
    labs(title = paste0("Neuroimaging transcriptomics for ", nm, ' (', measure, ')'))
  png(filename = paste0(otpt, nm, '_', measure, '_Desikan.png') , width = 500, height = 350, units = "px", pointsize = 12, bg = "white", type = 'cairo')
  print(tt)
  dev.off()
}







tab_nm = paste0(otpt, nm, '_NIDPstats.txt')
write.table(stats, file = tab_nm, append = FALSE, quote = FALSE, sep = "\t", eol = "\n", na = '0', dec = ".", row.names = FALSE, col.names = TRUE)


tops = setDT(merge(stats, anno, by = 'gwas_phenotype', sort = FALSE))
tops$sign = sign(tops$meanZ)

if (dim(tops)[1] > 45) {
  tops <- tops[order(abs(stats$meanZ), decreasing = TRUE), ][1:45,]
} 


name = paste0(otpt, nm, '_MeanZ.png')
p = ggplot(tops, aes(x = gwas_phenotype, y = abs(meanZ), color= secondary, group = as.character(sign))) +
  geom_point(aes(shape=as.character(sign)), size = 4) + #size=as.character(gn_ct))) +
  theme_light()+
  ggtitle(paste("Mean Effect Size per NIDP across\nall genes", '[', nm, ']')) +
  xlab('NIDPs') + 
  theme(axis.text.x = element_text(angle = 0, size = 11, hjust = 0.5, vjust =0.5),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(hjust = 0.5),
        plot.title.position = "plot",
  )+
  scale_shape_discrete(name  ="sign",
                       breaks=c("1", "-1"),
                       labels=c("pos", "neg")) +
  coord_flip()
#scale_size_discrete(name  ="gene count")

wid = max(100 + 21 * (dim(tops)[1]), 200)
#png(filename = name, width = wid, height = 600, units = "px", pointsize = 12, bg = "white", type = 'cairo')
png(filename = name, width = 800, height = wid, units = "px", pointsize = 12, bg = "white", type = 'cairo')
print(p)
dev.off()



if (var =='Y' | var == 'y') {
  for (gn in gns$V1) {
    single = assoc[gene_name == gn, ]
    allR1 = single[, .(N = .N, meanZ = mean(zscore), sdZ = sd(zscore)), by = c('gwas_phenotype')]
    tmR1 = single[, .(tm_ct = length(unique(training_model))), by = c('gwas_phenotype')]
    stats1 = merge(allR1, tmR1, by = 'gwas_phenotype')
    #stats1$Nscale = scale(stats1$N)
    stats1 = stats1[order(stats1$N, decreasing = TRUE), ]
    
    p1 = ggplot(stats1, aes(x = seq_along(N), y = N)) +
      geom_point()+
      theme_light()+
      #geom_hline(yintercept=1.645, colour="grey") +
      #annotate("text", y=1.645, label='95% one sided zscore\n', x= dim(stats1)[1]/2, colour="blue") +
      ggtitle(paste("Repeat counts of NIDPs associated with", gn))
    name = paste0(otpt, gn, '_rank.png')
    
    png(filename = name, width = 800, height = 600, units = "px", pointsize = 12, bg = "white", type = 'cairo')
    print(p1)
    dev.off()
    
    tab_nm1 = paste0(otpt, gn, '_NIDPstats.txt')
    write.table(stats1, file = tab_nm1, append = FALSE, quote = FALSE, sep = "\t", eol = "\n", na = '0', dec = ".", row.names = FALSE, col.names = TRUE)
    
  }
}

