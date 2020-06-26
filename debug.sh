#!/bin/bash

#SBATCH -J gmx_nvtequ7_0613-20:22
#SBATCH -p debug
#SBATCH -N 1
#SBATCH -o ./nvtequ7/1.out
#SBATCH -e ./nvtequ7/2.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --ntasks-per-node=24
#SBATCH --exclusive

# environment variable:
# orientation ; rundir ; runscript ; scriptsdir

export I_MPI_DEBUG=20

export runscript=$RunScript
export rundir=$RunDir
export orientation=$Orientation
export scriptsdir=$ScriptsDir

hosts=`scontrol show hostname $SLURM_JOB_NODELIST`
#1.out######################################################
echo 'NodesList:'
echo $hosts ; echo ''
echo 'Number of Nodes:'
echo $SLURM_JOB_NUM_NODES ; echo ''
echo 'Cpus per Node:'
echo $SLURM_JOB_CPUS_PER_NODE ; echo ''

#time.out###################################################
echo 'Begin at:' >> ./$rundir/time.out
date "+%Y-%m-%d %H:%M:%S"  >> ./$rundir/time.out
echo '' >> ./$rundir/time.out

#############################################################

if [ $SLURM_JOB_NUM_NODES -eq 1 -a $Usempirun -eq 0 ] ; then
    source /home/liufeng_pkuhpc/gmx-zs.sh
    gmxrun="gmx mdrun"
else
    source /appsnew/mdapps/gromacs2019.3_cpu_intelmkl2019_cnscompat/bin/GMXRC2.bash
    #mpistring="mpirun -n $SLURM_NTASKS -quiet --mca pml ob1 --mca btl_openib_allow_ib true"
    mpistring="mpirun -n $SLURM_NTASKS"
    gmxrun="$mpistring mdrun_mpi"
#   gmxrun="$mpistring mdrun_mpi2"
fi

source ./$scriptsdir/$runscript

###########################################################
echo 'End at:' >> ./$rundir/time.out
date "+%Y-%m-%d %H:%M:%S"  >> ./$rundir/time.out
