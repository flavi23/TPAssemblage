# Rapport d'assemblage
### _HAU901I - Bioanalyse, Transcriptomique, Année 2022-2023_
---------------------------------------------
_BENARD Flavie et DELMAS Jean-Charles_

### 1. Contexte
L'espèce étudiée est une algue de Banyuls-sur-Mer, Bathycoccus.
Son génome est haploïde, de taille 15Mb et constitué de 19 chromosomes. On s'attend donc à obtenir 19 contigs dans notre assemblage.
L'ADN de haut poids moléculaire a été extrait en suivant le protocole CTAB. L'ADN est qualifié de bonne qualité.
Un premier échantillon a été prélevé à Roscoff (4222_RB2), et deux autres ont été prélevés au même endroit, à Banyuls-sur-Mer, à deux moments distincts (B8_RB6 et G11_).
Les algues de type Bathycoccus ne peuvent pas être cultivées de manière stérile, elles ont besoin d'être accompagnées de bactéries. L'extraction s'effectue à l'aide d'un antibiotique pour essayer d'obtenir l'échantillon le plus stérile possible.
Le séquençage a été réalisé avec un kit NSK-110, et une flowcell 9.4.1. Guppy6 “Bonito”/SUP a été utilisé pour le basecalling, afin d'améliorer le taux d'erreur (~0,1% avec cette méthode contre 3-4%).
Toutes les analyses bioinformatiques ont été réalisées sur une machine virtuelle du cloud IFB [biosphere].
A l'issue du séquençage, les reads obtenus en sortie sont au format fastq.
Une première étape de contrôle qualité est effectuée avant de procéder à l'assemblage. L'outil utilisé est Nanoplot. Les résultats sont en concordance avec les résultats de qualité du séquençage obtenus précédemment. 

### 2. Assemblage
L'assemblage a été réalisé avec l'outil [flye]. Flye donne un répertoire en sortie avec l'assemblage final nommé par défaut "assembly.fasta", et un assemblage sans polishing "contigs.fasta". Flye nécessite d'aligner les reads à l'aide de Minimap2. Flye construit d'abord des segments disjoints concaténés. L'information des reads et des graphes de répétitions permettent d'arriver à un assemblage consensus.
Quand on suppose au moins deux haplotypes possibles, ces derniers sont structurés en "bubbles". Par défaut, le programme Flye construit des contigs consensus plus larges à partir de ces bubbles. 
Un autre assemblage a été réalisé à l'aide du programme Raven pour le comparer à l'assemblage obtenu avec Flye. Dans ce contexte, Raven sert de contrôle qualité de l'assemblage.

### 3. Polishing
Un étape importante pour améliorer la qualité de l'assemblage est le polishing. 
Nous avons utilisé l'outil Racon, couplé à un alignement des reads sur l'assemblage, à l'aide de Minimap2. Les logiciels de polishing recherchent les mauvais assemblages locaux et autres incohérences dans un projet d'assemblage du génome, puis les corrigent. Racon fait ce polishing par consensus. Il aurait fallu pairer l'utilisation de Racon avec celle de Medaka (un autre polisher qui fait appel à un modèle d'IA), mais nous n'avons pas pu l'utiliser dans le cadre de ce projet. 
Selon le protocole de l'outil, Racon doit être appelé trois fois pour avoir un assez bon assemblage (pour le premier tour, on utilise l'assemblage final de Flye, assembly.fasta; ensuite on utilise la sortie précédemment obtenue avec Racon). Un script bash a été créé pour faire tourner Minimap2 puis Racon trois fois. En réalité le nombre de tours requis peut varier. Il aurait donc fallu le faire plus de trois fois et évaluer la qualité de chaque sortie Racon à l'aide de Busco pour déterminer à quel moment on obtient la meilleure qualité d'assemblage. Toutefois, compte tenu des délais cela n'a pas été possible dans le cadre de ce projet. 

### 4. Contrôle qualité de l'assemblage

Quast a permis de contrôler la qualité des assemblages obtenus pour les trois échantillons. 

_Métriques_ 

| Echantillon | Nombre contigs | Longueur totale | N50 | L50 |
|:-----------:|:--------------:|:---------------:|:---:|:---:|
| 4222_RB2    |                |     1500000     |1.99 | 739 |
|   B8_RB6    |                |     1500000     |1.99 | 739 |
| G11_        |                |     1500000     |1.99 | 739 |


### 5. Scaffolding

Pour réaliser l'étape de scaffolding avec RagTag, il est nécessaire d'avoir un génome de référence. Nous utilisons ici le génome de Bathycoccus Prasinos (GCF_002220235.1), qui a une taille de 15Mb. 

### 6. Contrôle qualité du scaffolding

Nous avons à nouveau fait appel à Quast pour comparer la qualité des assemblages de chaque échantillon après l'étape de scaffolding :


[//]: # (Liens)
   [flye]: <https://www.nature.com/articles/s41587-019-0072-8>
   [biosphere]: <https://biosphere.france-bioinformatique.fr/>
   [southGreen]: <https://github.com/SouthGreenPlatform/training_SV_teaching/tree/2022>
   
