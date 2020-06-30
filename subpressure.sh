
for ((i=1;i<10;i++))
do
word="pressure=" ; new="pressure=${i}00Mpa"
sed -i "/$word/c$new" ./scripts/cycle-run.sh
source ./scripts/auto-run.sh cycle-run.sh ${i}00Mpa-0V
#echo $(sed -n '1p' ./${i}00Mpa-0V/waternumber)
done



