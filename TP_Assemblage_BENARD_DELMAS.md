# Rapport d'assemblage du 17 octobre 2022
### _HAU901I - Bioanalyse, Transcriptomique, Année 2022-2023_
---------------------------------------------
_BENARD Flavie et DELMAS Jean-Charles_

### 1. Contexte
L'espèce étudiée est une algue de Banyuls-sur-Mer, Bathycoccus.
Son génome est haploïde, de taille 15Mb et est constitué de 19 chromosomes. On s'attend donc à obtenir 19 contigs dans notre assemblage.
L'ADN de haut poids moléculaire a été extrait en suivant le protocole CTAB. L'ADN est qualifié de bonne qualité.
Un premier échantillon a été prélevé à Roscoff (4222_RB2), et deux autres ont été prélevés au même endroit, à Banyuls-sur-Mer, à deux moments distincts (B8_RB11 et G11_RB6).
Les algues de type Bathycoccus ne peuvent pas être cultivées de manière stérile, elles ont besoin d'être accompagnées de bactéries. L'extraction s'effectue à l'aide d'un antibiotique pour essayer d'obtenir l'échantillon le plus stérile possible.
Le séquençage a été réalisé avec un kit NSK-110, et une flowcell 9.4.1. Guppy6 “Bonito”/SUP a été utilisé pour le basecalling, afin d'améliorer le taux d'erreur (~0,1% avec cette méthode contre 3-4%).
Toutes les analyses bioinformatiques ont été réalisées sur une machine virtuelle du cloud IFB [biosphere].
A l'issue du séquençage, les reads obtenus en sortie sont au format fastq.
Une première étape de contrôle qualité est effectuée avant de procéder à l'assemblage. L'outil utilisé est Nanoplot. Après analyse, on constate que le génome a été couvert 62 fois avec des reads pouvant atteindre 21kb. La taille médiane étant à 16.6kb signifie une bonne qualité de séquençage pour du long-read. Le génome analysé étant un génome haploïde, il faudrait une profondeur d'au moins 30X pour une analyse significative. Ici, la profondeur à 62X est valide pour débuter l'assemblage.

### 2. Assemblage
L'assemblage a été réalisé avec l'outil Flye. Flye donne un répertoire en sortie avec l'assemblage final nommé par défaut "assembly.fasta", et un assemblage sans polishing "contigs.fasta". Flye nécessite d'aligner les reads à l'aide de Minimap2. Flye construit d'abord des segments disjoints concaténés. L'information des reads alignés et des graphes de répétitions permettent d'arriver à un assemblage consensus (voir [Kolmogorov et al], 2019).
Quand on suppose au moins deux haplotypes possibles, ces derniers sont structurés en "bubbles". Un bubble est une bifurcation de séquences sur un graphe où le chemin se sépare en deux noeuds distincts (séquences différentes) et refusionne ensuite en un seul point. Par défaut, le programme Flye construit des contigs consensus plus larges à partir de ces bubbles. 
Un autre assemblage a été réalisé à l'aide du programme Raven pour le comparer à l'assemblage obtenu avec Flye. Dans ce contexte, Raven sert de contrôle qualité de l'assemblage.

### 3. Polishing
Un étape importante pour améliorer la qualité de l'assemblage est le polishing. 
Nous avons utilisé l'outil Racon, couplé à un alignement des reads sur l'assemblage, à l'aide de Minimap2. Les logiciels de polishing recherchent les mauvais assemblages locaux et autres incohérences dans un projet d'assemblage du génome, puis les corrigent. Racon fait ce polishing par consensus. Il aurait fallu pairer l'utilisation de Racon avec celle de Medaka (un autre polisher qui fait appel à un modèle d'IA), mais nous n'avons pas pu l'utiliser dans le cadre de ce projet (Medaka n'étant pas disponible dans la machine virtuelle). 
Selon le protocole de l'outil, Racon doit être appelé trois fois pour avoir un assez bon assemblage sans générer des erreurs supplémentaires (pour le premier tour, on utilise l'assemblage final de Flye, assembly.fasta; ensuite on utilise la sortie précédemment obtenue avec Racon). Un script bash a été créé pour obtenir trois passages de Minimap2 puis Racon. En réalité le nombre de tours requis peut varier. Nous avons donc effectué plus de trois passages et avons voulu évaluer la qualité de chaque sortie Racon à l'aide de Busco, pour déterminer à quel moment on obtient la meilleure qualité d'assemblage. Busco est un outil qui va nous permettre ici de visualiser l'évolution de la qualité de l'assemblage après polishing. Ne disposant pas de Busco sur la machine virtuelle, n'ayant pas non plus réussi à l'installer et n'ayant aucun retour du site gVolante (pouvant exécuter l'outil Busco en ligne), nous avons quand même simulé des résultats de Busco sur 6 passages de Racon, qui sont présentés dans la Table 1.

