Parallélisme de données sur les grappes
=======================================

`English <../en/index.html>`_

Cet atelier de niveau intermédiaire (CIP202) est la suite de l'atelier `Tâches
de calcul : ressources et suivi
<https://calculquebec.github.io/cq-formation-cip201/fr/index.html>`_ (CIP201).
Nous y explorons une branche du calcul informatique de pointe, le *parallélisme
de données*, avec des outils permettant de gérer facilement un grand nombre de
tâches similaires. Ces outils vous seront utiles si votre projet de recherche
requiert de répéter un calcul des dizaines ou des centaines de fois, par exemple
pour analyser différents ensembles de données ou faire un *balayage de
paramètres*.

Les concepts généraux présentés dans l’:doc:`introduction <introduction>` sont
indépendants des outils présentés plus loin.

..
    Ces concepts vous aideront justement à choisir l’outil approprié pour les
    cas de parallélisme de données les plus communs.

Les sections suivantes sont consacrées à des outils spécifiques. Nous débutons
avec les :doc:`vecteurs de tâches <job_arrays>`, une fonctionnalité intégrée à
l’ordonnanceur Slurm utilisé sur nos grappes de calcul.

Nous présentons ensuite :doc:`GNU Parallel <gnu_parallel>`, qui permet de
répéter un calcul ou de faire un balayage de paramètres sans augmenter le nombre
de tâches Slurm.

La dernière section survole d’:doc:`autres outils <other_tools>` plus
spécialisés, tels que GLOST et META-Farm.

.. note::

    Cet atelier a été conçu pour être guidé par un formateur ou une formatrice
    de Calcul Québec sur notre plateforme infonuagique. Les fichiers nécessaires
    pour les exercices sont dans votre répertoire personnel sur la plateforme.

    Si vous suivez cet atelier par vous-même, vous pouvez télécharger `les
    fichiers nécessaires <https://github.com/calculquebec/cq-formation-cip202>`_
    et réaliser les exercices sur n’importe quelle grappe de Calcul Québec ou de
    l’Alliance de recherche numérique du Canada. Le temps d’attente pour
    l’exécution des tâches sera toutefois plus long que sur la plateforme
    infonuagique.

.. toctree::
    :caption: Parallélisme de données
    :titlesonly:
    :hidden:

    introduction
    job_arrays
    gnu_parallel
    other_tools

.. toctree::
    :caption: Liens externes
    :hidden:

    Documentation technique de l’Alliance <https://docs.alliancecan.ca/wiki/Technical_documentation/fr>
    Formations de Calcul Québec <https://www.calculquebec.ca/services-aux-chercheurs/formation/>
