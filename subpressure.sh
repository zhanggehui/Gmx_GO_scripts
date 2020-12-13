scriptsdir='scripts'
subpressure=1 #1代表压强任务，0代表电压任务

if [ subpressure -ne 0 ]; then
    #shut off electric-field-y
    word='electric-field-y' ; new=';electric-field-y         = 0 0 0 0'
    sed -i "/$word/c$new" ./$scriptsdir/nvt-cycle.mdp

    word='pressure='
    for ((i=0;i<20;i++)); do
        export i 
        pressure=`awk 'BEGIN{ i=ENVIRON["i"]; printf("%s",100*i); }'`   
        new="pressure=$pressure     #Mpa"
        sed -i "/$word/c$new" ./$scriptsdir/cycle-run.sh
        source ./$scriptsdir/auto-run.sh cycle-run.sh ${pressure}Mpa-0V
    done
else
    #shut off pressure
    word="pressure=" ; new="pressure=0     #Mpa"
    sed -i "/$word/c$new" ./scripts/cycle-run.sh

    #需要增加一个机制：启用一种前，先关闭另外一种
    word="electric-field-y"    #2019版
    #word="E-y                      ="       #507老版

    #0.x V
    for ((i=1;i<17;i++)); do
        export i 
        e_amplitude=`awk 'BEGIN{ i=ENVIRON["i"]; printf("%s",0.1*i); }'`
        new="electric-field-y         = ${e_amplitude} 0 0 0"     #2019版
        #new="E-y                      =  1  ${e_amplitude}  0"         #2019版
        
        sed -i "/$word/c$new" ./scripts/nvt-cycle.mdp
        source ./scripts/auto-run.sh cycle-run.sh 0Mpa-${e_amplitude}V
    done
fi