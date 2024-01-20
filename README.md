## Background

This is the resource page for the NeuroimaGene resource described in our paper "Neuroimaging Transcriptome Studies Inform Network Level Dysregulation in Neuropsychiatric Traits." This resource serves as a publicly accessible atlas detailing the associations between endogenous gene expression and brain anatomy and physiology. As detailed in the paper, we conduct Joint Tissue Imputation informed Transcriptome wide association studies via PrediXcan for the >3,500  genome wide association studies (GWAS) conducted by the UK BioBank (UKB) for MRI-derived measures of the brain. In doing so, we identify genetically regulated gene expression (GReX) and associate variation in GReX with neurologic measures ovserved on MRI imaging. The patients comprising the UKB neuroimaging study are 40-69 and were screened for overt neurologic pathology. To the best of their ability, they represent an adult population without neurologic disease. 

As such, NeuroimaGENE catalogues the neurologic consequences of lifelong exposure to increases or decreases in gene expression. 

Before continuing, a little terminology. 

	GWAS  - Genome Wide Association Study
	TWAS  - Transcriptome Wide Association Study
	GReX  - Genetically regulated gene expression
	JTI   - Joint Tissue Imputation (link)
	NIDP  - Neuroimaging Derived Phenotype
	MRI   - Magnetic resonance imaging
	T1   - MRI modality classically used for structural characterization of the brain
	dMRI  - diffusion weighted MRI (used in our data for white matter tractography)
	fMRi  - functional MRI used for examining coordinated activity across regions of the brain 
	UKB   - United Kingdom Biobank
	eQTL  - expression Quantitative Trait Locus
	GTEx  - Genotype Tissue Expression Consortium
	

#### Associated Papers for further reading

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

