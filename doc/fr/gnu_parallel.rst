GNU Parallel
============

`English <../en/gnu_parallel.html>`_

Si votre projet de recherche implique de faire des balayages de paramètres avec
de courts processus (de 50 minutes et moins), une multitude de tâches Slurm
n’est probablement `pas la meilleure solution <#pourquoi-pas-slurm>`_. En fait,
devoir gérer de multiples combinaisons de paramètres est un défi en soi. Et
c’est là que `GNU Parallel <https://docs.alliancecan.ca/wiki/GNU_Parallel/fr>`_
devient l’outil tout désigné.

GNU Parallel s’utilise via la commande ``parallel`` qui permet d’utiliser
pleinement les ressources locales d’un nœud de calcul, et ce, en gérant
l’exécution d’une **longue liste de tâches de petite taille**. C’est un peu
comme l’ordonnanceur Slurm, mais à plus petite échelle et en gérant des
processus au lieu de scripts de tâche.

.. figure:: ../images/gnu-parallel_fr.svg

- `Documentation officielle
  <https://www.gnu.org/software/parallel/parallel.html>`_
- `Tutoriel <https://www.gnu.org/software/parallel/parallel_tutorial.html>`_

Pourquoi pas Slurm?
-------------------

OK, mais pourquoi ne pas tout simplement soumettre **des centaines de tâches à
Slurm**?

- À tout moment, Slurm **limite chaque usager à 1000 tâches** au total dans
  ``squeue`` (*pending* + *running*).
- Certains calculs sont tellement **courts (moins de 5 minutes)** que le
  démarrage et la fin de la tâche comptent pour un pourcentage significatif du
  temps réel utilisé, ce qui diminue l’efficacité CPU de ces tâches.

Les avantages de GNU Parallel à considérer :

- Nous **évite d’utiliser une boucle** soumettant des centaines de scripts
  similaires, ce qui, dans bien des cas, facilite l’exécution de centaines de
  cas de calcul semblables.
- Le nombre de **processeurs disponibles limite** automatiquement le nombre de
  cas de calcul exécutés en simultané.

  - Dans le cas de calculs parallèles, c’est possible de spécifier le nombre de
    cas en simultané.

- GNU Parallel peut `reprendre la séquence des cas de calcul
  <https://docs.alliancecan.ca/wiki/GNU_Parallel/fr#Suivi_des_commandes_ex.C3.A9cut.C3.A9es_ou_des_commandes_ayant_.C3.A9chou.C3.A9.3B_fonctionnalit.C3.A9s_de_red.C3.A9marrage>`_
  lorsque la tâche Slurm est interrompue.

Syntaxe de la commande GNU Parallel
-----------------------------------

Les éléments de base de la commande ``parallel`` :

.. code-block:: bash

    parallel <options> <gabarit_de_commande> ::: <liste de valeurs>

Voir la page de manuel pour les options (appuyez sur :kbd:`q` pour quitter) :

.. code-block:: bash

    man parallel

Une seule liste de valeurs
--------------------------

Le paramètre changeant est donné via une paire d’``{}``. Par exemple :

.. code-block:: bash
    :emphasize-lines: 1,10-15

    [alice@narval1 ~]$ parallel echo fichier{}.txt ::: 7 8 9 10 11 12
    Academic tradition requires you to cite works you base your article on.
    If you use programs that use GNU Parallel to process data for an article in a
    scientific publication, please cite:

    ...

    To silence this citation notice: run 'parallel --citation' once.

    fichier7.txt
    fichier8.txt
    fichier10.txt
    fichier11.txt
    fichier9.txt
    fichier12.txt

Tel que vu dans cet exemple, l’ordre d’affichage des résultats peut varier à
cause de l’exécution des différents processus en simultané : leur durée peut
varier et le système d’exploitation peut parfois favoriser légèrement certains
processus.

.. note::

    Pour s’engager à citer les développeurs de GNU Parallel :

    .. code-block:: bash
        :emphasize-lines: 1,9

        [alice@narval1 ~]$ parallel --citation
        Academic tradition requires you to cite works you base your article on.
        If you use programs that use GNU Parallel to process data for an article in a
        scientific publication, please cite:

        ...

        Type: 'will cite' and press enter.
        > will cite

        ...

        It is really appreciated. The citation notice is now silenced.


On peut réécrire la première commande en utilisant l’expansion des accolades
Bash ``{a..b}`` :

.. code-block:: bash

    [alice@narval1 ~]$ parallel echo fichier{}.txt ::: {7..12}
    fichier7.txt
    fichier8.txt
    fichier9.txt
    fichier10.txt
    fichier11.txt
    fichier12.txt


Si nécessaire, on peut ajouter des zéros non significatifs aux nombres plus
courts :

