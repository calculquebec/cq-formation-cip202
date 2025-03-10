Généralités
===========

`English <../en/introduction.html>`_

Dans `CIP201
<https://calculquebec.github.io/cq-formation-cip201/fr/task-types/parallel.html>`__,
nous avions vu la distinction entre des tâches sérielles et des tâches
parallèles. Parmi les tâches parallèles, il existe deux sous-catégories :

- Le `parallélisme de traitement
  <https://fr.wikipedia.org/wiki/Parall%C3%A9lisme_(informatique)#Principes>`__.
  C’est le partitionnement d’une même tâche de calcul de sorte à pouvoir tirer
  profit de la puissance de plusieurs cœurs CPU en simultané. Dans de bonnes
  conditions de `scalabilité
  <https://calculquebec.github.io/cq-formation-cip201/fr/resources/cpu.html#scalabilite>`__,
  le calcul devrait être accéléré et le résultat, obtenu plus rapidement.
- Le `parallélisme de données
  <https://fr.wikipedia.org/wiki/Parall%C3%A9lisme_de_donn%C3%A9e>`__.
  Celui-ci consiste plutôt à répéter une tâche, souvent sérielle et parfois
  parallèle, avec différentes données d’entrées, par exemple des images, des
  molécules ou des séquences d’ADN. Ainsi, le parallélisme de données vise à
  augmenter le débit de calcul en exécutant de multiples tâches simultanément.

.. figure:: ../images/parallelism-types_fr.svg

Quand utiliser le parallélisme de données
-----------------------------------------

- Lorsqu’il y a une multiplication de fichiers à traiter indépendamment.

  .. figure:: ../images/multiple-files_fr.svg

- Lorsqu’il y a plusieurs combinaisons de paramètres à tester, on voudra faire
  un *balayage de paramètres*.

  =====  =======  =====
  Masse  Vitesse  Angle
  =====  =======  =====
     95       75     38
     95       75     45
     95       75     52
     95       80     38
     95       80     45
     95       80     52
    100       75     38
    100       75     45
    100       75     52
    100       80     38
    100       80     45
    100       80     52
  =====  =======  =====

- Lorsqu’on a un mélange des deux besoins ci-dessus.

  - Par exemple, en apprentissage automatique : 987 654 images en entrée et
    123 456 combinaisons `d’hyperparamètres
    <https://fr.wikipedia.org/wiki/Hyperparam%C3%A8tre>`__
    à tester pour un certain modèle d’intelligence artificielle.

Face à un grand nombre de tâches de calcul à faire, il y a lieu d’utiliser de
bons outils pour en faire la gestion.