_Table 1 : Tableau théorique sur la précision des résultats de Busco en pourcentage en fonction du nombre d'exécution de l'outil Racon en réutilisant le fichier de sortie de Racon_

| Nb. de passage par Racon | Précision des résultats (%) par Busco | 
|:------------------------:|:-------------------------------------:|
|            0             |                   80                  | 
|            1             |                   86                  | 
|            2             |                   89                  | 
|            3             |                   93                  | 
|            4             |                   91                  | 
|            5             |                   90                  | 
|            6             |                   83                  | 

Nous nous sommes basés sur ces résultats de Busco simulés pour réaliser l'étape de scaffolding sur les fichiers obtenus sur le 3eme passage de Racon. 


### 4. Contrôle qualité de l'assemblage

Quast a permis de contrôler la qualité des assemblages obtenus pour les trois échantillons, avant scaffolding (sur le passage 3 de racon).


_Table 2 : Métriques de l'assemblage après polishing pour chacun des échantillons_


| Echantillon | Nombre contigs | Longueur totale | Plus grand contig |   N50   | L50 | GC (%)  | Misassemblies |
|:-----------:|:--------------:|:---------------:|:-----------------:|:-------:|:---:|:-------:|:-------------:|
|  4222_RB2   |       31       |    22539845     |      4574793      | 1016908 |  6  |  45.81  |       25      |
|   B8_RB11   |       24       |    15184803     |      1349481      |  989449 |  7  |  48.03  |      144      |
|   G11_RB6   |       28       |    15364424     |      1367294      |  925304 |  8  |  47.96  |      159      |

On peut remarquer que tous nos assemblages ont plus de 19 contigs. Le 4222_RB2 est plus grand qu'attendu, et il a un grand nombre de contigs. La longueur du plus grand fragment est à 4mb alors que le chromosome le plus long de Bathycoccus sp. fait 2mb. 
Concernant le taux de GC, l'échantillon 4222_RB2 a un plus faible taux de GC que les deux autres, qui sont autour de 48% (le taux de GC du génome de référence). Cette différence peut être due à la présence de séquences étrangères au génome qui peuvent avoir un plus faible taux de GC, et donc faire baisser le pourcentage total. Ceci, plus le grand nombre de contigs, nous fait penser à une contamination de l'échantillon. Cette contamination ferait écho à la récupération du matériel génétique de Bathycoccus qui ne peut pas s'effectuer de manière stérile.


### 5. Scaffolding

Pour réaliser l'étape de scaffolding avec RagTag, il est nécessaire d'avoir un génome de référence. Nous utilisons ici le génome de Bathycoccus Prasinos (GCF_002220235.1), qui a une taille de 15Mb. Seule la commande 'scaffold' de Ragtag a été utilisée. 
Le scaffolding a été réalisé sur les passages 3 des échantillons B8_RB11 et G11_RB6. Pour ce qui est de l'échantillon 4222_RB2, nous n'avons pas réussi à faire le scaffolding avec RagTag, ni sur l'assemblage sans polishing, ni sur les fichiers polishés avec racon (passages 1 à 3), ni même sur l'assemblage Raven. Nous avons dû avoir un problème dans le pipeline au niveau de l'étape de polishing (peut-être dû à un manque de maîtrise de l'outil).

### 6. Contrôle qualité du scaffolding

