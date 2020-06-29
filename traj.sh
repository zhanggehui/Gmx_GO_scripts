
for ((i=2;i<10;i++))
do
indexstr=$(echo "$i*0.1" | bc)
cd ./0Mpa-${indexstr}V
echo '4' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o CL0Mpa-0${indexstr}V.gro -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx
cd ..
done



