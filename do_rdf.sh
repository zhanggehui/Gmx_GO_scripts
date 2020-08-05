source /appsnew/mdapps/gromacs2019.2_intelmkl2019u4/bin/GMXRC2.bash
ions=("CS" "LI" "NA" "K" "CA" "MG")
num=${#ions[@]}
rdfdir=rdfs
if [ ! -d $rdfdir ] ; then
mkdir $rdfdir

for((i=0;i<$num;i++)) ; do
ion=${ions[$i]}
cd ./$ion/nvtequ
grofile=nvt-step-0.gro ; xvgfile=$ion_rdf.xvg
gmx make_ndx -f $grofile < ../../md_scripts/rdf_ndx.sh
gmx rdf -f $grofile -n index.ndx -ref $ion -sel OW -selrpos atom -seltype atom -o $xvgfile
mv $xvgfile ../../$rdfdir
cd ../../
done

else
echo "already exits!"
fi
