source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash
ionname=LI

if [ ! -d ${ionname}_traj ]
then
mkdir ../${ionname}_traj
fi

cd ./0Mpa-0V
echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o ${ionname}0Mpa-0V \
-pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cp -rf  ${ionname}0Mpa-0V ../../${ionname}_traj
cd ..

for ((i=1;i<20;i++))
do
    cd ./${i}00Mpa-0V
    trajname=${ionname}${i}00Mpa-0V.gro
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $trajname ../../${ionname}_traj
    cd ..
done

source ./scripts/voltage_traj.sh

romote='liufeng_zgh@10.100.1.88:/10.100.1.5/liufeng_pkuhpc/'
mydir='home/liufeng_pkuhpc/lustre2/zgh/zgh_4laGO/final4la/'
trajdir=$romote$mydir${ionname}_traj/
macbookdir='/Users/zhanggehui/Desktop/final4laGO2/receive'
scp -r $romotedir $macbookdir


