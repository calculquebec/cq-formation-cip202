Job Arrays
==========

`Français <../fr/job_arrays.html>`_

`Job arrays <https://docs.alliancecan.ca/wiki/Job_arrays/en>`_ are a feature of
the Slurm job scheduler. They allow using the same script to submit many jobs
with a single command.

..
    sont
    une fonctionnalité de l’ordonnanceur Slurm. Ils permettent d’utiliser le même
    script pour soumettre plusieurs tâches avec une seule commande.

Job arrays are the ideal tool when:

- You have many similar jobs to submit.
- These jobs are not too short (at least one hour of requested time).
- Their number does not exceed one thousand.

..
    - Vous avez plusieurs tâches similaires à soumettre.
    - Celles-ci ne sont pas trop courtes (au moins une heure de temps demandé).
    - Leur nombre n’excède pas un millier.

For shorter or more numerous jobs, a different tool should be used, such as
:doc:`../gnu_parallel`.

The basics
----------

The following ``hello-job.sh`` script is a minimal example of a job array:

.. code-block:: bash
    :emphasize-lines: 4,6

    #!/bin/bash

    #SBATCH --job-name=hello
    #SBATCH --array=1-10

    echo "Hello from index $SLURM_ARRAY_TASK_ID"

    sleep 60

A job array script includes the ``--array`` option, which sets the job’s
repetitions and gives each one a unique index, here from 1 to 10. This index is
accessible using ``$SLURM_ARRAY_TASK_ID``.

..
    Un script pour un vecteur de tâches contient l’option ``--array``, qui
    spécifie les répétitions de la tâche et assigne à chacune une valeur entière
    unique, ici de 1 à 10. Cet index est accessible avec
    ``$SLURM_ARRAY_TASK_ID``.

This script can be submitted like any other:

..
    Ce script peut être soumis comme n’importe quel autre :

.. code-block:: console

    [alice@narval1 hello-array]$ sbatch hello-job.sh
    Submitted batch job 40912550

However, this command creates 10 jobs in the scheduler rather than one:

..
    Toutefois, cette commande crée 10 tâches dans l’ordonnanceur plutôt qu’une
    seule :

.. code-block:: console

    [alice@narval1 hello-array]$ sq
              JOBID     USER      ACCOUNT           NAME  ST  TIME_LEFT NODES CPUS TRES_PER_N MIN_MEM NODELIST (REASON) 
    40912550_[4-10]    alice  def-sponsor my-first-array  PD    1:00:00     1    1        N/A    256M          (Priority)
         40912550_1    alice  def-sponsor my-first-array   R      59:57     1    1        N/A    256M nc10914  (None) 
         40912550_2    alice  def-sponsor my-first-array   R      59:57     1    1        N/A    256M nc10914  (None) 
         40912550_3    alice  def-sponsor my-first-array   R      59:57     1    1        N/A    256M nc10914  (None)

Each job is identified by its index and is independent from the others.
Therefore, some jobs might start while others wait in the queue.

..
    Chaque tâche est identifiée par son index et est indépendante des autres.
    Ainsi, certaines tâches peuvent démarrer tandis que d’autres attendent dans
    la file.

Each job gets its own output file, again identified by the job’s index:

..
    Chaque tâche a son propre fichier de sortie, à nouveau identifié par son
    index :

.. code-block:: console

    [alice@narval1 hello-array]$ ls slurm-*.out
    slurm-40912550_1.out  slurm-40912550_2.out  slurm-40912550_3.out
    [alice@narval1 hello-array]$ grep Hello slurm-*.out
    slurm-40912550_1.out:Hello from index 1
    slurm-40912550_2.out:Hello from index 2
    slurm-40912550_3.out:Hello from index 3

To cancel a specific job in the array, specify its index:

.. code-block:: console

    [alice@narval1 ~]$ scancel 40912550_5

To cancel a range of jobs:

.. code-block:: console

    [alice@narval1 ~]$ scancel 40912550_[6-10]

To cancel all jobs in the array:

.. code-block:: console

    [alice@narval1 ~]$ scancel 40912550

Exercise
''''''''

