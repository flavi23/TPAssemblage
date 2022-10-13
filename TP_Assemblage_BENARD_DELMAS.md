# Rapport d'assemblage
### _HAU901I - Bioanalyse, Transcriptomique, Année 2022-2023_
---------------------------------------------
_BENARD Flavie et DELMAS Jean-Charles_

### 1. Contexte
L'espèce étudiée est une algue de Banyuls-sur-Mer, Bathycoccus.
Son génome est haploïde, de taille 15Mb et constitué de 19 chromosomes. On s'attend donc à obtenir 19 contigs dans notre assemblage.
L'ADN de haut poids moléculaire a été extrait en suivant le protocole CTAB. L'ADN est qualifié de bonne qualité.
Un premier échantillon a été prélevé à Roscoff, et deux autres ont été prélevés au même endroit, à Banyuls-sur-Mer, à deux moments distincts.
Les algues de type Bathycoccus ne peuvent pas être cultivées de manière stérile, elles ont besoin d'être accompagnées de bactéries. L'extraction s'effectue à l'aide d'un antibiotique pour essayer d'obtenir l'échantillon le plus stérile possible.
Le séquençage a été réalisé avec un kit NSK-110, et une flowcell 9.4.1. Guppy6 “Bonito”/SUP a été utilisé pour le basecalling, afin d'améliorer le taux d'erreur (~0,1% avec cette méthode contre 3-4%).
A l'issue du séquençage, les reads obtenus en sortie sont au format fastq.
Une première étape de contrôle qualité est effectuée avant de procéder à l'assemblage. L'outil utilisé est Nanoplot. Les résultats sont en concordance avec les résultats de qualité du séquençage obtenus précédemment. 

### 2. Assemblage
L'assemblage a été réalisé avec l'outil Flye. Flye donne un répertoire en sortie avec l'assemblage final nommé par défaut "assembly.fasta", et un assemblage sans polishing "contigs.fasta". Flye nécessite d'aligner les reads à l'aide de Minimap2. Flye construit d'abord des segments disjoints concaténés. L'information des reads et des graphes de répétitions permettent d'arriver à un assemblage consensus.
Quand on suppose au moins deux haplotypes possibles, ces derniers sont structurés en "bubbles". Par défaut, le programme Flye construit des contigs consensus plus larges à partir de ces bubbles. 
Un autre assemblage a été réalisé à l'aide du programme Raven pour le comparer à l'assemblage obtenu avec Flye. Dans ce contexte, Raven sert de contrôle qualité de l'assemblage.

### 3. Polishing
Un étape importante pour améliorer la qualité de l'assemblage est le polishing. Pour cela on utilise l'outil Racon, couplé à un alignement des reads avec Minimap2. Il aurait fallu pairé l'utilisation de Racon avec celle de Medaka (un autre polisher qui fait appel à un modèle d'IA). 

### 4. Contrôle qualité de l'assemblage

### 5. Scaffolding

### 6. Contrôle qualité du scaffolding

### 7. Dot-plot : comparaison de génomes


[//]: # (Liens)
   [flye]: <https://www.nature.com/articles/s41587-019-0072-8>
   [biosphere]: <https://biosphere.france-bioinformatique.fr/>
   [southGreen]: <https://github.com/SouthGreenPlatform/training_SV_teaching/tree/2022>
   
