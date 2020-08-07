#!/bin/bash
#SBATCH -J gmx_analyse
#SBATCH -p cn_nl
#SBATCH -N 1
#SBATCH -o ./3.out
#SBATCH -e ./4.err
#SBATCH --no-requeue
#SBATCH -A liufeng_g1
#SBATCH --qos=liufengcnnl

hosts=`scontrol show hostname $SLURM_JOB_NODELIST` ; echo $hosts

analyse_scripts=do_rdf.sh

source ./md_scripts/${analyse_scripts}