#. Go to the directory containing the above script with ``cd
   ~/cq-formation-cip202-main/lab/hello-array``.
#. Show the script with ``cat hello-job.sh``.
#. Submit the script with ``sbatch`` and monitor the jobs with ``sq``.
#. Once all jobs have completed, show the output files with
   ``ls`` and ``cat``.

Why use job arrays?
'''''''''''''''''''

Rather than using an array, it would be possible to submit tens or hundreds of
job scripts, manually or through an automated loop. This is to be avoided:

..
    Plutôt que d’utiliser un vecteur, il serait possible de soumettre,
    manuellement ou à l’aide d’une boucle automatisée, des dizaines ou des
    centaines de scripts de tâches. Cette approche est à proscrire :

- Fast, repeated calls to ``sbatch`` overload the scheduler.
- Maintaining numerous copies of your job script is more complicated and
  error-prone.

..
    - Des appels rapides et répétés à ``sbatch`` surchargent l’ordonnanceur. -
      Maintenir de nombreuses copies de votre script de tâche est plus compliqué
      et source d’erreurs.

Using job arrays
----------------

The submitted jobs’ indices can be chosen freely. A few examples:

..
    Les index des tâches à soumettre peuvent être contrôlés avec précision. Voici
    quelques exemples :

- ``--array=1-10``: From 1 to 10
- ``--array=1-9:2``: 1, 3, 5, 7, 9 (step of 2)
- ``--array=1,2,5``: 1, 2, 5

The syntax used in the last example is particularly useful to resubmit one or
several failed jobs. To do so, ``sbatch --array`` can be used instead of
modifying the job script:

..
    La syntaxe du dernier exemple est particulièrement utile pour re-soumettre
    une ou plusieurs tâches ayant échoué. Pour ce faire, ``sbatch --array`` peut
    être utilisé plutôt que de modifier le script de tâche :

.. code-block:: console

    [alice@narval1 ~]$ sbatch --array=1,2,5 job.sh

Finally, it is possible to limit the number of jobs that can run simultaneously:

..
    Finalement, il est possible de limiter le nombre de tâches pouvant être
    actives simultanément :

- ``--array=1-1000%10``: At most 10 jobs can run simultaneously.

This is useful to limit your jobs’ throughput to avoid affecting your
colleagues’ jobs’ priority when you submit a large number of jobs. If your jobs
make intensive usage of network storage, limiting the number of running jobs
also avoids causing input/output problems.

..
    Cela est utile pour limiter le débit de vos tâches afin d’éviter que les
    autres membres de votre groupe de recherche ne voient la priorité de leurs
    tâches sévèrement diminuée si vous soumettez un grand nombre de tâches. Si
    vos tâches utilisent intensivement le stockage réseau, limiter le nombre de
    tâches actives évite aussi de causer des problèmes d’entrée-sortie.

The ``SLURM_ARRAY_TASK_ID`` variable gives the index associated with a job. It
is used in the script to distinguish between the jobs. It can be used to:

- Choose an input data set (e.g. molecule 1, 2, 3…).
- Determine the value of a parameter to test.
- Number an output file.

..
    La variable ``SLURM_ARRAY_TASK_ID`` donne l’index associé à une tâche. Elle
    est utilisée dans le script afin de distinguer les tâches. On l’utilise
    pour :

..
    - Choisir un jeu de données d’entrée (e.g. molécule 1, 2, 3…). - Déterminer
      la valeur d’un paramètre à tester. - Numéroter un fichier de sortie.

For instance, if you had input files named ``mol-1.pdb``, ``mol-2.pdb``,
``mol-3.pdb``, ``...``, you could refer to them in your script with:

..
    Par exemple, si vous aviez des fichiers d’entrée nommés ``mol-1.pdb``,
    ``mol-2.pdb``, ``mol-3.pdb``, ``...``, vous pourriez y faire référence dans
    votre script avec :

.. code-block:: bash

    ./prog --input "mol-$SLURM_ARRAY_TASK_ID.pdb"

The length of the ``SLURM_ARRAY_TASK_ID`` variable can make a job script
difficult to read, especially when it is used multiple times. For this reason,
``SLURM_ARRAY_TASK_ID`` is frequently aliased to a short name:

