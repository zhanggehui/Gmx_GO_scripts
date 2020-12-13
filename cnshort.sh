#!/bin/bash
#SBATCH -J gmx
#SBATCH -p cn-short
#SBATCH -N 1
#SBATCH -o ./nvtequ/1.out
#SBATCH -e ./nvtequ/2.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --qos=liufengcns
#SBATCH --ntasks-per-node=20
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


source ./$rundir/$runscript

###########################################################
echo 'End at:' >> ./$rundir/time.out
date "+%Y-%m-%d %H:%M:%S"  >> ./$rundir/time.out
