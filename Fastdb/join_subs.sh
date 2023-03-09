cd /gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets


awk -v OFS='\t' 'NR=1 {print $1, $6, $7, $8}' /gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets/all_assocs_33K_T2star_BHsig.txt > ./NeuroimaGene/BHmods.txt
for mod in $(ls ./*BHsig*.txt ) ;
do
    echo $mod
    awk -v OFS='\t' 'NR>1 {print $1, $6, $7, $8}' $mod >> ./NeuroimaGene/BHmods.txt
done


awk -v OFS='\t' 'NR=1 {print $1, $6, $7, $8}' /gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets/all_assocs_33K_T2star_BFsig.txt  > ./NeuroimaGene/BFmods.txt
for mod in $(ls ./*BFsig*.txt ) ;
do
    echo $mod
    awk -v OFS='\t' 'NR>1 {print $1, $6, $7, $8}' $mod >> ./NeuroimaGene/BFmods.txt
done



awk -v OFS='\t' 'NR=1 {print $1, $6, $7, $8}' /gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets/atl/all_assocs_33K_rfMRI_ICA100_BHsig.txt > ./NeuroimaGene/BHatls.txt
for mod in $(ls ./atl/*BHsig*.txt ) ;
do
    echo $mod
    awk -v OFS='\t' 'NR>1 {print $1, $6, $7, $8}' $mod >> ./NeuroimaGene/BHatls.txt
done


awk -v OFS='\t' 'NR=1 {print $1, $6, $7, $8}' /gpfs52/data/g_gamazon_lab/xbledsoe/PhD-work/NeuroimaGENE/Analysis/NG_subsets/atl/all_assocs_33K_rfMRI_ICA100_BFsig.txt > ./NeuroimaGene/BFatls.txt
for mod in $(ls ./atl/*BFsig*.txt ) ;
do
    echo $mod
    awk -v OFS='\t' 'NR>1 {print $1, $6, $7, $8}' $mod >> ./NeuroimaGene/BFatls.txt
done


