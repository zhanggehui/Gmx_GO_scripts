#0V-0Mpa
word="pressure=" ; new="pressure=0     #Mpa"
sed -i "/$word/c$new" ./scripts/cycle-run.sh
source ./scripts/auto-run.sh cycle-run.sh 0Mpa-0V

for ((i=1;i<20;i++))
do
    word="pressure=" ; new="pressure=${i}00     #Mpa"
    sed -i "/$word/c$new" ./scripts/cycle-run.sh
    source ./scripts/auto-run.sh cycle-run.sh ${i}00Mpa-0V
done
