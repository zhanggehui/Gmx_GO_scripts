ScriptsDir='scripts'

#shut off electric-field-y
word='electric-field-y' ; new=';electric-field-y         = 0 0 0 0'
sed -i "/$word/c$new" ./$ScriptsDir/nvt-cycle.mdp

#0V-0Mpa
word="pressure=" ; new="pressure=0     #Mpa"
sed -i "/$word/c$new" ./$ScriptsDir/cycle-run.sh
source ./$ScriptsDir/auto-run.sh cycle-run.sh 0Mpa-0V

for ((i=1;i<5;i++))
do
    word="pressure=" ; new="pressure=${i}00     #Mpa"
    sed -i "/$word/c$new" ./$ScriptsDir/cycle-run.sh
    source ./$ScriptsDir/auto-run.sh cycle-run.sh ${i}00Mpa-0V
done

#source ./scripts/subvoltage_2019.sh
