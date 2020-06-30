
for ((i=1;i<10;i++))
do
#cd ./0Mpa-0.${i}V
#echo '4' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o CL0Mpa-0.${i}V.gro -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx

#cd ./${i}00Mpa-0V
#echo '4' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o CL${i}00Mpa-0V.gro -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx

cd ./1${i}00Mpa-0V
echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o NA1${i}00Mpa-0V.gro -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx

#cd ./0Mpa-0.${i}V
#echo '3' | gmx trjconv -f nvt-pro-traj.trr -s traj.tpr -o CA0Mpa-0.${i}V.gro -pbc nojump -b 0 -e 5000 -skip 5000 -n waterlayer.ndx

cd ..
done



