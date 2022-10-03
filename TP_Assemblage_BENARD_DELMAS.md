# Rapport d'assemblage
### _HAU901I - Bioanalyse, Transcriptomique, Année 2022-2023_
---------------------------------------------
_BENARD Flavie et DELMAS Jean-Charles_

### 1. Contexte
L'espèce étudiée est une algue endémique de Banyuls-sur-Mer, Bathycoccus sp.
Son génome est haploïde, il a une taille de 12Mb et est constitué de 19 chromosomes. On s'attend donc à obtenir 19 contigs dans notre assemblage.
L'ADN de haut poids moléculaire a été extrait en suivant le protocole CTAB. L'ADN est qualifié de bonne qualité.
Le séquençage a été réalisé avec un kit NSK-110, et une flowcell 9.4.1. Guppy6 “Bonito”/SUP a été utilisé pour le basecalling, afin d'améliorer le taux d'erreur (~0,1% avec cette méthode contre 3-4%). 
A l'issue du séquençage, les reads obtenus en sortie sont au format fasta.


### 2. Contrôle qualité
Une première étape de contrôle qualité est effectuée avant de procéder à l'assemblage. L'outil utilisé est Nanoplot.
![alt text](https://github.com/flavi23/TPAssemblage/blob/main/4222_RB2_nanoplot_out/HistogramReadlength.png)

| Tableau | Colonne |
| ------ | ------ |
| xx | yy |
| xxx | yyy |

[//]: # (Liens)
   [flye]: <https://www.nature.com/articles/s41587-019-0072-8>
   [biosphere]: <https://biosphere.france-bioinformatique.fr/>
   [southGreen]: <https://github.com/SouthGreenPlatform/training_SV_teaching/tree/2022>
