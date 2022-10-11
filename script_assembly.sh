#!/bin/bash

i=$@
j=1
read=${i}
prefix=${read%.fastq.gz}

spin(){
        sp='/-\|'
        printf ' '
        while true; do
                printf '\b%.1s' "$sp"
                sp=${sp#?}${sp%???}
                sleep 0.1
        done
        }
spin &
pid=$!

while true; do
    read -p "Voulez vous lancer une analyse Nanoplot (O/N)?"on
    case $on in
        [Oo]* ) 
        NanoPlot --fastq "${read}" -f png -o ./"${prefix}_out_nanoplot"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
  
while true; do
    read -p "Voulez vous lancer un assemblage Flye (O/N)?" on
    case $on in
        [Oo]* ) 
        flye --nano-hq "${read}" -t 8 --out-dir ./"${prefix}_out_flye"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Voulez vous lancer un assemblage Raven (O/N)?" on
    case $on in
        [Oo]* ) 
        raven -t 8 "${read}" > "${prefix}_raven".fasta
        mkdir "${prefix}_out_raven"
         mv "${prefix}_raven".fasta "${prefix}_out_raven"/; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

minimap2 -x map-ont "${prefix}_out_flye/assembly.fasta" "${read}" > "${prefix}_1.paf"
racon "${read}" "${prefix}1.paf" "${prefix}_out_flye/assembly.fasta" > "${prefix}_racon1.fasta"

for n in {2..3};
do
  minimap2 -x map-ont "${prefix}_racon${j}.fasta" "${read}" > "${prefix}_${n}.paf" 
  racon "${read}" "${prefix}${n}.paf" "${prefix}_racon${j}.fasta" > "${prefix}_racon${n}.fasta"
  ((j=j+1))
done
kill $pid > /dev/null 2>&1
