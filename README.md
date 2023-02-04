## Background

This is the resource page for the NeuroimaGENE resource described in our paper "Neuroimaging Transcriptome Studies Inform Network Level Dysregulation in Neuropsychiatric Traits." This resource serves as a publicly accessible atlas detailing the associations between endogenous gene expression and brain anatomy and physiology. As detailed in the paper, we conduct Joint Tissue Imputation informed Transcriptome wide association studies via PrediXcan for the >3,500  genome wide association studies (GWAS) conducted by the UK BioBank (UKB) for MRI-derived measures of the brain. In doing so, we identify genetically regulated gene expression (GReX) and associate variation in GReX with neurologic measures ovserved on MRI imaging. The patients comprising the UKB neuroimaging study are 40-69 and were screened for overt neurologic pathology. To the best of their ability, they represent an adult population without neurologic disease. 

As such, NeuroimaGENE catalogues the neurologic consequences of lifelong exposure to increases or decreases in gene expression. 

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
The NeuroimaGENE resource can be accessed here on github. The directory is titled NeuroimaGENE_resource. Inside are a few files with the resource being NeuroimaGENE.txt.gz. This gzipped file contains the bonferroni significant associations between GReX and NIDPs according to each of 19 different tissue specific eQTL models derived from GTEx and enriched via JTI. 

### Basic command line usage
Having downloaded the datafile, it is possible to query the neuroimaGENE for NIDPs associated with GReX for a gene of interest through the following command. The text to change is in all caps ("GENE_1" and "OUTPUT_PATH/FILE"). The training_model pattern is to ensure that the header is included in the output file. 

	      zcat NeuroimaGENE.txt.gz | grep -w 'training_model\|GENE_1' > OUTPUT_PATH/FILE.txt
	
The command above will generate an output file detailing the associations. The contents are as follows

	gene: the Ensmble Gene ID
	gene_name: the HUGO gene name 
	zscore: The normalized effect size across all tested GRex-NIDP-tissue associations (most appropriate for comparison)
	effect_size: the raw value of the predicted effect size
	gwas_phenotype: the Neuroimaging Derived Phenotype as detailed by the UKB neuroimaging GWAS 
	training_model: the JTI-enriched tissue specific eQTL model in which the association is found
	bhpval: the benjamini-hochberg false-discovery rate corrected association pvalue
	
