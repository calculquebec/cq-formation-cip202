Autres outils
=============

`English <../en/other_tools.html>`_

GLOST
-----

`GLOST <https://docs.alliancecan.ca/wiki/GLOST/fr>`__ (pour *Greedy Launcher
Of Small Tasks*) est un outil faisant penser à :doc:`gnu_parallel` lorsqu’un
fichier de commandes est fourni. Voici ce qui différencie les deux outils :

===========  ===============================  ================================
Comparaison            GNU Parallel                        GLOST
===========  ===============================  ================================
Commande     ``parallel < cmd.txt``           ``srun glost_launch cmd.txt``
Tâche Slurm  Typiquement mono-nœud            Processus distribués (MPI)
``sbatch``   ``--nodes=1 --cpus-per-task=N``  ``--ntasks=N --cpus-per-task=1``
===========  ===============================  ================================

Ce qu’il faut comprendre du précédent tableau, c’est que GLOST passe par une
`tâche MPI <https://docs.alliancecan.ca/wiki/Running_jobs/fr#T%C3%A2che_MPI>`__
(ou *Message Passing Interface*) pour démarrer **des commandes exclusivement
sérielles** listées dans un fichier texte. Le programme ``glost_launch`` est
donc une application MPI utilisant une architecture de type
gestionnaire-travailleur :

- Le processus gestionnaire (numéro 0 dans la figure ci-dessous) distribue une
  commande sérielle à la fois jusqu’à ce qu’il n’en reste plus.
- Lorsqu’ils sont disponibles, les travailleurs demandent la prochaine commande
  à exécuter et en obtiennent une ou sinon l’instruction de quitter.

.. figure:: ../images/glost-mpi.svg

Pour cette partie, allez dans le répertoire des exemples avec :

.. code-block:: bash

    cd ~/cq-formation-cip202-main/lab/gnu-parallel

Pour utiliser GLOST, il faut d’abord charger un module :

.. code-block:: bash

    module load glost/0.3.1

Ensuite, on peut directement tester avec quatre processus (``-n, --ntasks``) et
un cœur par processus (``-c, --cpus-per-task``) :

.. code-block:: bash

    [alice@narval1 gnu-parallel]$ srun -n 4 -c 1 glost_launch cmd.txt
    srun: job 41153816 queued and waiting for resources
    srun: job 41153816 has been allocated resources
    #executed by process  2 in 0.006s with status  0 : echo $((3*6)) > prod_3x6
    #executed by process  3 in 0.006s with status  0 : echo $((5*4)) > prod_5x4
    #executed by process  1 in 0.007s with status  0 : echo $((3*4)) > prod_3x4
    #executed by process  2 in 0.006s with status  0 : echo $((5*6)) > prod_5x6
    #executed by process  3 in 0.006s with status  0 : echo $((5*8)) > prod_5x8
    #executed by process  1 in 0.008s with status  0 : echo $((7*6)) > prod_7x6
    #executed by process  2 in 0.005s with status  0 : echo $((7*8)) > prod_7x8

Dans l’exemple ci-dessus, il n’y a effectivement que trois des quatre processus
qui ont fait des calculs. Avec le code de sortie (``status 0`` quand tout va
bien), c’est possible d’identifier les commandes à reprendre lors d’une
prochaine tâche GLOST.

META-Farm
---------

Présentation ...
