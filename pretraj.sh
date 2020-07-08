
ionname=CS

for ((i=1;i<20;i++))
do
    cd ./${i}00Mpa-0V
    echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o ${ionname}${i}00Mpa-0V.gro \
    -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
    cd ..
done