..
    La longueur de la variable ``SLURM_ARRAY_TASK_ID`` peut rendre le script de
    tâche difficile à lire, particulièrement lorsque la variable est utilisée
    plusieurs fois. Pour cette raison, il est fréquent d’aliaser
    ``SLURM_ARRAY_TASK_ID`` à un nom court :

.. code-block:: bash

    i=$SLURM_ARRAY_TASK_ID

    ./prog --input "mol-$i.pdb" --output "stats-$i.dat"

It is also frequent for file names to include non-significant zeros, such as
``mol-001.pdb``, ``...``, ``mol-099.pdb``, ``mol-100.pdb``. The job index must
then be converted to a character string and padded with zeros:

..
    Il est fréquent d’avoir des fichiers nommés avec des zéros non
    significatifs, par exemple ``mol-001.pdb``, ``...``, ``mol-099.pdb``,
    ``mol-100.pdb``. L’index de la tâche doit alors être converti en une chaîne
    de caractères remplie avec des zéros :

.. code-block:: bash

    i=$(printf %03d $SLURM_ARRAY_TASK_ID)

    ./prog --input "mol-$i.pdb" --output "stats-$i.dat"

.. note::

    ``printf`` prints one or more values according to a *format*, here
    ``%03d``:

    - ``%``: Start formatting a value
    - ``0``: Pad with non-significant zeros
    - ``3``: Output a three-character string
    - ``d``: Interpret the value as an integer number

    The ``$(cmd)`` syntax is a *command substitution*. Here, ``cmd``’s output is
    used to set ``i``’s value.

Exercise
''''''''

**Objectives**

- Convert a standard job script into a job array script.
- Submit a job array that generates ten numbered files.

..
    - Convertir un script de tâche standard en un script pour un vecteur de
      tâches. - Soumettre un vecteur de tâches qui produit dix fichiers
      numérotés.

**Instructions**

#. Familiarise yourself with the initial job script, which generates a file
   containing random numbers taken from a normal distribution.

   #. Go to the exercise directory with
      ``cd ~/cq-formation-cip202-main/lab/dist-array``.
   #. Show the job script with ``cat dist-job-single.sh``.
   #. Submit the script with ``sbatch dist-job-single.sh``.
   #. Once the job has completed, check that the output file was generated with
      ``ls results``.

#. Modify the script to make a job array.

   #. Copy it under a different name: ``cp dist-job-single.sh
      dist-job-array.sh``.
   #. Edit the script again with ``nano dist-job-array.sh``.
   #. Add the ``--array`` option to create a 10-job array.
   #. Use ``$SLURM_ARRAY_TASK_ID`` to set the output file’s name.
   #. Optionally, use ``printf`` to generate output files whose names all have
      the same number of characters.

#. Submit the script with ``sbatch``.
#. Once all jobs have completed, check that the ten output files have been
   generated.

**Solution**

- Compare your script with ``solution/distrib-job-array.sh``.
- The ``solution/distrib-job-array-padded.sh`` version adds non-significant
  zeros.

Complex arrays
--------------

Parallel job arrays
'''''''''''''''''''

The job arrays we have seen until now all repeated a serial job. However, any
job can be repeated with an array, including parallel ones.

..
    Les vecteurs de tâches que nous avons vus jusqu’à maintenant répétaient tous
    une tâche sérielle. Toutefois, n’importe quelle tâche peut être répétée au
    moyen d’un vecteur, incluant les tâches parallèles.

When submitting a job array, the requested resources apply to each job, not to
the array globally. For instance, to submit 10 jobs where an MPI program runs on
8 CPU cores in each job, the following script requests 8 cores, not 80:

..
    Les ressources (temps, mémoire, cœurs CPU) demandées quand on soumet un
    vecteur s’appliquent à chaque tâche et non globalement. Par exemple, pour
    exécuter un programme MPI 10 fois avec 8 cœurs CPU chaque fois, le script
    suivant demande 8 cœurs et non 80 :

