#!/bin/bash

#SBATCH -J gmx_nvtequ7_0613-20:22
#SBATCH -p gpu_4l
#SBATCH -N 1
#SBATCH --gres=gpu:4      #############################
#SBATCH -o ./nvtequ7/1.out
#SBATCH -e ./nvtequ7/2.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --qos=liufeng4c
#SBATCH --exclusive

#source /home/liufeng_pkuhpc/gromacs.sh

para1=$1 ; para2=$2 ; para3=$3

export I_MPI_DEBUG=20

echo 'NodesList:'
hosts=`scontrol show hostname $SLURM_JOB_NODELIST` ; echo $hosts
echo ''
echo 'Number of nodes:'
echo $SLURM_JOB_NUM_NODES
echo ''
echo 'Cpus per node:'
echo $SLURM_JOB_CPUS_PER_NODE
echo ''

numprocs=`echo "$hosts" | wc -l | awk '{print $1*4}'`
numprocs2=$SLURM_CPUS_ON_NODE
host1=`echo "$hosts" | head -n 1`
gpustring="0123"     #############################
echo "$host1:13" > machinefile_${SLURM_JOB_ID}

for host in `echo "$hosts" | awk '{if(NR>1)print $0}'`; do
echo "$host:13" >> machinefile_${SLURM_JOB_ID}
gpustring="${gpustring}0123"
numprocs2=`echo $numprocs2 $SLURM_CPUS_ON_NODE | awk '{print $1+$2}'`
done

nvidia-smi

export OMP_NUM_THREADS=7

gmx grompp -f md4.mdp -c md3.gro -t md3.cpt -p sio2_water.top -o md4.tpr

mpirun -np $numprocs -machinefile machinefile_${SLURM_JOB_ID} \
mdrun_mpi -deffnm md4 -ntomp $OMP_NUM_THREADS \
-gpu_id 0123 -nb gpu -pme gpu -pmefft gpu -npme 1 -v


#mpirun -np 28 -machinefile machinefile_${SLURM_JOB_ID} mdrun_mpi -deffnm md4 - ntomp 2 -gputasks 0000111122223 -nb gpu -pme gpu -pmefft gpu -npme 1 -v
mv machinefile_${SLURM_JOB_ID}  ./$3
