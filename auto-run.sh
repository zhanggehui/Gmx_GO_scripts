#!/bin/bash
#####  changable   ###################################################
NodeType=cn-short # cn-short ; cn_nl ; gpu_4l ; debug ; debug_gpu
NodeNum=1   # only affect cn-short
NtasksPerNode=20   # only affect cn-short
export Usempirun=1  # except gpu ; cn-short: 0 or 1 ; cn_nl: 1
export RunScript=$1
export RunDir=$2
export Orientation=2  #ori x1,y2,z3
export ScriptsDir='scripts'
#####################################################################
rm -rf $RunDir
mkdir $RunDir
echo "Partition: $NodeType" > $RunDir/time.out
echo "Number of Nodes: $NodeNum" >> $RunDir/time.out
echo '' >> $RunDir/time.out
##choose proper node setting ########################################
if [ "$NodeType" == cn-short ] ; then
submissionscript='cnshort.sh'
keyword="#SBATCH -N" ;newline="#SBATCH -N $NodeNum"
sed -i "/$keyword/c$newline" ./$ScriptsDir/$submissionscript
keyword="#SBATCH --ntasks-per-node"
newline="#SBATCH --ntasks-per-node=$NtasksPerNode"
sed -i "/$keyword/c$newline" ./scripts/$submissionscript
#####################################################################
elif [ "$NodeType" == cn_nl ] ; then
submissionscript='cnnl.sh'
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
jobname="gmx_$2_$runtime"  #format: gmx_RunDir_runtime
keyword="#SBATCH -J" ; newline="#SBATCH -J $jobname"
sed -i "/$keyword/c$newline" ./$ScriptsDir/$submissionscript
oname="./$RunDir/1.out"
keyword="#SBATCH -o" ; newline="#SBATCH -o $oname"
sed -i "/$keyword/c$newline" ./$ScriptsDir/$submissionscript
ename="./$RunDir/2.err"
keyword="#SBATCH -e" ; newline="#SBATCH -e $ename"
sed -i "/$keyword/c$newline" ./$ScriptsDir/$submissionscript

sbatch ./$ScriptsDir/$submissionscript

cp ./$ScriptsDir/$submissionscript ./$RunDir
