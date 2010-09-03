#!/bin/bash

echo "time mpiexec --hostfile \$PBS_NODEFILE mb ./mrbayes-script &> out" \
  > run-mrbayes.sh

qsub $@ ./run-mrbayes.sh -d `pwd`
