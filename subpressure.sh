
for ((i=7;i<10;i++))
do
word="pressure=" ; new="pressure=${i}00     #MPa"
sed -i "/$word/c$new" ./scripts/cycle-run.sh
source ./scripts/auto-run.sh cycle-run.sh ${i}00Mpa-0V
done



