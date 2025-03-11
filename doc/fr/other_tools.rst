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
(ou *Message Passing Interface*) pour démarrer des commandes sérielles listées
dans un fichier texte. Le programme ``glost_launch`` est donc une application
MPI utilisant une architecture de type gestionnaire-travailleur :

- Le processus gestionnaire (numéro 0 dans la figure ci-dessous) distribue une
  commande sérielle à la fois jusqu’à ce qu’il n’en reste plus.
- Lorsqu’ils sont disponibles, les travailleurs demandent la prochaine commande
  à exécuter et en obtiennent une ou sinon l’instruction de quitter.

.. figure:: ../images/glost-mpi.svg

META-Farm
---------

Présentation ...
