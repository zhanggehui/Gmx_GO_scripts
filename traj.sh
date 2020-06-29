
for ((i=2,i<11,i++))
do
indexstr=$((0.1*$i))
cd ./0Mpa-${indexstr}V
echo '4' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o CL0Mpa-${indexstr}V.gro -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cd ..
done