Included in the NeuroimaGENE directory is a commandline tool for analysis of multiple genes (get_nidps.sh). This program takes as input a file of genes (HUGO gene names or ensembl id's). The script generates .txt files containing the NIDPs implicated by the provided list of genes as well as graphs providing visual representations of the association data. 

This script and the data it generates are designed to identify instances in which dysexpression of multiple genes of interest converge upon related neurologic aspects. For example, one might expect multiple genes associated with distractiability to converge upon the executive network of the brain. Running get_nidps.sh on a set of genes associated with distractability will display the set of NIDPs predicted to be most different from baseline in the presence of altered expression of the input genes. The text file will indicate the number and identity of trait-associated genes associated with each NIDP. It will also detail the number and identity of the training models in which these associations were found to be significant (according to the provided multiple testing threshold). 

#### NIDP selection for gene set analysis

In the process of using the tool, the user is responsible for selecting a subset of NIDPs from the resource for analysis. These NIDPs represent different types of brain measures such as hippocampal subfields, area and thickness of named cortical regions, fractional anisotropy of named white matter tracts etc. It is recommended to identify the type of brain measure one is interested in prior to performing the gene set analysis.  **The options provided in the commandline tool are detailed in the dropdown table below.**

<details><summary>NIDP atlas descriptions and source links</summary>
<p>

|MRI modality| atlas name | Number of NIDPs |Description | source | 
| --- | --- | --- | --- | --- |
|T1 | all | 1319 | All measures recorded by the UKB neuroimaging study derived from T1 imaging| see note\*|
|T1 | a2009s | 444 | Destrieux atlas parcellation of cortical sulci and gyri | [Destrieux](https://doi.org/10.1016/j.neuroimage.2010.06.010) |
|T1 | AmygNuclei | 20 | morphology of Nuclei of the amygdala | [Amygdala nuclei](https://doi.org/10.1016/j.neuroimage.2017.04.046)|
|T1 | aseg_volume | 52 | subcortical volumetric segmentation | [aseg_volume](https://doi.org/10.1016/S0896-6273(02)00569-X)|
|T1 | Broadmann | 84 | cortical morphology via Broadmann Areas | [Broadmann](https://doi.org/10.1093/cercor/bhm225)|
|T1 | Desikan | 202 | Desikan Killiany atlas parcellation of cortical morphology | [Desikan](https://doi.org/10.1016/j.neuroimage.2006.01.021)|
|T1 | DKTatlas | 186 | DKT atlas parcellation of cortical morphology | [DKTatlas](https://doi.org/10.3389/fnins.2012.00171)|
|T1 | FAST | 139 | cortical morphology via FMRIB's Automatic Segmentation Tool | [FAST](https://doi.org/10.1109/42.906424)|
|T1 | FIRST | 15 | Subcortical morphologogy via FIRST | [FIRST](https://doi.org/10.1016/j.neuroimage.2011.02.046)|
|T1 | HippSubfield | 44 | morphology of Hippocampal subfields | [HippSubfield](https://doi.org/10.1016/j.neuroimage.2015.04.042)|
|T1 | pial | 66 | structure: Desikan Killiany atlas of the pial surface | [Desikan](https://doi.org/10.1016/j.neuroimage.2006.01.021)|
|T1 | Brainstem | 5 | structure: Freesurfer brainstem parcellation | [Brainstem](https://doi.org/10.1016/j.neuroimage.2015.02.065)|
|T1 | SIENAX | 10 |structure: Structural Image Evaluation of whole brain measures | [SIENAX](https://doi.org/10.1006/nimg.2002.1040)|
|T1 | ThalamNuclei | 52 | morphology of the Nuclei of the thalamus | [ThalamNuclei](https://doi.org/10.1038/s41597-021-01062-y)|
|dMRI | all | 675 | All measures recorded by the UKB neuroimaging study derived from DWI imaging| see note\*|
|dMRI | ProbtrackX | 243 | white matter mapping obtained via probabilistic tractography | [ProbtrackX](https://doi.org/10.1371/journal.pone.0061892)\*|
|dMRI | TBSS | 432 | white matter mapping obtained via tract-based spatial statistics	 | [TBSS](https://doi.org/10.1016/j.neuroimage.2006.02.024)\*|
|rfMRI | ICA100 | 1485 | functional connectivity using 100 cortical seeds | see note\*|
|rfMRI | ICA25 | 210 | functional connectivity using 25 cortical seeds | see note\*|
|rfMRI | ICA-features | 6 | summary of functional connectivity components | see note\*|
|T2_FLAIR | BIANCA | 1 | white matter hyperintensity classification algorithm | [BIANCA](https://doi.org/10.1016%2Fj.neuroimage.2016.07.018)|
|T2star | SWI | 14 | susceptibility-weighted imaging: microhemorrhage and hemosiderin deposits | see note\*|

\* see original publication for details [here](https://doi.org/10.1016/j.neuroimage.2017.10.034) (Alfaro-Almagro, Fidel, et al. "Image processing and Quality Control for the first 10,000 brain imaging datasets from UK Biobank." Neuroimage 166 (2018): 400-424.)

</p>
</details>

#### Selecting an appropriate Multiple Testing Correction for statistical significance. 
In addition to selecting the set of NIDPs, get_nidps.sh requires a multiple testing threshold correction. Each imaging modality contains a different number of NIDPs (see table above). The Bonferroni correction treats each of these NIDPs as independent even though we know through significant data analyses that this is not true. This is a highly conservative threshold that will yield high confidence associations but is likely to generate many false negatives. Recognizing the interrelatedness of brain measures from the same modality and atlas, we recommend using the less stringent  Benjamini Hochberg False discovery rate for discovery analyses. In instances where the GReX-NIDP association is alread identified, a nominal pvalue greater than 0.05 may be appropriate for replication. 

 **PLEASE NOTE: the Bonferroni and Benjamini-hochberg analyses take into account all ~22,000 available genes. The commandline script does NOT recalculate multiple testing corrections based on the set of genes provided by the user.** For the BF and fdr corrections, the null hypothesis for each gene test is the set of ALL other genes, potentially including the other genes in the gene set provided by the user. It may be possible to obtain a marginal increase in power by testing the genes in the gene set against a null distribution of the genes *not* in the user-provided gene set. This type of analysis requires accessing the larger, unthresholded datasets stored on our Zenodo repository and is also more computationally demanding. For instructions on accessing these data and performing gene-set specific significance analyses please see this page. 

The full set of associations in raw text form is a little cumbersome (~2.5 GB) and can be found as a gzipped file within the downloaded folder titled "NeuroimaGene.txt"  

### Using the commandline tools 

We include two commandline tools in the provided resource. The first is a simple script named get.sh. This can be used to preview neuroimaging measures that are associated with a single gene at a user-provided significance level. It is not intended as a primary research tool and does not return any interactable files. Instead, it is intended as a means to check the resource for a gene of interest and to familiarize oneself with the resource prior to more in-depth analyses. To run the script, navigate to the resource directory in the commandline and run the following command:

	bash get.sh
	
The script will prompt the user for four pieces of information. 

	(1) the name of the gene (ensembl ID or HUGO gene name); 
	(2) the subset of Neuroimaging features to be queried, 
	(3) the multiple testing correction by which p-values should be adjusted for significance filtering 
		(Only associations with adjusted p-values less than 0.05 will be returned.) 
	(4) The number of results the user wishes to preview in raw tabular form. (3-10 recommended)

Upon receipt of these data, the program will select the subset of significant GReX-neuroimaging associations that fit the user's criteria for the gene in question. It will print a preview of these associations to the terminal in accordance with the number of requested lines from prompt 4. below the data preview, the script provides a number of descriptive statistics about the gene in question and it's associations with the queried neuroimaging features. 

_____________________________________________

The second script is designed for a richer analytic approach. Using similar commandline prompts, it takes as input a list of genes and identifies the neuroimaging measures most strongly associated with that set of genes. It returns a text file with the identified associations as well as a visual representation of the NIDPs most heavily associated with the gene set, annotated by brain regions. 

To use get_nidps.sh, run the following command in terminal:
	
	bash /PATH/get_nidps.sh 

The script will provide five prompts in sequence. 

1. "Enter file containing Genes or Ensmbl IDs_ "	*paste or write path and filename of genes for query* 
2. "Enter output directory_ " 	*paste or write path to output directory*
3. "Enter analysis tag_ "	*select short descriptive tag for analysis*
4. "Choose imaging modality:"	*select imaging modality and atlas from dropdown menu*
5. "Choose multiple testing threshold:"	*select preferred multiple testing correction from dropdown menu*

The script will feed the provided data into an R analysis pipeline and deposit the resulting data into a file titled "[your tag here]NIDPs" in the provided output directory. 

Alternatively, you may run the R-script directly providing the following parameters

- INPUT_GENES.txt: A .txt file containing a single column of HUGO gene names or ensembl ids with no header
- RESOURCE: The path and name of the NeuroimaGenefast.db file (included in the home directory)
- OUTPUT_DIR: a directory path to which the output from the analysis should be deposited
- NAME: a short descriptive name to mark the analysis (eg. parknsn_genes if studying Parkinson's)
- MODALITY: the modality of the queried neuroimaging set (T1, dMRI, rfMRI etc.) \[required if type not 'all']
- ATLAS: the atlas of the queried neuroimaging set \[required if type = 'atl']
- TYPE: the type of data subset ('atl' for an atlas-defined subset, 'mod' for modality-defined subset, or 'all')
- PVALUE: P-value Multiple Testing Correction ("BH" for Benjamini Hochberg FDR, "BF" for Bonferroni, "nom" for nominal)
- PATH: path to the downloaded NeuroimaGENE resource directory. 

Run the script with the following commands customized for your genes of interest and directories.
	 

	Rscript PATH/get_NIDPs_vis.r \
		-f INPUT_GENES.txt \
		-r PATH/NeuroimaGenefast.db
		-o OUTPUT_DIR \
		-n NAME \
		-m MODALITY \
		-a ATLAS \
		-t TYPE \
		-p PVALUE \
		-s /PATH/BIG40-IDPs_v4_discovery2_anno.tsv \
  		-b /PATH/fs_anno.txt
		
An additional flag is the **-g** flag for genes. include **-g y** in the Rscript command, you will receive a text file and png figure for each individual gene detailing the top associated NIDPs for that gene in addition to typical the full analysis for the aggregate set of NIDPs. 
 

### TUTORIAL
Within the NeuroimaGene directory is a tutorial directory for practice running the script. The data are derived from the following paper [Mishra et al, Nature 2022](https://doi.org/10.1038/s41586-022-05165-3) in which the authors use TWAS to identify several genes whose GReX is associated with stroke. Here we assess for structural MRI phenotypes from the Desikan Atlas associated with dysexpression of the prioritized genes. You can run the tutorial via the following commands requiring only the PATH of the downloaded directory. 

	bash /PATH/get_nidps.sh
		=> "Enter file containing Genes or Ensmbl IDs_ " PATH/tutorial/tutorial_gns.tx
		=> "Enter output directory_ " PATH/tutorial/
		=> "Enter analysis tag_ " stroke_gns
		=> "Choose imaging modality:" (1)
		=> "Choose multiple testing threshold:" (1)
	
Results should be generated and deposited in the following directory: PATH/tutorial/stroke_gns_NIDPs

Alternatively, you may run the program directly from the Rscript as shown below.

	Rscript PATH/get_NIDPs_vis.r \
	-f /PATH/tutorial/tutorial_gns.txt
	-r /PATH/NeuroimaGenefast.db
	-o /PATH/tutorial/
	-n stroke_gns
	-m 'T1' \
	-a 'Desikan' \
	-t 'atl' \
	-p 'BH' \
	-s /PATH/BIG40-IDPs_v4_discovery2_anno.tsv \
 	-b /PATH/fs_anno.txt
	
Amongst the other data generated, this should generate the following figure detailing NIDPs on the y axis and the mean normalized effect size magnitude on the x axis with color and shape detailing brain region descriptors and direction of effect respectively. There are 3 additional plots showing the mean normalized effect size of the genes on the brain regions characterized by the Desikan atlas divided into volume, surface area, and thickness. As stated above, detailed information concerning the naming of the NIDPs is available the the [UKB online neuroimaging portal.](https://www.fmrib.ox.ac.uk/ukbiobank/) 

![stroke_gns_MeanZ (2)](https://user-images.githubusercontent.com/62114350/218187084-e1dcc8b2-e8a1-478f-9265-8c8999eff503.png)

![tutorial_T1bhDes_volume_Desikan](https://github.com/xbledsoe/NeuroimaGene/assets/62114350/434f4815-fa4e-4db0-ae39-6f2a2db7ee88)
![tutorial_T1bhDes_area_Desikan](https://github.com/xbledsoe/NeuroimaGene/assets/62114350/e438bc48-4a94-42e1-a87c-39f2906cd583)
![tutorial_T1bhDes_thickness_Desikan](https://github.com/xbledsoe/NeuroimaGene/assets/62114350/75a45c6a-f9c0-4d88-97e4-20724f2caf3e)


### software package details
R version 4.0.5 (2021-03-31) [download here](https://cran.r-project.org) 

data.table R package [download here](https://rdatatable.gitlab.io/data.table/)

ggplot R package [download here](https://ggplot2.tidyverse.org/)

optparse R package [download here](https://github.com/trevorld/r-optparse)

DBI R package [download here](https://cran.r-project.org/web/packages/DBI/index.html)

>Please direct all questions to me at the following email: xbledsoe22@gmail.com


	

	
	


	



