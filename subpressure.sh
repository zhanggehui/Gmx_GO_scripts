
for ((i=1;i<10;i++))
do
word="pressure=" ; new="pressure=1${i}00     #MPa"
sed -i "/$word/c$new" ./scripts/cycle-run.sh
source ./scripts/auto-run.sh cycle-run.sh re1${i}00Mpa-0V
done