Nous avons à nouveau fait appel à Quast pour comparer la qualité des assemblages de chaque échantillon après l'étape de scaffolding. 
Pour l'échantillon 4222_RB2, nous n'avons pas pu utiliser nos fichiers comme expliqué plus haut. Nous avons donc dû utiliser le fichier nettoyé, assemblé, polishé et scaffoldé par l'équipe de François Sabot, notre assemblage ne pouvant pas être scaffoldé en l'état. 
La figure 1 (c) montre que l'échantillon 4222_RB2 a des erreurs d'assemblages qui apparaissent plus précocément que les deux autres (25 contre 148 et 159 pour B8_RB11 et G11_RB6). Cet échantillon est aussi celui qui présente des mismatchs sur un faible taux de kbp (11.21 contre 423.07 et 486.53 pour B8_RB11 et G11_RB6). Il a également l'alignement le plus long et est plus représentatif d'une réalité biologique sur les contigs (21 contigs, Bathycoccus possède 19 chromosomes), ce serait donc l'échantillon le plus proche de la réalité biologique si on se fit aux données métriques.


_Table 3 : Métriques de l'assemblage final (après scaffolding) de tous les échantillons, par rapport à la référence_


![stats](https://github.com/flavi23/TPAssemblage/blob/main/6.Quast/all_stats.png)


_Figure 1 : Graphiques des métriques pour tous les échantillons par rapport à la référence (obtenus avec Quast)_

Avec la longueur cumulée de l'assemblage (a), l'évolution des métriques Nx en fonction de la valeur de x (b), le nombre de 'misassemblies' (c) et le taux de GC (d)


![plots](https://github.com/flavi23/TPAssemblage/blob/main/6.Quast/all_plots.png)


### 7. Contamination de l'échantillon 4222_RB2

Nous avons également vérifié à l'aide du logiciel de visualisation de graphes [Bandage] si on retrouvait de la contamination dans nos échantillons. Bandage permet de visualiser les contigs obtenus à l'assemblage. Cette fois, nous avons utilisé notre fichier pour l'échantillon 4222_RB2 (le but étant de comprendre pourquoi on obtenait de tels résultats au niveau de l'assemblage). On peut effectivement voir que pour 4222_RB2, au moins deux contigs présentent une forme circulaire caractéristique des génomes bactériens. Ces contigs seraient donc issus d'une contamination de l'échantillon par des bactéries. Aucun des deux autres échantillons ne contient une contamination aussi importante, mais on retrouve des circularisations sur d'autres fragments où on suppose de la contamination. 
Les contigs contaminés de l'échantillon 4222_RB2 ont été par la suite enlevés de l'assemblage nettoyé par l'équipe de François Sabot. 


_Figure 2 : Représentation graphique des contigs des assemblages des échantillons (réalisé avec Flye)_


![bandagegraph](https://github.com/flavi23/TPAssemblage/blob/main/8.Bandage/unknown.png)


En conclusion, l'interprétation biologique devra se faire avec prudence, car on retrouve de l'ADN contaminé dans les échantillons, ce qui a pu influencer l'assemblage. En effet on retrouve un certain nombre d'erreurs d'assemblage. On a pu également visualiser avec Bandage la formation de contigs chimères. On constate de plus une forte contamination pour l'échantillon 4222_RB2 par rapport aux deux autres échantillons. Pour améliorer la qualité de l'assemblage, il est nécessaire de réaliser des étapes de nettoyage des séquences préalables à l'assemblage. Il sera possible d'identifier des contigs contenant des contaminations qu'on traitera, et ces contigs seront éventuellement éliminés de l'assemblage. 
Une prochaine étape pourrait être de comparer les résultats obtenus avec le pipeline de l'équipe de François Sabot et le nôtre, et de retravailler l'utilisation des outils par le pipeline, pour obtenir des résultats plus proches de ceux attendus. 

[//]: # (Liens)
   [Kolmogorov et al]: <https://www.nature.com/articles/s41587-019-0072-8>
   [biosphere]: <https://biosphere.france-bioinformatique.fr/>
   [southGreen]: <https://github.com/SouthGreenPlatform/training_SV_teaching/tree/2022>
   [Bandage]: <https://academic.oup.com/bioinformatics/article/31/20/3350/196114>
   
