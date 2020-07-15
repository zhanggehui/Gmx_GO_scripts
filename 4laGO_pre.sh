source /home/liufeng_pkuhpc/gmx-zs.sh
ion=LI
mv GO2-${ion}.gro GO2-ion.gro
mv GO2-${ion}.top GO2.top
gmx make_ndx -f GO2-ion.gro -o waterlayer.ndx  < ./scripts/ndxcommands.sh

#em
source ./scripts/auto-run.sh em.sh em
