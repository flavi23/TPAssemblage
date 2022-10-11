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

while true; do
    read -p "Voulez vous lancer une analyse Nanoplot (O/N)?"on
    case $on in
        [Oo]* ) 
        spin &
        pid=$!;
        NanoPlot --fastq "${read}" -f png -o ./"${prefix}_out_nanoplot";
        kill $pid > /dev/null 2>&1;
        break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
  
while true; do
    read -p "Voulez vous lancer un assemblage Flye (O/N)?" on
    case $on in
        [Oo]* ) 
        spin &
        pid=$!;
        flye --nano-hq "${read}" -t 8 --out-dir ./"${prefix}_out_flye";
        kill $pid > /dev/null 2>&1;
        break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Voulez vous lancer un assemblage Raven (O/N)?" on
    case $on in
        [Oo]* ) 
        spin &
        pid=$!;
        raven -t 8 "${read}" > "${prefix}_raven".fasta 
        if [ ! -d "${prefix}_out_raven" ];then
                mkdir "${prefix}_out_raven";
        fi
        mv ${prefix}_raven.fasta /${prefix}_out_raven;
        kill $pid > /dev/null 2>&1; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

mkdir ${prefix}_out_polishing
minimap2 -x map-ont "${prefix}_out_flye/assembly.fasta" "${read}" > "${prefix}_out_polishing/${prefix}_1.paf"
racon "${read}" "${prefix}_out_polishing/${prefix}_1.paf" "${prefix}_out_flye/assembly.fasta" > "${prefix}_out_polishing/${prefix}_racon1.fasta"

for n in {2..3};
do
  minimap2 -x map-ont "${prefix}_out_polishing/${prefix}_racon${j}.fasta" "${read}" > "${prefix}_out_polishing/${prefix}_${n}.paf" 
  racon "${read}" "${prefix}_out_polishing/${prefix}$_{n}.paf" ${prefix}_out_polishing/"${prefix}_racon${j}.fasta" > "${prefix}_out_polishing/${prefix}_racon${n}.fasta"
  ((j=j+1))
done
kill $pid > /dev/null 2>&1
