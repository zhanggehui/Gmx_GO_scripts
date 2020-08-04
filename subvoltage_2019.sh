#shut off pressure
word="pressure=" ; new="pressure=0     #Mpa"
sed -i "/$word/c$new" ./scripts/cycle-run.sh

#0.x V
#for ((i=1;i<10;i++))
#do
#word="electric-field-y"
#new="electric-field-y         = 0.${i} 0 0 0"
#sed -i "/$word/c$new" ./scripts/nvt-cycle.mdp
#source ./scripts/auto-run.sh cycle-run.sh 0Mpa-0.${i}V
#done

#1V
#word="electric-field-y"
#new="electric-field-y         = 1 0 0 0"
#sed -i "/$word/c$new" ./scripts/nvt-cycle.mdp
#source ./scripts/auto-run.sh cycle-run.sh 0Mpa-1V

#1.x V
for ((i=1;i<7;i++))
do
word="electric-field-y"
new="electric-field-y         = 1.${i} 0 0 0"
sed -i "/$word/c$new" ./scripts/nvt-cycle.mdp
source ./scripts/auto-run.sh cycle-run.sh 0Mpa-1.${i}V
done



