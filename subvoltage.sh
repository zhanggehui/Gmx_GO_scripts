
for ((i=1;i<7;i++))
do
word="E-y                      ="
new="E-y                      =  1  1.${i}  0"
sed -i "/$word/c$new" ./scripts/nvt-cycle.mdp
source ./scripts/auto-run.sh cycle-run.sh 0Mpa-0.${i}V
#echo $(sed -n '1p' ./${i}00Mpa-0V/waternumber)
done



