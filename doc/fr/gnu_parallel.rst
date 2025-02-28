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

Modes d’utilisation
-------------------

Pour cette partie, allez dans le répertoire des exemples avec :

.. code-block:: bash

    cd ~/cq-formation-cip202-main/lab/gnu-parallel

Une seule séquence de paramètres
''''''''''''''''''''''''''''''''

Le paramètre changeant est donné via une paire d’``{}`` :

.. code-block:: bash

    parallel echo fichier{}.txt ::: 1 2 3 4
    # parallel --citation  # S'engager à citer les développeurs

On peut réécrire la première commande en utilisant l’expansion des accolades
Bash ``{a..b}`` :

.. code-block:: bash

    parallel echo fichier{}.txt ::: {1..4}
    parallel echo fichier{}.txt ::: {01..10}

Combinaisons de paramètres
''''''''''''''''''''''''''

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
''''''''''''''''''''''''''''''''''

Le paramètre ``--jobs`` permet de forcer une limite sur le nombre de processus
lancés à la fois. Par exemple, 8 cas avec 2 processus en simultané :

.. code-block:: bash

    parallel --jobs 2 'echo {} && sleep 3' ::: {1..8}
