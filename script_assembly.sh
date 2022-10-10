premier_tour=1
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

NanoPlot --fastq "${read}" -f png -o ./"${prefix}_out_nanoplot"

flye --nano-hq "${read}" -t 8 --meta --out-dir ./"${prefix}_out_flye"

raven -t 8 "${read}" > "${prefix}_raven".fasta
mkdir "${prefix}_out_raven"
mv "${prefix}_raven".fasta "${prefix}_out_raven"/

for n in {1..3};
do
  if [[ "${premier_tour}" == 1 ]]; then
    minimap2 -o "${prefix}${n}.paf" -x map-ont "${prefix}_out_flye/assembly.fasta" "${read}"
    racon "${read}" "${prefix}${n}.paf" "${prefix}_out_flye/assembly.fasta" > "${prefix}_racon${n}.fasta"
    premier_tour=0
  fi
  if [[ "${premier_tour}" == 0 ]]; then
    minimap2 -o "${prefix}${j}.paf" -x map-ont "${prefix}_racon${j}.fasta" "${read}"
    racon "${read}" "${prefix}${j}.paf" "${prefix}_racon${j}.fasta" > "${prefix}_racon${n}.fasta"
  fi
  j="${n}"
done
kill $pid > /dev/null 2>&1
