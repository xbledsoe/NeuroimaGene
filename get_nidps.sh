#!/usr/bin/env bash

homefile=$0
home=${homefile%get*}

if [[ -f ${home}NeuroimaGenefast.db.gz ]]
	then  echo 'unzipping resource file';
	gunzip NeuroimaGenefast.db.gz;
	fi


echo -n "Enter file containing Genes or Ensmbl IDs_ "
read -r file

echo -n "Enter output directory_ "
read -r output
output=${output%*/}/

echo -n "Enter analysis tag_ "
read -r atag
atag=${atag:-noname}
clear

echo 'Imaging Features Selection'
echo '   ~~~~~~~~~~~~~~~~~'

PS3="Choose imaging modality and atlas:"
select mod in "All T1       --> all structural brain measures" \
    "T1: a2009s		--> structure: Destrieux cortical atlas" \
    "T1: AmygNuclei 	--> structure: Amygdalar nuclei" \
    "T1: aseg_volume	--> structure: Subcortical volumes" \
    "T1: Broadmann 	--> structure: Broadmann Areas" \
    "T1: Desikan		--> structure: Desikan Killiany cortical atlas" \
    "T1: DKTatlas 		--> structure: DKT cortical atlas" \
    "T1: FAST 		--> structure: FMRIB's Automated Segmentation Tool" \
    "T1: FIRST 		--> structure: FMRIB's Subcortical Segmentation Tool" \
    "T1: HippSubfield 	--> structure: Hippocampal subfields" \
    "T1: pial		--> structure: Desikan Killiany atlas of pial surface" \
    "T1: Brainstem		--> structure: Freesurfer brainstem parcellation" \
    "T1: SIENAX		--> structure: Sienax whole brain measures" \
    "T1: ThalamNuclei 	--> structure: Nuclei of the thalamus" \
    "all dMRI       --> all white matter tract measures" \
    "dMRI: ProbtrackX	--> white matter: probabilistic tractography" \
    "dMRI: TBSS		--> white matter: tract-based spatial statistics" \
    "rfMRI: ICA100	--> functional connectivity: 100 cortical seeds" \
    "rfMRI: ICA25	--> functional connectivity: 25 cortical seeds" \
    "rfMRI: ICA-features	--> summary compilations of functional connectivity" \
    "T2_FLAIR: BIANCA 	--> white matter: hyperintensity measures" \
    "T2star: SWI 	--> susceptibility-weighted imaging" \
    "All            --> all associations, including QC metrics" \
    "Quit"
do
    case $mod in
        "All T1       --> all structural brain measures")
            MOD=T1
            ATL=%
            typ=mod
            break;;
        "T1: a2009s		--> structure: Destrieux cortical atlas")
            MOD=T1
            ATL=a2009s
            typ=atl
            break;;
        "T1: AmygNuclei 	--> structure: Amygdalar nuclei")
            MOD=T1
            ATL=AmygNuclei
            typ=atl
            break;;
        "T1: aseg_volume	--> structure: Subcortical volumes")
            MOD=T1
            ATL=aseg_volume
            typ=atl
            break;;
        "T1: Broadmann 	--> structure: Broadmann Areas")
            MOD=T1
            ATL=Broadmann
            typ=atl
            break;;
        "T1: Desikan		--> structure: Desikan Killiany cortical atlas")
            MOD=T1
            ATL=Desikan
            typ=atl
            break;;
        "T1: DKTatlas 		--> structure: DKT cortical atlas")
            MOD=T1
            ATL=DKTatlas
            typ=atl
            break;;
        "T1: FAST 		--> structure: FMRIB's Automated Segmentation Tool")
            MOD=T1
            ATL=FAST
            typ=atl
            break;;
        "T1: FIRST 		--> structure: FMRIB's Subcortical Segmentation Tool")
            MOD=T1
            ATL=FIRST
            typ=atl
            break;;
        "T1: HippSubfield 	--> structure: Hippocampal subfields")
            MOD=T1
            ATL=HippSubfield
            typ=atl
            break;;
        "T1: pial		--> structure: Desikan Killiany atlas of pial surface")
            MOD=T1
            ATL=pial
            typ=atl
            break;;
        "T1: Brainstem		--> structure: Freesurfer brainstem parcellation")
            MOD=T1
            ATL=Brainstem
            typ=atl
            break;;
        "T1: SIENAX		--> structure: Sienax whole brain measures")
            MOD=T1
            ATL=SIENAX
            typ=atl
            break;;
        "T1: ThalamNuclei 	--> structure: Nuclei of the thalamus")
            MOD=T1
            ATL=ThalamNuclei
            typ=atl
            break;;
        "all dMRI       --> all white matter tract measures")
            MOD=dMRI
            ATL=%
            typ=mod
            break;;
        "dMRI: ProbtrackX	--> white matter: probabilistic tractography")
            MOD=dMRI
            ATL=ProbtrackX
            typ=atl
            break;;
        "dMRI: TBSS		--> white matter: tract-based spatial statistics")
            MOD=dMRI
            ATL=TBSS
            typ=atl
            break;;
        "rfMRI: ICA100	--> functional connectivity: 100 cortical seeds")
            MOD=dMRI
            ATL=ICA100
            typ=atl
            break;;
        "rfMRI: ICA25	--> functional connectivity: 25 cortical seeds")
            MOD=dMRI
            ATL=ICA25
            typ=atl
            break;;
        "rfMRI: ICA-features	--> summary compilations of functional connectivity")
            MOD=dMRI
            ATL=ICA-features
            typ=atl
            break;;
        "T2_FLAIR: BIANCA 	--> white matter: hyperintensity measures")
            MOD=dMRI
            ATL=BIANCA
            typ=atl
            break;;
        "T2star: SWI 	--> susceptibility-weighted imaging")
            MOD=dMRI
            ATL=SWI
            typ=atlas
            break;;
        "All            --> all associations, including QC metrics")
            MOD=%
            ATL=%
            typ=all
            break;;
        "Quit")
           exit;;
        *)
           echo "Input not received. Please use numerical menu codes 1-28";;
    esac
done

clear

echo 'Multiple Testing Correction'
echo '   ~~~~~~~~~~~~~~~~~'

PS3="Choose multiple testing threshold:"
select thresh in "FDR: False-Discovery Rate < 0.05 (Benjamini Hochberg)" \
    "BF: Strict Bonferroni Correction < 0.05" \
    "Nom: nominal p-value < 0.05 (no correction)" \
    "Quit"
do
    case $thresh in
        "FDR: False-Discovery Rate < 0.05 (Benjamini Hochberg)")
            mtc=BH
            break;;
        "BF: Strict Bonferroni Correction < 0.05")
           mtc=BF
           break;;
        "Nom: nominal p-value < 0.05 (no correction)")
           mtc=nom
           break;;
        "Quit")
           exit;;
        *)
           echo "Input not received. Please use numerical menu codes 1-4";;
    esac
done

echo "performing analyses..."


anno=${home}BIG40-IDPs_v4_discovery2_anno.tsv.gz
anno2=${home}fs_anno.txt

Rscript ${home}get_NIDPs_vis.r \
    -f $file \
    -r ${home}NeuroimaGenefast.db \
    -o $output \
    -g N \
    -m $MOD \
    -a $ATL \
    -p $mtc \
    -t $typ \
    -s $anno \
    -n $atag \
    -b $anno2




