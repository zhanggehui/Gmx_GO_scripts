ionname=CS

for((k=0;k<2;k++))
do
    for ((i=1;i<10;i++))
    do
        cd ./0Mpa-${k}.${i}V
        echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o ${ionname}0Mpa-${k}.${i}V.gro \
        -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
        cd ..
    done
done

cd ./0Mpa-1V
echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o ${ionname}0Mpa-1V.gro \
-pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cd ..