.. code-block:: bash
    :emphasize-lines: 4,7

    #!/bin/bash

    #SBATCH --job-name=param-sweep
    #SBATCH --ntasks=8
    #SBATCH --mem-per-cpu=2G
    #SBATCH --time=6:00:00
    #SBATCH --array=1-10

    srun ./prog --param=$SLURM_ARRAY_TASK_ID

2D arrays
'''''''''

We sometimes want to vary more than one parameter in a job array. For example,
if you study 8 drug candidates and 4 protein receptors, you might want to test
all 32 possible drug-receptor combinations. However, Slurm does not allow
defining multiple variables with the ``--array`` option; we can only give an
index sequence. What should we do?

..
    Il arrive parfois que l’on souhaite varier plus d’un paramètre dans un
    vecteur de tâches. Par exemple, si vous étudiez 8 médicaments potentiels et
    4 récepteurs protéiques, vous pourriez vouloir tester les 32 combinaisons
    médicament/récepteur possibles. Toutefois, Slurm ne permet pas de définir de
    multiples variables avec l’option ``--array`` ; on ne peut que donner une
    séquence d’index. Que faire ?

There are several possible solutions to this problem, but all use the same
strategy: converting a linear index :math:`i` to an :math:`(x,y)` index pair.
Let us give each drug an index :math:`x \in [0..7]` and each receptor an index
:math:`y \in [0..3]`; the linear index is :math:`i \in [0..31]`:

..
    Il existe plusieurs solutions possibles à ce problème, mais toutes utilisent
    la même stratégie : convertir un index linéaire :math:`i` en une paire
    d’index :math:`(x,y)`. Donnons au médicament l’index :math:`x \in [0..7]` et
    au récepteur l’index :math:`y \in [0..3]` ; l’index linéaire, pour sa part,
    sera :math:`i \in [0..31]` :

.. figure:: ../images/job-array-2d.svg

To convert :math:`i → (x,y)`, we use integer division, :math:`\text{div}`, and
remainder (or modulo), :math:`\text{mod}`. These conversions can be done in the
job script:

..
    Pour convertir :math:`i → (x,y)`, on utilise la division entière,
    :math:`\text{div}`, et le reste (ou modulo), :math:`\text{mod}`. Ces
    conversions peuvent être faites dans le script de tâche :

.. code-block:: bash
    :emphasize-lines: 7-8

    #!/bin/bash

    #SBATCH --array=0-31

    i=$SLURM_ARRAY_TASK_ID

    x=$((i % 8))  # mod
    y=$((i / 8))  # div

    echo "Testing drug candidate $x vs receptor $y"

.. note::

    The ``$((expr))`` syntax is an *arithmetic expansion*, which allows simple
    calculations (limited to integers).

N-dimensionnal arrays
'''''''''''''''''''''

When the number of parameters to work with exceeds two, converting the linear
index :math:`i` to multidimensional indices with integer divisions and modulo
becomes fastidious. There is a simple alternative: create a file containing all
the desired parameter combinations, with one such combination per line. The line
number in the file becomes the linear index :math:`i`. To convert :math:`i →
(x,y,z,...)`, we just read the values on the corresponding line.

..
    Lorsque le nombre de paramètres à traiter dépasse deux, convertir l’index
    linéaire :math:`i` en index multidimensionnels avec des divisions entières
    et le modulo devient fastidieux. Il existe une alternative simple : créer un
    fichier contenant toutes les combinaisons de paramètres à traiter, une
    combinaison par ligne. Le numéro de ligne dans le fichier devient l’index
    linéaire :math:`i`. Pour convertir :math:`i → (x,y,z,...)`, il suffit de
    lire les valeurs à la ligne correspondante.

For example, suppose you simulate the stability of two proteins, at three
different temperatures, with and without a stabilising agent. A file
``params.txt`` containing the 12 possible parameter combinations can be created
with the following ``make-params.sh`` script:

..
    Par exemple, supposons que vous simulez la stabilité de deux protéines à
    trois températures différentes avec et sans un agent stabilisant. Un fichier
    ``params.txt`` contenant les 12 combinaisons possibles de ces paramètres
    peut être créé avec le script ``make-params.sh`` suivant :

