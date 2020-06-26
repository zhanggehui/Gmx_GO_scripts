#!/bin/bash

grofile=$1
ndxfile=$2
export stepnum=$3
ndxdir=$4
export ori=$5
export pre=$6
mdpfile=$7

oldndxfile="./$rundir/$stepnum.ndx"

mv $ndxfile $oldndxfile

export boxlengthline=$(sed  -n '$p'  $grofile)

awk '
    BEGIN{pr=1;}
  
    {
    if(pr==1)
    {print $0  ;}
    if(match($0, /waterlayer/))
    {pr=0;}
    }
    
   ' $oldndxfile > $ndxfile

mv $oldndxfile $ndxdir

    awk '
        BEGIN{
        dir=ENVIRON["rundir"];
        orientation=ENVIRON["ori"];
        orientation=orientation+0;
        if(orientation==1)
        {p1=21;pbox1=1;pbox2=11;pbox3=21;}
        else if(orientation==2)
        {p1=29;pbox1=11;pbox2=1;pbox3=21;}
        else
        {p1=37;pbox1=21;pbox2=1;pbox3=11;}
        len=substr(ENVIRON["boxlengthline"],pbox1,10);
        len=len+0;
        araalen1=substr(ENVIRON["boxlengthline"],pbox2,10);
        araalen1=araalen1+0;
        araalen2=substr(ENVIRON["boxlengthline"],pbox3,10);
        araalen2=araalen2+0;
        area=araalen1*araalen2;
        coord=0; count=0;
        acceleration=0;
        presseure=ENVIRON["pre"];
        presseure=presseure+0;
        thick=1;   
       }
        
        {
          coord=substr($0,p1,8);
          coord=coord+0;
          if( match($0, /OW/) && ( coord<thick || coord>(len-thick) ) )
          {
          count++;
          serial=substr($0,16,5);
          if(count%15!=0)
              {printf("%5s ", serial) ;}
          else
              {printf("%5s\n", serial) ;}
          }
        }
        
        END{
         acceleration=0.602*presseure*area/(count*18);
         print acceleration > dir"""/tmp" ;
         print (ENVIRON["stepnum"], count, acceleration) >> dir"""/waternumber" ;
          }
          ' $grofile >> $ndxfile

echo '' >> $ndxfile

acceleration=$(sed -n '1p' ./$rundir/tmp)
str1=accelerate
if [ $ori -eq 1 ]
then
str2="accelerate               = $acceleration 0 0"
elif [ $ori -eq 2 ]
then
str2="accelerate               = 0 $acceleration 0"
else
str2="accelerate               = 0 0 $acceleration"
fi
sed -i "/$str1/c$str2" $mdpfile

