for ((i=1;i<10;i++))
do
word="E-y                      ="
new="E-y                      =  1  0.${i}  0"
sed -i "/$word/c$new" ./scripts/nvt-cycle.mdp
source ./scripts/auto-run.sh cycle-run.sh 0Mpa-0.${i}V
done

word="E-y                      ="
new="E-y                      =  1  1  0"
sed -i "/$word/c$new" ./scripts/nvt-cycle.mdp
source ./scripts/auto-run.sh cycle-run.sh 0Mpa-1V

for ((i=1;i<7;i++))
do
word="E-y                      ="
new="E-y                      =  1  1.${i}  0"
sed -i "/$word/c$new" ./scripts/nvt-cycle.mdp
source ./scripts/auto-run.sh cycle-run.sh 0Mpa-1.${i}V
done


