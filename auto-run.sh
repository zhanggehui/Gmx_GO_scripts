#!/bin/bash
#####  changable   ###################################################
NodeType=cn_nl # cn-short ; cn_nl ; gpu_4l ; debug ; debug_gpu
NodeNum=1   # affect cn-short and cn_nl
NtasksPerNode=28   # affect cn-short and cn_nl
export Usempirun=1  # except gpu ; cn-short: 0 or 1 ; cn_nl: 1(better)
export runscript=$1
export rundir=$2
export orientation=2  #ori x1,y2,z3
export scriptsdir='scripts'
#####################################################################
#rm -rf $rundir
if [ ! -d $rundir ] ; then
mkdir $rundir
echo "Partition: $NodeType" > $rundir/time.out
echo "Number of Nodes: $NodeNum" >> $rundir/time.out
echo '' >> $rundir/time.out
##choose proper node setting ########################################
if [ "$NodeType" == cn-short ] ; then
submissionscript='cnshort.sh'
keyword="#SBATCH -N" ; newline="#SBATCH -N $NodeNum"
sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
keyword="#SBATCH --ntasks-per-node" ; newline="#SBATCH --ntasks-per-node=$NtasksPerNode"
sed -i "/$keyword/c$newline" ./scripts/$submissionscript
#####################################################################
elif [ "$NodeType" == cn_nl ] ; then
submissionscript='cnnl.sh'
keyword="#SBATCH -N" ; newline="#SBATCH -N $NodeNum"
sed -i "/$keyword/c$newline" ./$scriptsdir/$submissionscript
keyword="#SBATCH --ntasks-per-node" ; newline="#SBATCH --ntasks-per-node=$NtasksPerNode"
sed -i "/$keyword/c$newline" ./scripts/$submissionscript
#####################################################################
elif [ "$NodeType" == debug ] ; then
submissionscript='debug.sh'
#####################################################################
elif [ "$NodeType" == debug_gpu ] ; then
submissionscript='gpudebug.sh'
#####################################################################
elif [ "$NodeType" == gpu_4l ] ; then
submissionscript='gpu4l.sh'
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

cp ./$scriptsdir/$runscript ./$rundir
cp ./$scriptsdir/nvt-cycle.mdp ./$rundir
cp ./$scriptsdir/$submissionscript ./$rundir

sbatch ./$scriptsdir/$submissionscript

else
echo 'Already exists! Please make sure!'
fi
