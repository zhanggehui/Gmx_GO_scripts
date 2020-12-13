#!/bin/bash
#####  changable   ###################################################
NodeType=cn_nl # cn-short ; cn_nl ; cn-long
NtasksPerNode=28
NodeNum=1
export Usempirun=1  #cn-short,cn-long: 0 or 1 ; cn_nl: 1(better)
export runscript=$1
export rundir=$2
export orientation=2  #ori x1,y2,z3
export scriptsdir='scripts'

#rm -rf $rundir
if [ ! -d $rundir ]; then
    mkdir $rundir
    ##choose proper node setting ########################################
    submissionscript='cn.sh'
    keyword="#SBATCH -N"; newline="#SBATCH -N $NodeNum"
    sed -i "/$keyword/c$newline" $scriptsdir $submissionscript
    keyword="#SBATCH --ntasks-per-node"; newline="#SBATCH --ntasks-per-node=$NtasksPerNode"
    sed -i "/$keyword/c$newline" $scriptsdir $submissionscript
    changesubmissionscript 
    if [ "$NodeType" == cn-short ]; then
        keyword="#SBATCH --qos"; newline="#SBATCH --qos=liufengcns"
        sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
    elif [ "$NodeType" == cn_nl ]; then
        keyword="#SBATCH --qos"; newline="#SBATCH --qos=liufengcnnl"
        sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
    elif [ "$NodeType" == cn-long ]; then
        keyword="#SBATCH --qos"; newline="#SBATCH --qos=liufengcnl"
        sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
    fi
    #####################################################################
    runtime=$(date "+%m%d-%H:%M")
    jobname="gmx_$2_$runtime"  #format: gmx_rundir_runtime
    keyword="#SBATCH -J" ; newline="#SBATCH -J $jobname"
    sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
    oname="./$rundir/1.out"
    keyword="#SBATCH -o" ; newline="#SBATCH -o $oname"
    sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
    ename="./$rundir/2.err"
    keyword="#SBATCH -e" ; newline="#SBATCH -e $ename"
    sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript

    cp ./$scriptsdir/$submissionscript ./$rundir
    cp ./$scriptsdir/$runscript ./$rundir
    cp ./$scriptsdir/nvt-cycle.mdp ./$rundir
    
    sbatch ./$scriptsdir/$submissionscript
    sleep 2s
else
    echo 'Already exists! Please make sure!'
fi
