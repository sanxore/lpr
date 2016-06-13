#!/bin/bash
echo "
###########################################################################
###########################################################################
########################~~OCP IFA PDF PARSER~~#############################
###########################################################################
###########################################################################
"
if [ "$#" -ne 1 ]; then
    echo "usage > Bash Parser.sh /Source_Folder_Path


    "
else
for full in $1/*
do
filename="${full##*/}"
year=$(echo $filename| cut -d'_' -f 4)
quart=$(echo $filename| cut -d'_' -f 5)
typ=$(echo $filename| cut -d '_' -f 6)
typ=$(echo $typ| cut -d '.' -f 1)
typ='_'$typ
mkdir 2>/dev/null DEST 2>/dev/null 
annee=$year
year="DEST/"$year
mkdir 2>/dev/null $year 2>/dev/null 
mkdir 2>/dev/null $year/$quart
mkdir 2>/dev/null $year/$quart/ROCK
mkdir 2>/dev/null $year/$quart/ROCK/ALL$typ
mkdir 2>/dev/null $year/$quart/ROCK/ALL$typ/EXPORTS
mkdir 2>/dev/null $year/$quart/ROCK/ALL$typ/EXPORTS/Dones_PDF



echo "
###########################################################################
########################~~Parsing $annee -- $quart$typ~~#########################
###########################################################################"
Npage=$(pdftk $full dump_data 2>/dev/null | grep NumberOfPages | cut -d ' ' -f 2 )
page=1
flag=0
typ=$typ"/EXPORTS"
while [ $page -le $Npage ]
do
drap=0
while [[ $flag == 0 ]]; do
pdftotext -f $page -l $page -x 0 -y 0 -W 700 -H 50 $full tmp.txt
out=$(cat tmp.txt)
if [[ "$out" == *Destination* ]]; then
flag=1
else
page=$((page+1))
fi
done
pdftotext -f $page -l $page -x 0 -y 0 -W 700 -H 50 $full tmp.txt
out=$(cat tmp.txt)
if [[ "$out" == *Destination* ]]; then
if [[ "$out" == *All* ]]; then
grade="ALL"
drap=1
fi

if [[ $drap == 1 ]]; then

grade="ROCK/"$grade

pdfseparate -f $page -l $page $full $year/$quart/$grade$typ/%d.pdf
python /opt/table_detector/TableDetector.py $year/$quart/$grade$typ/$page.pdf $year/$quart/$grade$typ/$page.csv
mv $year/$quart/$grade$typ/$page.pdf $year/$quart/$grade$typ/Dones_PDF

echo "Pars_Sucess "$page"_"$grade$typ
#statements
fi
page=$((page+1))
else
page=$((page+1))
fi

done
rm tmp.txt
done
fi


####################################

for year in DEST/*
do
for quart in $year/*
do
DIR=$quart"/ROCK"
if [ -d "$DIR" ]; then
quart=$quart"/ROCK"
for prod in $quart/*
do
prod=$prod"/EXPORTS"
min=$(ls -1v $prod | head -1 | head -c -1 | cut -d '.' -f 1)
max=$(ls -1v $prod | tail -2 | head -1 | head -c -1 | cut -d '.' -f 1)
mkdir 2>/dev/null $prod/DONES_CSV
echo "
import sys
import csv
def main(argv):
   with open(sys.argv[1],'rb') as f:
      reader=csv.reader(f)
      CARS=list(reader)
   with open(sys.argv[2],'rb') as f2:
         reader2=csv.reader(f2)
         CDRS=list(reader2)

   for car in CARS:
      index = CARS.index(car)
      for item in CDRS[index][1:]:
      car.append(item)
      print ','.join(car)
if __name__ == '__main__':
   main(sys.argv)" > $prod/tmp.py

CAR=$min
while [[ $CAR -lt $max ]]; do
BU=$CAR
CDR=$((CAR+1))
CAR=$CAR".csv"
CDR=$CDR".csv"
python $prod/tmp.py $prod/$CAR $prod/$CDR >> $prod/tmp.csv 2>/dev/null
mv $prod/$CAR $prod/DONES_CSV
mv $prod/$CDR $prod/DONES_CSV
mv $prod/tmp.csv $prod/$CAR
CAR=$((BU+2))
done
rm $prod/tmp.py

done
fi
done
done

#######################################
#######################################

for year in DEST/*
do
yy="${year##*/}"
yy_1=$((yy-1))
yy_2=$((yy-2))
for quart in $year/*
do

DIR=$quart"/ROCK"
if [ -d "$DIR" ]; then
QQ=$quart
quart=$quart"/ROCK"
for prod in $quart/*
do

mkdir 2>/dev/null $prod/EXPORTS/DONES_CSV/COMP
prodname="${prod##*/}"
target=$(ls -1v $prod/EXPORTS | head -1 | head -c -1)
echo "Please Enter $prodname BPL ROCK Exporting Countries for "$quart". Seperated with ',' followed by [ENTER]"
read mga
sed -i "1 i\Countries,$mga,T$yy,T$yy_1,T$yy_2" $prod/EXPORTS/$target
var=$(ls -l $prod/EXPORTS | wc -l)
while [ "$var" -ge  "5" ]
do
next=$(ls -1v $prod/EXPORTS | head -2 | tail -1)
cat $prod/EXPORTS/$next >> $prod/EXPORTS/$target
mv $prod/EXPORTS/$next $prod/EXPORTS/DONES_CSV/COMP
#echo "done $next"
var=$(ls -l $prod/EXPORTS | wc -l)
done
mv $prod/EXPORTS/$target $prod/EXPORTS/data.csv
echo "done $prod"
done
for rr in $QQ/ROCK/*
do
rd="${rr##*/}"
dyp=$(echo $rd | cut -d '_' -f 2)
dyp="_"$dyp
mv $rr $QQ/ROCK$dyp
done 
rm -rf $QQ/ROCK

fi
done
done
echo "
###########################################################################
###########################################################################
########################~~OCP IFA PDF PARSER~~#############################
###########################################################################
###########################################################################
"