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
	fMRi  - functional MRI used for examining coordinated activity across regions of the brain 
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

### Accessing the resource
The NeuroimaGENE resource can be accessed here on github. The directory is titled NeuroimaGENE_resource. Inside are a few files with the resource being NeuroimaGENE.txt.gz. This gzipped file contains the bonferroni significant associations between GReX and NIDPs according to each of 17 different tissue specific eQTL models derived from GTEx and enriched via JTI. 

### Basic command line usage
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
	
NIDP details can be found [here](https://www.fmrib.ox.ac.uk/ukbiobank/) and [here](https://www.fmrib.ox.ac.uk/ukbiobank/gwaspaper/index.html)

### Analytic Tools and built-in NIDP prioritization

Included in the NeuroimaGENE directory is an Rscript for analysis of multiple genes. This program takes as input a file of HUGO gene names. As output, it generated txt files containing the top 5% of NIDPs implicated by the provided list of genes as well as graphs that provide visual representations of the association data. Packages and dependencies required to run this script are listed at the bottom of this subsection.

This Rscript requires the following parameters

INPUT_GENES.txt: A .txt file containing a single column of HUGO gene names with no header
OUTPUT_DIR: a directory in which the output from the analysis can be deposited
NAME: a short descriptive name to mark the analysis (eg. parknsn_genes if studying Parkinson's)
PATH : path to the downloaded NeuroimaGENE resource directory. 

Run the script with the following commands customized for your genes of interest and directories

	Rscript PATH/Get_NIDPs.r \
		-i INPUT_GENES.txt \
		-o OUTPUT_DIR \
		-n NAME \
		-p PATH/
		
An additional flag is the **-g** flag for genes. include **-g y** in the Rscript command, you will receive a text file and png figure for each individual gene detailing the top associated NIDPs in addition to the overal top 5% of NIDPs. 

It is worth noting here that we select the top 5% of NIDPs according to mean normalized effect size as a filtering method based on convenience rather than statistical significance. Every association in the NeuroimaGENE file satisfied a strict Bonferroni significance threshold. While each is significant the magnitude of impact is often exceedingly small. We select the top 95th percentile of significant associations according to mean normalized effect size because these are the most impactful of the predictive results. 

#### tutorial data
Within the Neuroimagene directory is an example template. This is meant to be run as a tutorial. You can run the tutorial via the following script requiring only the PATH of the downloaded directory. 

	Rscript PATH/GetNIDPs.r \
	-i PATH/gns.txt
	-o PATH/testdir/
	-n test_data
	-p PATH/
	-g y

Amongst the other data generated, this should generate the following figure detailing NIDPs on the x axis and the mean normalized effect size magnitude on the y axis with color and shape detailing MRI modality and direction of effect respectively. As stated above, detailed information concerning the naming of the NIDPs is available the the [UKB online neuroimaging portal.](https://www.fmrib.ox.ac.uk/ukbiobank/) 

![test_data_tops_MeanZ](https://user-images.githubusercontent.com/62114350/181631306-b42d3755-0550-4077-bcc8-a20ddc516934.png)


### software package details
R version 4.0.5 (2021-03-31) [download here](https://cran.r-project.org) 

data.table R package [download here](https://rdatatable.gitlab.io/data.table/)

ggplot R package [download here](https://ggplot2.tidyverse.org/)

optparse R package [download here](https://github.com/trevorld/r-optparse)




	

	
	


	