.. code-block:: bash

    [alice@narval1 ~]$ parallel echo fichier{}.txt ::: {07..12}
    fichier07.txt
    fichier08.txt
    fichier09.txt
    fichier10.txt
    fichier11.txt
    fichier12.txt


Une même valeur peut être répétée dans le gabarit de commande :

.. code-block:: bash

    [alice@narval1 ~]$ parallel echo {}. fichier{}.txt ::: {07..12}
    07. fichier07.txt
    08. fichier08.txt
    09. fichier09.txt
    10. fichier10.txt
    11. fichier11.txt
    12. fichier12.txt

Ensuite, si votre gabarit de commande doit contenir des caractères normalement
interprétés par Bash, par exemple ``$``, ``|``, ``>``, ``&`` et ``;``, on peut
mettre tout le gabarit de commande entre ``''`` pour que l’interprétation de
ces caractères soit faite uniquement au moment où GNU Parallel exécutera les
commandes en parallèle :

.. code-block:: bash

    [alice@narval1 ~]$ parallel 'echo {}. > $SCRATCH/fichier{}.txt' ::: {07..12}
    [alice@narval1 ~]$ cat $SCRATCH/fichier*.txt
    07.
    08.
    09.
    10.
    11.
    12.

Exercice - Préparer des séquences d’ADN
'''''''''''''''''''''''''''''''''''''''

**Objectifs**

- Transformer des boucles en des appels à la commande ``parallel``.
- Préparer le jeu de données : des séquences aléatoires d’ADN.

**Instructions**

#. Allez dans le répertoire de l’exercice avec ``cd
   ~/cq-formation-cip202-main/lab/bio-info``.
#. Éditez le fichier ``gen-seq.sh`` :

   #. Demandez deux (2) cœurs CPU dans l’entête ``SBATCH``.
   #. Transformez la commande ``python gen_spec.py ...`` de sorte à utiliser la
      commande ``parallel`` plutôt que la boucle ``for`` :

      #. Ajoutez ``parallel`` au début et enlevez l’indentation.
      #. Remplacez les deux itérateurs ``$spec`` par ``{}``.
      #. Protégez le caractère ``>``, s’il y a lieu.
      #. Ajoutez ``:::``, ainsi que les lettres de A à D, inclusivement.

   #. Refaites les mêmes étapes pour la commande ``makeblastdb ...``.
   #. Refaites les mêmes étapes pour la commande ``python gen_test.py ...``,
      mais avec les différences suivantes :

      - Remplacez les deux itérateurs ``$test`` par ``{}``.
      - Fournissez les 16 lettres de K à Z, inclusivement.

   #. Supprimez les lignes ``for`` et ``done`` (:kbd:`Ctrl+K` dans ``nano``).

#. Sauvegardez le script et soumettez-le à l’ordonnanceur.
#. Au final, validez la présence des fichiers suivants :

   - ``spec_A.fa`` à ``spec_D.fa``, inclusivement.
   - ``spec_A.n*`` à ``spec_D.n*``, inclusivement.
   - ``chr_K.fa`` à ``chr_Z.fa``, inclusivement.

#. En cas de problème, tentez de le régler ou soumettez le script
   ``solution/gen-seq.sh`` à l’ordonnanceur.

.. note::

    L’encodage numérique de brins d’ADN se fait au moyen des quatre codes
    ``A``, ``C``, ``G`` et ``T`` qui correspondent aux quatre bases des
    molécules d’ADN. Bien qu’une séquence complète soit faite de milliards de
    bases, les séquenceurs sont fiables que sur de courtes lectures. Ainsi,
    une collection de fichiers Fasta (``*.fa``) contient de nombreux morceaux
    d’ADN qui peuvent se chevaucher. Or, étant donné les nombreuses
    combinaisons possibles, en plus d’un certain taux d’erreurs dans les
    données, reconstruire une longue séquence d’ADN est tout un défi!

    Parfois, le problème est plus *simple*, c’est-à-dire qu’il suffit
    d’identifier à quelle espèce appartient le brin d’ADN. Dans ce cas, il
    suffit de tester les brins inconnus avec des bases de données de séquences
    connues. C’est essentiellement ce qui a été préparé dans cet exercice.

Combinaisons de paramètres
--------------------------

Pour cette partie, allez dans le répertoire des exemples avec :

.. code-block:: bash

    cd ~/cq-formation-cip202-main/lab/gnu-parallel

**a)** Lorsqu’il y a **plusieurs séquences de paramètres à combiner**, on peut
utiliser des paires d’accolades numérotées telles que ``{1}``, ``{2}``, etc. :

.. code-block:: bash

    [alice@narval1 gnu-parallel]$ parallel echo fichier{1}{2}.txt ::: {08..10} ::: a b
    fichier08a.txt
    fichier08b.txt
    fichier09a.txt
    fichier09b.txt
    fichier10a.txt
    fichier10b.txt

**b)** Dans le cas où on retrouve les **combinaisons de paramètres dans un
fichier texte** :

.. code-block:: bash

    [alice@narval1 gnu-parallel]$ cat param.txt
    3 4
    3 6
    3 8
    5 4
    5 6
    5 8
    7 4
    7 6
    7 8

La commande ``parallel`` aura ``-C ' '`` pour spécifier le séparateur de
paramètres dans ``param.txt``, ainsi que l’argument ``::::`` pour spécifier
ensuite ce nom de fichier :

.. code-block:: bash

    [alice@narval1 gnu-parallel]$ cat exec-param.sh
    #!/bin/bash
    #SBATCH --cpus-per-task=2
    #SBATCH --mem=1000M
    #SBATCH --time=00:05:00

    parallel -C ' ' echo '$(({1}*{2})) > prod_{1}x{2}' :::: param.txt
    grep -E '[0-9]+' prod_*

.. code-block:: bash

    [alice@narval1 gnu-parallel]$ sbatch exec-param.sh

**c)** Si on préfère valider la **liste des commandes dans un fichier texte**
avant leur exécution sur un nœud de calcul :

.. code-block:: bash

    [alice@narval1 gnu-parallel]$ cat cmd.txt
    echo $((3*4)) > prod_3x4
    echo $((3*6)) > prod_3x6
    echo $((5*4)) > prod_5x4
    echo $((5*6)) > prod_5x6
    echo $((5*8)) > prod_5x8
    echo $((7*6)) > prod_7x6
    echo $((7*8)) > prod_7x8

Le script de tâche aura une commande ``parallel`` simplifiée :

.. code-block:: bash

    [alice@narval1 gnu-parallel]$ cat exec-cmd.sh
    #!/bin/bash
    #SBATCH --cpus-per-task=2
    #SBATCH --mem=1000M
    #SBATCH --time=00:05:00

    parallel < cmd.txt
    grep -E '[0-9]+' prod_*

.. code-block:: bash

    [alice@narval1 gnu-parallel]$ sbatch exec-cmd.sh

Exercice - Aligner des séquences d’ADN
''''''''''''''''''''''''''''''''''''''

**Objectifs**

- Utiliser deux listes de valeurs dans une commande ``parallel``.
- En ayant des séquences d’ADN d’espèces connues et inconnues, calculer
  l’alignement de toutes les combinaisons ``{A,B,C,D}`` x
  ``{K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}``, ce qui donne 64 combinaisons.

**Instructions**

#. Allez dans le répertoire de l’exercice avec ``cd
   ~/cq-formation-cip202-main/lab/bio-info``.
#. Éditez le fichier ``blastn-parallel.sh`` :

   #. Demandez quatre (4) cœurs CPU dans l’entête ``SBATCH``.
   #. Séparez le gabarit de commande et les deux listes de valeurs par des
      séparateurs ``:::``.
   #. La première liste de lettres correspond aux espèces connues. Chaque
      lettre est utilisée comme **suffixe** au nom de la base de données
      ``spec_*`` et au nom du fichier de sortie ``results/align_*_*``.
   #. La deuxième liste de lettres correspond aux espèces inconnues. Chaque
      lettre est utilisée **au milieu du nom** de fichier Fasta ``chr_*.fa``
      et du fichier de sortie ``results/align_*_*``.

#. Sauvegardez le script et soumettez-le à l’ordonnanceur.
#. Au final, il devrait y avoir 64 fichiers dans le répertoire ``results``.
   Certains sont plus gros que d’autres, car des aligments ont été trouvés.

Nombre limité de cas en parallèle
---------------------------------

Pour les calculs multi-fils (de 2 à 8 cœurs CPU), la commande ``parallel`` ne
doit pas lancer autant de processus qu’il y a de cœurs CPU sur le nœeud ; on se
retrouverait avec plusieurs fils par cœur CPU. Ainsi, la première chose à faire
est de réduire le nombre de processus en simultané.

Pour ce faire, on utilise le paramètre ``-j`` ou ``--jobs`` qui permet de
forcer une limite sur le nombre de processus lancés à la fois. Par exemple,
10 cas à traiter avec un maximum de deux processus en simultané :

.. code-block:: bash

    [alice@narval1 ~]$ parallel -j 2 'echo {} && sleep 3' ::: {1..10}
    # (3 secondes d'attente)
    1
    2
    # (3 secondes d'attente)
    3
    4
    # (3 secondes d'attente)
    5
    6
    # (3 secondes d'attente)
    7
    8
    # (3 secondes d'attente)
    9
    10

Dans un script de tâche OpenMP contenant :

.. code-block:: bash

    #SBATCH --nodes=1 --ntasks-per-node=16 --cpus-per-task=4

Nous aurions une commande comme celle-ci :

.. code-block:: bash

    parallel \
        -j $SLURM_NTASKS_PER_NODE \
        --env OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK \
        ./app <options> {} \
        ::: val1 val2 ...
