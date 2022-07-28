## Background

This is the resource page for the NeuroimaGENE resource described in our paper "Neuroimaging Transcriptome Studies Inform Network Level Dysregulation in Neuropsychiatric Traits." This resource serves as a publicly accessible atlas detailing the associations between endogenous gene expression and brain anatomy and physiology. As detailed in the paper, we conduct Joint Tissue Imputation informed Transcriptome wide association studies via S-PrediXcan for the >3,000  genome wide association studies (GWAS) conducted by the UK BioBank (UKB) for MRI-derived measures of the brain. In doing so, we identify genetically regulated gene expression (GReX) and associate variation in GReX with neurologic measures ovserved on MRI imaging. The patients comprising the UKB neuroimaging study are 40-69 and were screened for overt neurologic pathology. To the best of their ability, they represent an adult population without neurologic disease. 

As such, we posit that NeuroimaGENE as a resource details the neurologic consequences of lifelong exposure to increases or decreases in gene expression. 

Before continuing, a little terminology. 

	GWAS  - Genome Wide Association Study
	
	TWAS  - Transcriptome Wide Association Study
	
	GReX  - Genetically regulated gene expression
	
	JTI   - Joint Tissue Imputation (link)
	
	NIDP  - Neuroimaging derived Phenotype
	
	MRI   - Magnetic resonance imaging
	
	T1   - MRI modality classically used for structural characterization of the brain
	
	dMRI  - diffusion weighted MRI (used in our data for white matter tractography)
	
	UKB   - United Kingdom biobank
	
	eQTL  - expression Quantitative trait locus
	
	GTEx  - Genotype Tissue Expression Consortium
	

#### Associated Papers

Barbeira, Alvaro N., et al. "Exploring the phenotypic consequences of tissue specific gene expression variation inferred from GWAS summary statistics." Nature communications 9.1 (2018): 1-20.

Zhou, Dan, et al. "A unified framework for joint-tissue transcriptome-wide association and Mendelian randomization analysis." Nature genetics 52.11 (2020): 1239-1246.

Miller, Karla L., et al. "Multimodal population brain imaging in the UK Biobank prospective epidemiological study." Nature neuroscience 19.11 (2016): 1523-1536.

Elliott, Lloyd T., et al. "Genome-wide association studies of brain imaging phenotypes in UK Biobank." Nature 562.7726 (2018): 210-216.

Gamazon, Eric R., et al. "Multi-tissue transcriptome analyses identify genetic mechanisms underlying neuropsychiatric traits." Nature genetics 51.6 (2019): 933-940.

## Using the Resource

#### Accessing the resource
The NeuroimaGENE resource can be accessed here on github. The directory is titled NeuroimaGENE_resource. Inside are a few files with the resource being NeuroimaGENE.txt.gz. This gzipped file contains the bonferroni significant associations between GReX and NIDPs according to each of 17 different tissue specific eQTL models derived from GTEx and enriched via JTI. 

#### Basic command line usage
Having downloaded the datafile, it is possible to query the neuroimaGENE for NIDPs associated with GReX for a gene of interest through the following command. The text to change is in all caps ("GENE_1" and "OUTPUT_PATH/FILE"). The training_model pattern is to ensure that the header is included in the output file. 

	      zcat NeuroimaGENE.txt.gz | grep -w 'training_model\|GENE_1' > OUTPUT_PATH/FILE.txt
	
The command above will generate an output file detailing the associations. The contents are as follows

	gene: the Ensmble Gene ID
	gene_name: the HUGO gene name 
	gwas_phenotype: the Neuroimaging Derived Phenotype as detailed by the UKB neuroimaging GWAS 
	zscore: The normalized effect size across all tested GRex-NIDP-tissue associations (most appropriate for comparison)
	effect_size: the raw value of the predicted effect size
	BF_pvalue: the bonferroni corrected association pvalue
	training_model: the JTI-enriched tissue specific eQTL model in which the association is found
	
NIDP details can be found [here](https://www.fmrib.ox.ac.uk/ukbiobank/) and [here](https://www.fmrib.ox.ac.uk/ukbiobank/gwaspaper/index.html) )

#### Analytic Tools and built-in NIDP prioritization

Included in the NeuroimaGENE directory is an Rscript for analysis of multiple genes. This program takes as input a file of HUGO gene names. Packages and dependencies required to run this script are below: 
	R version 4.0.5 (2021-03-31) [download here](https://cran.r-project.org)
	data.table R package [download here](https://rdatatable.gitlab.io/data.table/)
	ggplot R package [download here](https://ggplot2.tidyverse.org/)
	optparse R package [download here](https://github.com/trevorld/r-optparse)


	

	
	


	



