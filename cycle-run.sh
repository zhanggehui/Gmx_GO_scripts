#!/bin/bash

# run in root dir
ttotal=5000000       #fs
tstep=5000000        #fs
pressure=1000           #Mpa
nvtequdir=nvtequ

############################################################
#first initialization
#source command executed in current shell so pay attentation to environment variable
echo "pressure: $pressure" > ./$rundir/waternumber
echo '' >> ./$rundir/waternumber
echo 'stepnum   count   acceleration' >> ./$rundir/waternumber
numofcycle=$(($ttotal/$tstep))

#run cycle
chmod +x ./scripts/findwatersinlayer.sh
rm -rf ${rundir}recordcycle
cp waterlayer.ndx $rundir
mdpdir=./$rundir/${rundir}mdps
ndxdir=./$rundir/${rundir}ndxs
mkdir $mdpdir
mkdir $ndxdir

mv ./$nvtequdir/nvt-equ.gro ./$nvtequdir/nvt-step-0.gro
mv ./$nvtequdir/nvt-equ.cpt ./$nvtequdir/nvt-step-0.cpt

mdpfile=./scripts/nvt-cycle.mdp

#posregro=./$nvtequdir/nvt-step-0.gro

for((i=1;i<=$numofcycle;i++))
do

tprname=nvt-step-$i.tpr

if [ $i -eq 1 ]
then
lastgro=./$nvtequdir/nvt-step-0.gro
lastcpt=./$nvtequdir/nvt-step-0.cpt
else
lastgro=./$rundir/nvt-step-$((i-1)).gro
lastcpt=./$rundir/nvt-step-$((i-1)).cpt
fi

tinit=$((i-1))
resettinit="tinit                    = $tinit"
sed -i "/tinit/c$resettinit" $mdpfile

./scripts/findwatersinlayer.sh $lastgro ./$rundir/waterlayer.ndx $i $ndxdir $orientation $pressure $mdpfile

gmx grompp -f $mdpfile -c $lastgro -t $lastcpt \
-p GO2.top -o ./$rundir/$tprname -po $mdpdir/step$i -n ./$rundir/waterlayer.ndx
# -r $posregro   -maxwarn 1

cd $rundir
$gmxrun -v -deffnm ${tprname%.*}
cd ..

echo $i >> ${rundir}recordcycle

done

cd $rundir
gmx trjcat -f *.trr -o nvt-pro-traj.trr
cd ..

#####after run#############################
rm -rf ./$rundir/tmp
mv ${rundir}recordcycle ./$rundir/recordcycle
mv ./$rundir/nvt-step-$numofcycle.gro ./$rundir/last.gro
mv ./$rundir/nvt-step-1.tpr ./$rundir/traj.tpr
rm -rf ./$rundir/*.edr
rm -rf ./$rundir/*.log
rm -rf ./$rundir/*.cpt
rm -rf ./$rundir/nvt-step-*.trr
rm -rf ./$rundir/nvt-step-*.gro
rm -rf ./$rundir/nvt-step-*.tpr
