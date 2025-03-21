Generalities
============

`Français <../fr/introduction.html>`_

In `CIP201
<https://calculquebec.github.io/cq-formation-cip201/en/task-types/parallel.html>`__,
we saw the distinction between serial jobs and parallel jobs. Among parallel
jobs, there are two subcategories:

- `Task parallelism <https://en.wikipedia.org/wiki/Task_parallelism>`__.
  It is the partitioning of a single job so as to be able to take advantage
  of the power of several CPU cores simultaneously. Under good `scalability
  <https://calculquebec.github.io/cq-formation-cip201/en/resources/cpu.html#scalability>`__
  conditions, the calculation should be accelerated and the result obtained
  more quickly.
- `Data parallelism <https://en.wikipedia.org/wiki/Data_parallelism>`__.
  This one involves repeating a computing task, often serial and sometimes
  parallel, with different input data, for example images, molecules or DNA
  sequences. Thus, data parallelism aims to increase computing throughput by
  running multiple tasks simultaneously in one or several jobs.

.. figure:: ../images/parallelism-types_en.svg

When to use data parallelism
----------------------------

- When there is a multiplication of files to be processed independently.

  .. figure:: ../images/multiple-files_en.svg

- When there are multiple parameter combinations to test, we will want to do a
  *parameter sweep*.

  ====  =====  =====
  Mass  Speed  Angle
  ====  =====  =====
    95     75     38
    95     75     45
    95     75     52
    95     80     38
    95     80     45
    95     80     52
   100     75     38
   100     75     45
   100     75     52
   100     80     38
   100     80     45
   100     80     52
  ====  =====  =====

- When you have a mixture of the two needs above.

  - For example, in machine learning: 987 654 input images and 123 456
    combinations of `hyperparameters
    <https://en.wikipedia.org/wiki/Hyperparameter_(machine_learning)>`__
    to test for a certain artificial intelligence model.

When faced with a large number of calculation tasks to be done, it is necessary
to use good tools to manage them.
