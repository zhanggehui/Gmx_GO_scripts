#!/bin/bash

#SBATCH -J gmx_test
#SBATCH -p debug
#SBATCH -N 1
#SBATCH -o ./test/1.out
#SBATCH -e ./test/2.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --ntasks-per-node=24

#env: rundir ; orientation ; runmode

export I_MPI_DEBUG=20
usempirun=0

dir=test
rundir=test

echo 'NodesList:'
hosts=`scontrol show hostname $SLURM_JOB_NODELIST` ; echo $hosts
echo ''
echo 'Number of nodes:'
echo $SLURM_JOB_NUM_NODES
echo ''
echo 'Cpus per node:'
echo $SLURM_JOB_CPUS_PER_NODE
echo ''

if [ $SLURM_JOB_NUM_NODES -eq 1 ]
then
    gmxrun="gmx mdrun"
    if [ $usempirun -eq 1 ];then
        mpistring="mpirun -n $SLURM_NTASKS"
        gmxrun="$mpistring mdrun_mpi"
    fi
else
#mpistring="mpirun -n $SLURM_NTASKS -quiet --mca pml ob1 --mca btl_openib_allow_ib true"
mpistring="mpirun -n $SLURM_NTASKS"
gmxrun="$mpistring mdrun_mpi"
#gmxrun="$mpistring gmx_mpi mdrun"
fi

scriptsdir='./scripts'


gmx grompp -f ./scripts/nvt-equ.mdp -p GO2.top \
-o ./$dir/nvt-equ.tpr -po ./$dir/nvt-equ-out -n waterlayer.ndx

cd $rundir

mpirun -n $SLURM_NTASKS mdrun_mpi -v -deffnm nvt-equ

cd ..

echo '' >> ./$rundir/time.out
echo 'End at:' >> ./$rundir/time.out
date "+%Y-%m-%d %H:%M:%S"  >> ./$rundir/time.out