NIDP details can be found [here](https://www.fmrib.ox.ac.uk/ukbiobank/) and [here](https://www.fmrib.ox.ac.uk/ukbiobank/gwaspaper/index.html)

### Analytic Tools and built-in NIDP prioritization

Included in the NeuroimaGENE directory is a commandline tool for analysis of multiple genes (get_nidps.sh). This program takes as input a file of genes (HUGO gene names or ensembl id's). Provided with a targeted subset of NIDPs and a multiple testing threshold correction, the script generates txt files containing the NIDPs implicated by the provided list of genes as well as graphs providing visual representations of the association data. 

This script and the data it generates are designed to identify instances in which dysexpression of multiple genes of interest converge upon related neurologic aspects. For example, one might expect multiple genes associated with distractiability to converge upon the executive network of the brain. Running get_nidps.sh on a set of genes associated with distractability will display the set of NIDPs predicted to be most different from baseline in the presence of altered expression of the input genes. The text file will indicate the number and identity of trait-associated genes associated with each NIDP. It will also detail the number and identity of the training models in which these associations were found to be significant. 

In the process of using the tool, the user is responsible for selecting a subset of NIDPs from the resource for analysis. The options provided in the commandline tool are detailed below. 

|MRI modality| atlas name | Description | source | 
| --- | --- | --- | --- | 
|T1 | all | All measures recorded by the UKB neuroimaging study derived from T1 imaging| see note\*|
|T1 |a2009s | Destrieux atlas parcellation of cortical sulci and gyri | [Destrieux](https://doi.org/10.1016/j.neuroimage.2010.06.010) |
|T1 |AmygNuclei | morphology of Nuclei of the amygdala | [Amygdala nuclei](https://doi.org/10.1016/j.neuroimage.2017.04.046)|
|T1 |aseg_volume | subcortical volumetric segmentation | [aseg_volume](https://doi.org/10.1016/S0896-6273(02)00569-X)|
|T1 | Broadmann | cortical morphology via Broadmann Areas | [Broadmann](https://doi.org/10.1093/cercor/bhm225)|
|T1 | Desikan | Desikan Killiany atlas parcellation of cortical morphology | [Desikan](https://doi.org/10.1016/j.neuroimage.2006.01.021)|
|T1 | DKTatlas | DKT atlas parcellation of cortical morphology | [DKTatlas](https://doi.org/10.3389/fnins.2012.00171)|
|T1 | FAST | cortical morphology via FMRIB's Automatic Segmentation Tool | [FAST](https://doi.org/10.1109/42.906424)|
|T1 | FIRST | Subcortical morphologogy via FIRST | [FIRST](https://doi.org/10.1016/j.neuroimage.2011.02.046)|
|T1 | HippSubfield | morphology of Hippocampal subfields | [HippSubfield](https://doi.org/10.1016/j.neuroimage.2015.04.042)|
|T1 | pial | structure: Desikan Killiany atlas of the pial surface | [Desikan](https://doi.org/10.1016/j.neuroimage.2006.01.021)|
|T1 | Brainstem | structure: Freesurfer brainstem parcellation | [Brainstem](https://doi.org/10.1016/j.neuroimage.2015.02.065)|
|T1 | SIENAX | structure: Structural Image Evaluation of whole brain measures | [SIENAX](https://doi.org/10.1006/nimg.2002.1040)|
|T1 | ThalamNuclei | morphology of the Nuclei of the thalamus | [ThalamNuclei](https://doi.org/10.1038/s41597-021-01062-y)|
|dMRI | all | All measures recorded by the UKB neuroimaging study derived from DWI imaging| see note\*|
|dMRI | ProbtrackX | white matter mapping obtained via probabilistic tractography | [ProbtrackX](https://doi.org/10.1371/journal.pone.0061892)\*|
|dMRI | TBSS | white matter mapping obtained via tract-based spatial statistics	 | [TBSS](https://doi.org/10.1016/j.neuroimage.2006.02.024)\*|
|rfMRI | ICA100 | functional connectivity using 100 cortical seeds | see note\*|
|rfMRI |ICA25 | functional connectivity using 25 cortical seeds | see note\*|
|rfMRI |ICA-features | summary of functional connectivity components | see note\*|
|T2_FLAIR | BIANCA | white matter hyperintensity classification algorithm | [BIANCA](https://doi.org/10.1016%2Fj.neuroimage.2016.07.018)|
|T2star | SWI | susceptibility-weighted imaging: microhemorrhage and hemosiderin deposits | see note\*|

\* see original publication for details [here](https://doi.org/10.1016/j.neuroimage.2017.10.034) (Alfaro-Almagro, Fidel, et al. "Image processing and Quality Control for the first 10,000 brain imaging datasets from UK Biobank." Neuroimage 166 (2018): 400-424.)


Packages and dependencies required to run this script are listed at the bottom of this subsection.

This Rscript requires the following parameters

INPUT_GENES.txt: A .txt file containing a single column of HUGO gene names or ensembl ids with no header
OUTPUT_DIR: a directory in which the output from the analysis can be deposited
NAME: a short descriptive name to mark the analysis (eg. parknsn_genes if studying Parkinson's)
PATH : path to the downloaded NeuroimaGENE resource directory. 

Run the script with the following commands customized for your genes of interest and directories

	Rscript PATH/Get_NIDPs.r \
		-i INPUT_GENES.txt \
		-o OUTPUT_DIR \
		-n NAME \
		-p PATH/
		
An additional flag is the **-g** flag for genes. include **-g y** in the Rscript command, you will receive a text file and png figure for each individual gene detailing the top associated NIDPs in addition to the full set of NIDPs. 
 

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

>Please direct all questions to me at the following email: xbledsoe22@gmail.com


	

	
	


	



