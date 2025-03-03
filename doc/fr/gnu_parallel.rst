GNU Parallel
============

`English <../en/gnu_parallel.html>`_

Si votre projet de recherche implique de faire des balayages de paramètres avec
de courts processus, une multitude de tâches Slurm n’est probablement `pas la
meilleure solution <#pourquoi-pas-slurm>`_. En fait, devoir gérer de multiples
combinaisons de paramètres est un défi en soi. Et c’est là que `GNU Parallel
<https://docs.alliancecan.ca/wiki/GNU_Parallel/fr>`_ devient l’outil tout
désigné.

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
  en situation de fin hâtive de la tâche Slurm.

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

Le paramètre changeant est donné via une paire d’``{}`` :

.. code-block:: bash

    parallel echo fichier{}.txt ::: 1 2 3 4
    # parallel --citation  # S'engager à citer les développeurs

On peut réécrire la première commande en utilisant l’expansion des accolades
Bash ``{a..b}`` :

.. code-block:: bash

    parallel echo fichier{}.txt ::: {1..4}
    parallel echo fichier{}.txt ::: {01..10}

Une même valeur peut être répétée dans le gabarit de commande :

.. code-block:: bash

    parallel echo {}. fichier{}.txt ::: {01..10}

Ensuite, si votre gabarit de commande doit contenir des caractères normalement
interprétés par Bash, par exemple ``$``, ``|``, ``>``, ``&`` et ``;``, il faut
les mettre entre ``''``. Ceci assure que leur interprétation sera faite
uniquement au moment où GNU Parallel exécutera les commandes en parallèle.

.. code-block:: bash

    parallel echo {}. '>' '$'SCRATCH/fichier{}.txt ::: {01..10}
    # Validation
    cat $SCRATCH/fichier*.txt

Enfin, si aucune variable ne doit être résolue au moment d’appeler la commande
``parallel``, c'est tout le gabarit qui peut être entre ``''``.

.. code-block:: bash

    parallel 'echo {}. > $SCRATCH/fic-{}.txt' ::: {01..10}
    # Validation
    cat $SCRATCH/fic-*.txt

Exercice
''''''''

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

    parallel echo fichier{1}{2}.txt ::: {01..10} ::: a b

**b)** Dans le cas où on retrouve les **combinaisons de paramètres dans un
fichier texte** :

.. code-block:: bash

    cat param.txt

La commande ``parallel`` aura ``-C ' '`` pour spécifier le séparateur de
paramètres dans ``param.txt``, ainsi que l’argument ``::::`` pour spécifier
ensuite ce nom de fichier :

.. code-block:: bash

    # parallel -C ' ' echo '$(({1}*{2})) > prod_{1}x{2}' :::: param.txt
    cat prll-exec-param.sh
    sbatch prll-exec-param.sh

**c)** Si on préfère valider la **liste des commandes dans un fichier texte**
avant leur exécution sur un nœud de calcul :

.. code-block:: bash

    cat cmd.txt

Le script de tâche aura une commande ``parallel`` simplifiée :

.. code-block:: bash

    # parallel < cmd.txt
    cat prll-exec-cmd.sh
    sbatch prll-exec-cmd.sh

Nombre limité de cas en parallèles
----------------------------------

Le paramètre ``--jobs`` permet de forcer une limite sur le nombre de processus
lancés à la fois. Par exemple, 8 cas avec 2 processus en simultané :

.. code-block:: bash

    parallel --jobs 2 'echo {} && sleep 3' ::: {1..8}
