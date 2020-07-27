source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash

spacing=1.1

#rm -rf ../lay${spacing}_traj
if [ ! -d lay${spacing}_traj ] ; then
mkdir ../lay${spacing}_traj

cd ./0Mpa-0V
echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o ${spacing}0Mpa-0V.gro \
-pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cp -rf  ${spacing}0Mpa-0V.gro ../../lay${spacing}_traj
rm  -rf \#*
cd ..

for ((i=1;i<20;i++))
do
    cd ./${i}00Mpa-0V
    trajname=${spacing}${i}00Mpa-0V.gro
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $trajname ../../lay${spacing}_traj
    rm  -rf \#*
    cd ..
done

source ./scripts/voltage_traj.sh

else
echo 'already exists!'
fi

