ionname=LI
mkdir ../${ionname}_traj
for ((i=1;i<20;i++))
do
    cd ./${i}00Mpa-0V
    trajname=${ionname}${i}00Mpa-0V.gro
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o $trajname \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cp -rf  $trajname ../../${ionname}_traj
    cd ..
done
romote='liufeng_zgh@10.100.1.88:/10.100.1.5/liufeng_pkuhpc/'
mydir='home/liufeng_pkuhpc/lustre2/zgh/zgh_4laGO/final4la/'
trajdir=$romote$mydir${ionname}_traj/
macbookdir='/Users/zhanggehui/Desktop/final4laGO2/receive'
scp -r $romotedir $macbookdir