.. code-block:: bash

    #!/bin/bash

    proteins="A B"
    temperatures="30 37 44"

    rm -f params.txt

    for prot in $proteins; do
        for temp in $temperatures; do
            for agent in true false; do
                echo $prot $temp $agent >> params.txt
            done
        done
    done

.. code-block:: console

    [alice@narval1 ~]$ bash make-params.sh
    [alice@narval1 ~]$ cat params.txt
    A 30 true
    A 30 false
    A 37 true
    A 37 false
    A 44 true
    A 44 false
    B 30 true
    B 30 false
    B 37 true
    B 37 false
    B 44 true
    B 44 false

The array job script reads one line from this file:

..
    Le script du vecteur de tâches lit une ligne de ce fichier :

.. code-block:: bash
    :emphasize-lines: 7

    #!/bin/bash

    #SBATCH --array=1-12

    i=$SLURM_ARRAY_TASK_ID

    read prot temp agent <<< $(sed "${i}q;d" params.txt)

    echo "Loading structure for protein $prot"
    echo "Setting temperature to $temp degrees"
    if $agent; then
        echo "Adding stabilizing agent"
    fi

.. note::

    The ``sed`` (stream editor) command is a text manipulation tool. It is used
    here to read line ``${i}`` from the parameter file. The ``<<<`` syntax is a
    here-string: ``sed``’s output is redirected to the ``read`` command, which
    sets variables ``prot``, ``temp``, and ``agent``.

    ..
        La commande ``sed`` (*stream editor*) est un outil de manipulation de
        texte. Elle est utilisée ici pour lire la ligne ``${i}`` du fichier de
        paramètres. La syntaxe ``<<<`` est une chaîne en ligne (*here string*) :
        la sortie de ``sed`` est redirigée vers la commande ``read``, qui
        assigne les valeurs aux variables ``prot``, ``temp`` et ``agent``.

    A pipe such as ``sed [...] | read [...]`` could not be used here since pipes
    are run in a sub-process that does not have access to the parent process’
    variables, that is the process running the script. The values would be
    lost immediately after reading them.

    ..
        Un tube tel que ``sed [...] | read [...]`` ne pourrait être utilisé ici
        car les tubes sont exécutés dans un sous-processus qui n’a pas accès aux
        variables du processus parent, soit celui qui exécute le script. Les
        valeurs lues seraient alors immédiatement perdues.

In addition to being simple, this approach to multidimensional job arrays is
flexible:

..
    En plus d’être simple, cette approche des vecteurs de tâches
    multidimensionnels est flexible :

- It works regardless of the number of parameters.
- The number of parameters can easily be changed.
- Any parameter combinations can be used.

  - This makes it possible to avoid processing combinations that you know are
    invalid. For example, if you simulate a model with various combinations of
    temperature and humidity but are only interested in conditions above the dew
    point, you can exclude in advance any temperature/humidity combination that
    you know is under that point, by simply not adding it to your parameter
    file.

..
    - Elle fonctionne peu importe le nombre de paramètres.
    - Le nombre de paramètres peut être changé aisément.
    - N’importe quelles combinaisons de paramètres peuvent être choisies.

..
  - Cela permet, entre autres, d’éviter de traiter des combinaisons que l’on
    sait impossibles. Par exemple, si vous simulez un modèle avec différentes
    combinaisons de température et de niveau d’humidité mais que vous ne vous
    intéressez qu’aux conditions au-dessus du point de rosée, vous pouvez
    éliminer à l’avance les combinaisons température/humidité que vous savez
    être en dessous de ce point, simplement en ne les ajoutant pas à votre
    fichier de paramètres.

Find out more
-------------

- Alliance Technical Documentation: `Job arrays
  <https://docs.alliancecan.ca/wiki/Job_arrays/en>`_
- Slurm documentation: `Job Array Support
  <https://slurm.schedmd.com/job_array.html>`_
- Webinar: `Automating the GROMACS analysis tools on HPC systems
  <https://raw.githubusercontent.com/WestGrid/trainingMaterials/gh-pages/materials/gmxtools.pdf>`_
