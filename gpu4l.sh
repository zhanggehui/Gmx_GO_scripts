#!/bin/bash

#SBATCH -J gmx_nvtequ7_0613-20:22
#SBATCH -p gpu_4l
#SBATCH -N 1
#SBATCH --gres=gpu:4
#SBATCH -o ./nvtequ7/1.out
#SBATCH -e ./nvtequ7/2.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --qos=liufengg4c
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

numprocs=`echo "$hosts" | wc -l | awk '{print $1*4}'`
numprocs2=$SLURM_CPUS_ON_NODE
host1=`echo "$hosts" | head -n 1`
gpustring="0123"
echo "$host1:13" > machinefile_${SLURM_JOB_ID}
for host in `echo "$hosts" | awk '{if(NR>1)print $0}'`; do
echo "$host:13" >> machinefile_${SLURM_JOB_ID}
gpustring="${gpustring}0123"
numprocs2=`echo $numprocs2 $SLURM_CPUS_ON_NODE | awk '{print $1+$2}'`
done

nvidia-smi

source /appsnew/mdapps/gromacs2019.2_cuda10.1_intelmkl2019u4/bin/GMXRC2.bash
export OMP_NUM_THREADS=7

gmx grompp -f ./$scriptsdir/nvt-equ.mdp -c GO2-afterem.gro -p GO2.top \
-o ./$rundir/nvt-equ.tpr -po ./$rundir/nvt-equ-out -n waterlayer.ndx

cd $rundir
mpirun -np $SLURM_NTASKS -machinefile machinefile_${SLURM_JOB_ID} \
mdrun_mpi  -v -deffnm nvt-equ -ntomp $OMP_NUM_THREADS \
-nb gpu -pme gpu -npme 1 -gputasks 0123
cd ..

#mpirun -np 28 -machinefile machinefile_${SLURM_JOB_ID} mdrun_mpi -deffnm md4 - ntomp 2 -gputasks 0000111122223 -nb gpu -pme gpu -pmefft gpu -npme 1 -v
mv machinefile_${SLURM_JOB_ID}  ./$rundir
