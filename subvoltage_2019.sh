scriptsdir='scripts'

#shut off pressure
word="pressure=" ; new="pressure=0     #Mpa"
sed -i "/$word/c$new" ./scripts/cycle-run.sh

#需要增加一个机制：启用一种前，先关闭另外一种
#2019版
word="electric-field-y"
#507老版
#word="E-y                      ="

#0.x V
for ((i=1;i<17;i++)); do
    export i 
    e_amplitude=`awk 'BEGIN{ i=ENVIRON["i"]; printf("%s",0.1*i); }'`
    
    #2019版
    new="electric-field-y         = ${e_amplitude} 0 0 0"
    #507老版
    #new="E-y                      =  1  ${e_amplitude}  0"
    
    sed -i "/$word/c$new" ./scripts/nvt-cycle.mdp
    source ./scripts/auto-run.sh cycle-run.sh 0Mpa-${e_amplitude}V
done
