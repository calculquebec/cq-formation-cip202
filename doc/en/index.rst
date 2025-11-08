Managing large batches of jobs
==============================

`Français <../fr/index.html>`_

This intermediate-level workshop (CIP202) is the continuation of `Job monitoring
and resource estimation
<https://calculquebec.github.io/cq-formation-cip201/en/index.html>`_ (CIP201).
Here, we explore a branch of high-performance computing, *data parallelism*,
using tools that allow for the easy management of large numbers of similar jobs.
You will find these tools handy if your research project involves repeating a
calculation tens or hundreds of times, for example to analyse different datasets
or to perform a *parameter sweep*.

The general concepts presented in the :doc:`introduction <introduction>` are
independent from any particular tool.

Later sections focus on specific tools, starting with :doc:`job arrays
<job_arrays>`, a feature of the Slurm job scheduler used on all our clusters.

We then present :doc:`GNU Parallel <gnu_parallel>`, which allows repeating a
calculation or performing a parameter sweep without increasing the number of
Slurm jobs.

The last section reviews other, more :doc:`specialised tools <other_tools>`,
such as GLOST and META-Farm.

.. note::

    This workshop was designed for guided sessions with a Calcul Québec
    instructor on our cloud computing platform. The files necessary for the
    exercises are in your home directory on the platform.

    If you follow this workshop on your own, you can download the `the
    necessary files <https://github.com/calculquebec/cq-formation-cip202>`_ and
    do the exercises on any Calcul Québec or Digital Research Alliance of Canada
    cluster. Your jobs’ wait time, however, will be longer than on the cloud
    platform.

.. toctree::
    :caption: Data parallelism
    :titlesonly:
    :hidden:

    introduction
    job_arrays
    gnu_parallel
    other_tools

.. toctree::
    :caption: External links
    :hidden:

    Alliance Technical Documentation <https://docs.alliancecan.ca/wiki/Technical_documentation/en>
    Calcul Québec Training <https://www.calculquebec.ca/en/academic-research-services/training/>
