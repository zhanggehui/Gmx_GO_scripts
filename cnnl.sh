#!/bin/bash
#SBATCH -J gmx_test
#SBATCH -p cn_nl
#SBATCH -N 1
#SBATCH -o ./test/1.out
#SBATCH -e ./test/2.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --qos=liufengcnnl
#SBATCH --ntasks-per-node=28
#SBATCH --exclusive

# environment variable:
# orientation ; rundir ; runscript ; scriptsdir

export I_MPI_DEBUG=20

export runscript=$RunScript
export rundir=$RunDir
export orientation=$Orientation
export scriptsdir=$ScriptsDir
echo "rundir: $rundir"
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
    source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash
    gmxrun="gmx mdrun -ntmpi $SLURM_NTASKS"
else
    source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash
    #mpistring="mpirun -n $SLURM_NTASKS -quiet --mca pml ob1 --mca btl_openib_allow_ib true"
    mpistring="mpirun -n $SLURM_NTASKS"
    gmxrun="$mpistring mdrun_mpi"
    #gmxrun="$mpistring mdrun_mpi2"
fi

source ./$rundir/$runscript

###########################################################
echo 'End at:' >> ./$rundir/time.out
date "+%Y-%m-%d %H:%M:%S"  >> ./$rundir/time.out
