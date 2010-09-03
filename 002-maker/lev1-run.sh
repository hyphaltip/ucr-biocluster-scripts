#!/bin/sh

cat $PBS_NODEFILE | sort | uniq > reserved_hosts.tmp
export PATH=/opt/mpich2-1.2.1p1/bin:$PATH

mpdallexit 1> /dev/null

cat $PBS_NODEFILE | sort | uniq > reserved-nodes.tmp
mpdboot -n `cat reserved-nodes.tmp | wc -l` --file=reserved-nodes.tmp
mpdringtest 1000; mpdtrace; mpdlistjobs
time mpiexec -n `cat $PBS_NODEFILE | wc -l` /opt/maker-r400/bin/mpi_maker -qq &> out
mpdallexit

