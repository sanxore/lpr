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
CAS=$(echo $filename | cut -d '_' -f 1)
if [[ "$CAS" == "PROCESSED" ]]; then

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
mkdir 2>/dev/null $year/$quart/MGA$typ
mkdir 2>/dev/null $year/$quart/MGA$typ/PROD
mkdir 2>/dev/null $year/$quart/MGA$typ/EXPORTS
mkdir 2>/dev/null $year/$quart/MGA$typ/PROD/Dones_PDF
mkdir 2>/dev/null $year/$quart/MGA$typ/EXPORTS/Dones_PDF
mkdir 2>/dev/null $year/$quart/MAP$typ
mkdir 2>/dev/null $year/$quart/MAP$typ/PROD
mkdir 2>/dev/null $year/$quart/MAP$typ/EXPORTS
mkdir 2>/dev/null $year/$quart/MAP$typ/PROD/Dones_PDF
mkdir 2>/dev/null $year/$quart/MAP$typ/EXPORTS/Dones_PDF
mkdir 2>/dev/null $year/$quart/DAP$typ
mkdir 2>/dev/null $year/$quart/DAP$typ/PROD
mkdir 2>/dev/null $year/$quart/DAP$typ/EXPORTS
mkdir 2>/dev/null $year/$quart/DAP$typ/PROD/Dones_PDF
mkdir 2>/dev/null $year/$quart/DAP$typ/EXPORTS/Dones_PDF
mkdir 2>/dev/null $year/$quart/TSP$typ
mkdir 2>/dev/null $year/$quart/TSP$typ/PROD
mkdir 2>/dev/null $year/$quart/TSP$typ/EXPORTS
mkdir 2>/dev/null $year/$quart/TSP$typ/PROD/Dones_PDF
mkdir 2>/dev/null $year/$quart/TSP$typ/EXPORTS/Dones_PDF
echo "
###########################################################################
########################~~Parsing $annee -- $quart$typ~~#########################
###########################################################################"
Npage=$(pdftk $full dump_data 2>/dev/null | grep NumberOfPages | cut -d ' ' -f 2 )
page=1
flag=0
while [ $page -le $Npage ]
do

	while [[ $flag == 0 ]]; do
		pdftotext -f $page -l $page -x 0 -y 0 -W 700 -H 50 $full tmp2.txt
		out=$(cat tmp2.txt)
		if [[ "$out" == *Deliveries* ]]; then
		flag=1
		else
		page=$((page+1))
		fi
	done
	pdftotext -f $page -l $page -x 0 -y 0 -W 700 -H 50 $full tmp2.txt
	out=$(cat tmp2.txt)
	if [[ "$out" == *Acid* ]]; then
			if [[ "$out" == *Deliveries* ]]
			then
				pdfseparate -f $page -l $page $full $year/$quart/MGA$typ/PROD/%d.pdf
				#python /opt/table_detector/TableDetector.py $year/$quart/MGA$typ/PROD/$page.pdf $year/$quart/MGA$typ/PROD/$page.csv
				#mv $year/$quart/MGA$typ/PROD/$page.pdf $year/$quart/MGA$typ/PROD/Dones_PDF
				echo "Pars_Sucess "$page"MGA$typ_PROD"
			else
				pdfseparate -f $page -l $page $full $year/$quart/MGA$typ/EXPORTS/%d.pdf
				python /opt/table_detector/TableDetector.py $year/$quart/MGA$typ/EXPORTS/$page.pdf $year/$quart/MGA$typ/EXPORTS/$page.csv
				mv $year/$quart/MGA$typ/EXPORTS/$page.pdf $year/$quart/MGA$typ/EXPORTS/Dones_PDF

				echo "Pars_Sucess "$page"MGA$typ_EXPORT"	
			fi

	elif [[ "$out" == *MAP* ]]; then
			if [[ "$out" == *Deliveries* ]]
			then
				pdfseparate -f $page -l $page $full $year/$quart/MAP$typ/PROD/%d.pdf
				#python /opt/table_detector/TableDetector.py $year/$quart/MAP$typ/PROD/$page.pdf $year/$quart/MAP$typ/PROD/$page.csv
				#mv $year/$quart/MAP$typ/PROD/$page.pdf $year/$quart/MAP$typ/PROD/Dones_PDF
				echo "Pars_Sucess "$page"MAP$typ_PROD"
			else
				pdfseparate -f $page -l $page $full $year/$quart/MAP$typ/EXPORTS/%d.pdf
				python /opt/table_detector/TableDetector.py $year/$quart/MAP$typ/EXPORTS/$page.pdf $year/$quart/MAP$typ/EXPORTS/$page.csv
				mv $year/$quart/MAP$typ/EXPORTS/$page.pdf $year/$quart/MAP$typ/EXPORTS/Dones_PDF
				echo "Pars_Sucess "$page"MAP$typ_EXPORT"	
			fi


	elif [[ "$out" == *DAP* ]]; then
			if [[ "$out" == *Deliveries* ]]
			then
				pdfseparate -f $page -l $page $full $year/$quart/DAP$typ/PROD/%d.pdf
				#python /opt/table_detector/TableDetector.py $year/$quart/DAP$typ/PROD/$page.pdf $year/$quart/DAP$typ/PROD/$page.csv
				#mv $year/$quart/DAP$typ/PROD/$page.pdf $year/$quart/DAP$typ/PROD/Dones_PDF
				echo "Pars_Sucess "$page"DAP$typ_PROD"
			else
				pdfseparate -f $page -l $page $full $year/$quart/DAP$typ/EXPORTS/%d.pdf
				python /opt/table_detector/TableDetector.py $year/$quart/DAP$typ/EXPORTS/$page.pdf $year/$quart/DAP$typ/EXPORTS/$page.csv
				mv $year/$quart/DAP$typ/EXPORTS/$page.pdf $year/$quart/DAP$typ/EXPORTS/Dones_PDF
				echo "Pars_Sucess "$page"DAP$typ_EXPORT"	
			fi


	elif [[ "$out" == *TSP* ]]; then
			if [[ "$out" == *Deliveries* ]]
			then
				pdfseparate -f $page -l $page $full $year/$quart/TSP$typ/PROD/%d.pdf
				#python /opt/table_detector/TableDetector.py $year/$quart/TSP$typ/PROD/$page.pdf $year/$quart/TSP$typ/PROD/$page.csv
				#mv $year/$quart/TSP$typ/PROD/$page.pdf $year/$quart/TSP$typ/PROD/Dones_PDF
				echo "Pars_Sucess "$page"TSP$typ_PROD"
			else
				pdfseparate -f $page -l $page $full $year/$quart/TSP$typ/EXPORTS/%d.pdf
				python /opt/table_detector/TableDetector.py $year/$quart/TSP$typ/EXPORTS/$page.pdf $year/$quart/TSP$typ/EXPORTS/$page.csv
				mv $year/$quart/TSP$typ/EXPORTS/$page.pdf $year/$quart/TSP$typ/EXPORTS/Dones_PDF
				echo "Pars_Sucess "$page"TSP$typ_EXPORT"	
			fi
	else
		page=$((Npage+1))
	fi	
	page=$((page+1))
done
rm tmp2.txt
done


for year in DEST/*
do
	yy="${year##*/}"
yy_1=$((yy-1))
yy_2=$((yy-2))
for quart in $year/*
do
	DIR=$quart"/MAP_DET"
	DIR2=$quart"/MAP_AGG"
	if [[ -d "$DIR" || -d "$DIR2" ]]; then
	for prod in $quart/*
	do
		if [[ "$prod" != *ROCK* ]]; then
		prodname="${prod##*/}"
		typx=$(echo $prodname| cut -d '_' -f 2)
		typx=$(echo $typx| cut -d '.' -f 1)
		typx='_'$typx
		mkdir 2>/dev/null $prod/EXPORTS/Dones_CSV
		target=$(ls -1v $prod/EXPORTS/ | head -1 | head -c -1)
		if [[ $prod == *MGA* ]]
		then
			echo "Please Enter Acid$typx Exporting Countries for "$quart". Seperated with ',' followed by [ENTER]"
			read mga
			sed -i "1 i\Countries,$mga,T$yy,T$yy_1,T$yy_2" $prod/EXPORTS/$target
		elif [[ $prod == *MAP* ]]
		then
			echo "Please Enter MAP$typx Exporting Countries for "$quart". Seperated with ',' followed by [ENTER]"
			read map
			sed -i "1 i\Countries,$map,T$yy,T$yy_1,T$yy_2" $prod/EXPORTS/$target
		elif [[ $prod == *DAP* ]]
		then
			echo "Please Enter DAP$typx Exporting Countries for "$quart". Seperated with ',' followed by [ENTER]"
			read dap
			sed -i "1 i\Countries,$dap,T$yy,T$yy_1,T$yy_2" $prod/EXPORTS/$target
		else
			echo "Please Enter TSP$typx Exporting Countries for "$quart". Seperated with ',' followed by [ENTER]"
			read tsp
			sed -i "1 i\Countries,$tsp,T$yy,T$yy_1,T$yy_2" $prod/EXPORTS/$target
		fi
		var=$(ls -l $prod/EXPORTS | wc -l)
		while [ "$var" -ge  "5" ]
		do
		next=$(ls -1v $prod/EXPORTS | head -2 | tail -1)
		cat $prod/EXPORTS/$next >> $prod/EXPORTS/$target
		mv $prod/EXPORTS/$next $prod/EXPORTS/Dones_CSV
		#echo "done $next"
		var=$(ls -l $prod/EXPORTS | wc -l)
		done
	mv $prod/EXPORTS/$target $prod/EXPORTS/data.csv
	echo "done $prod"
fi
	done
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
	#statements
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
mkdir 2>/dev/null $year/$quart/MGA$typ
mkdir 2>/dev/null $year/$quart/MGA$typ/PROD
mkdir 2>/dev/null $year/$quart/MGA$typ/EXPORTS
mkdir 2>/dev/null $year/$quart/MGA$typ/PROD/Dones_PDF
mkdir 2>/dev/null $year/$quart/MGA$typ/EXPORTS/Dones_PDF
mkdir 2>/dev/null $year/$quart/MAP$typ
mkdir 2>/dev/null $year/$quart/MAP$typ/PROD
mkdir 2>/dev/null $year/$quart/MAP$typ/EXPORTS
mkdir 2>/dev/null $year/$quart/MAP$typ/PROD/Dones_PDF
mkdir 2>/dev/null $year/$quart/MAP$typ/EXPORTS/Dones_PDF
mkdir 2>/dev/null $year/$quart/DAP$typ
mkdir 2>/dev/null $year/$quart/DAP$typ/PROD
mkdir 2>/dev/null $year/$quart/DAP$typ/EXPORTS
mkdir 2>/dev/null $year/$quart/DAP$typ/PROD/Dones_PDF
mkdir 2>/dev/null $year/$quart/DAP$typ/EXPORTS/Dones_PDF
mkdir 2>/dev/null $year/$quart/TSP$typ
mkdir 2>/dev/null $year/$quart/TSP$typ/PROD
mkdir 2>/dev/null $year/$quart/TSP$typ/EXPORTS
mkdir 2>/dev/null $year/$quart/TSP$typ/PROD/Dones_PDF
mkdir 2>/dev/null $year/$quart/TSP$typ/EXPORTS/Dones_PDF
echo "
###########################################################################
########################~~Parsing $annee -- $quart$typ~~#########################
###########################################################################"
Npage=$(pdftk $full dump_data 2>/dev/null | grep NumberOfPages | cut -d ' ' -f 2 )
page=1
flag=0
while [ $page -le $Npage ]
do

	while [[ $flag == 0 ]]; do
		pdftotext -f $page -l $page -x 0 -y 0 -W 700 -H 50 $full tmp2.txt
		out=$(cat tmp2.txt)
		if [[ "$out" == *Deliveries* ]]; then
		flag=1
		else
		page=$((page+1))
		fi
	done
	pdftotext -f $page -l $page -x 0 -y 0 -W 700 -H 50 $full tmp2.txt
	out=$(cat tmp2.txt)
	if [[ "$out" == *Acid* ]]; then
			if [[ "$out" == *Deliveries* ]]
			then
				pdfseparate -f $page -l $page $full $year/$quart/MGA$typ/PROD/%d.pdf
				#python /opt/table_detector/TableDetector.py $year/$quart/MGA$typ/PROD/$page.pdf $year/$quart/MGA$typ/PROD/$page.csv
				#mv $year/$quart/MGA$typ/PROD/$page.pdf $year/$quart/MGA$typ/PROD/Dones_PDF
				echo "Pars_Sucess "$page"MGA$typ_PROD"
			else
				pdfseparate -f $page -l $page $full $year/$quart/MGA$typ/EXPORTS/%d.pdf
				python /opt/table_detector/TableDetector.py $year/$quart/MGA$typ/EXPORTS/$page.pdf $year/$quart/MGA$typ/EXPORTS/$page.csv
				mv $year/$quart/MGA$typ/EXPORTS/$page.pdf $year/$quart/MGA$typ/EXPORTS/Dones_PDF

				echo "Pars_Sucess "$page"MGA$typ_EXPORT"	
			fi

	elif [[ "$out" == *MAP* ]]; then
			if [[ "$out" == *Deliveries* ]]
			then
				pdfseparate -f $page -l $page $full $year/$quart/MAP$typ/PROD/%d.pdf
				#python /opt/table_detector/TableDetector.py $year/$quart/MAP$typ/PROD/$page.pdf $year/$quart/MAP$typ/PROD/$page.csv
				#mv $year/$quart/MAP$typ/PROD/$page.pdf $year/$quart/MAP$typ/PROD/Dones_PDF
				echo "Pars_Sucess "$page"MAP$typ_PROD"
			else
				pdfseparate -f $page -l $page $full $year/$quart/MAP$typ/EXPORTS/%d.pdf
				python /opt/table_detector/TableDetector.py $year/$quart/MAP$typ/EXPORTS/$page.pdf $year/$quart/MAP$typ/EXPORTS/$page.csv
				mv $year/$quart/MAP$typ/EXPORTS/$page.pdf $year/$quart/MAP$typ/EXPORTS/Dones_PDF
				echo "Pars_Sucess "$page"MAP$typ_EXPORT"	
			fi


	elif [[ "$out" == *DAP* ]]; then
			if [[ "$out" == *Deliveries* ]]
			then
				pdfseparate -f $page -l $page $full $year/$quart/DAP$typ/PROD/%d.pdf
				#python /opt/table_detector/TableDetector.py $year/$quart/DAP$typ/PROD/$page.pdf $year/$quart/DAP$typ/PROD/$page.csv
				#mv $year/$quart/DAP$typ/PROD/$page.pdf $year/$quart/DAP$typ/PROD/Dones_PDF
				echo "Pars_Sucess "$page"DAP$typ_PROD"
			else
				pdfseparate -f $page -l $page $full $year/$quart/DAP$typ/EXPORTS/%d.pdf
				python /opt/table_detector/TableDetector.py $year/$quart/DAP$typ/EXPORTS/$page.pdf $year/$quart/DAP$typ/EXPORTS/$page.csv
				mv $year/$quart/DAP$typ/EXPORTS/$page.pdf $year/$quart/DAP$typ/EXPORTS/Dones_PDF
				echo "Pars_Sucess "$page"DAP$typ_EXPORT"	
			fi


	elif [[ "$out" == *TSP* ]]; then
			if [[ "$out" == *Deliveries* ]]
			then
				pdfseparate -f $page -l $page $full $year/$quart/TSP$typ/PROD/%d.pdf
				#python /opt/table_detector/TableDetector.py $year/$quart/TSP$typ/PROD/$page.pdf $year/$quart/TSP$typ/PROD/$page.csv
				#mv $year/$quart/TSP$typ/PROD/$page.pdf $year/$quart/TSP$typ/PROD/Dones_PDF
				echo "Pars_Sucess "$page"TSP$typ_PROD"
			else
				pdfseparate -f $page -l $page $full $year/$quart/TSP$typ/EXPORTS/%d.pdf
				python /opt/table_detector/TableDetector.py $year/$quart/TSP$typ/EXPORTS/$page.pdf $year/$quart/TSP$typ/EXPORTS/$page.csv
				mv $year/$quart/TSP$typ/EXPORTS/$page.pdf $year/$quart/TSP$typ/EXPORTS/Dones_PDF
				echo "Pars_Sucess "$page"TSP$typ_EXPORT"	
			fi
	else
		page=$((Npage+1))
	fi	
	page=$((page+1))
done
rm tmp2.txt
done


for year in DEST/*
do
	yy="${year##*/}"
yy_1=$((yy-1))
yy_2=$((yy-2))
for quart in $year/*
do
	DIR=$quart"/MAP_DET"
	DIR2=$quart"/MAP_AGG"
	if [[ -d "$DIR" || -d "$DIR2" ]]; then
	for prod in $quart/*
	do
		if [[ "$prod" != *ROCK* ]]; then
		prodname="${prod##*/}"
		typx=$(echo $prodname| cut -d '_' -f 2)
		typx=$(echo $typx| cut -d '.' -f 1)
		typx='_'$typx
		mkdir 2>/dev/null $prod/EXPORTS/Dones_CSV
		target=$(ls -1v $prod/EXPORTS/ | head -1 | head -c -1)
		if [[ $prod == *MGA* ]]
		then
			echo "Please Enter Acid$typx Exporting Countries for "$quart". Seperated with ',' followed by [ENTER]"
			read mga
			sed -i "1 i\Countries,$mga,T$yy,T$yy_1,T$yy_2" $prod/EXPORTS/$target
		elif [[ $prod == *MAP* ]]
		then
			echo "Please Enter MAP$typx Exporting Countries for "$quart". Seperated with ',' followed by [ENTER]"
			read map
			sed -i "1 i\Countries,$map,T$yy,T$yy_1,T$yy_2" $prod/EXPORTS/$target
		elif [[ $prod == *DAP* ]]
		then
			echo "Please Enter DAP$typx Exporting Countries for "$quart". Seperated with ',' followed by [ENTER]"
			read dap
			sed -i "1 i\Countries,$dap,T$yy,T$yy_1,T$yy_2" $prod/EXPORTS/$target
		else
			echo "Please Enter TSP$typx Exporting Countries for "$quart". Seperated with ',' followed by [ENTER]"
			read tsp
			sed -i "1 i\Countries,$tsp,T$yy,T$yy_1,T$yy_2" $prod/EXPORTS/$target
		fi
		var=$(ls -l $prod/EXPORTS | wc -l)
		while [ "$var" -ge  "5" ]
		do
		next=$(ls -1v $prod/EXPORTS | head -2 | tail -1)
		cat $prod/EXPORTS/$next >> $prod/EXPORTS/$target
		mv $prod/EXPORTS/$next $prod/EXPORTS/Dones_CSV
		#echo "done $next"
		var=$(ls -l $prod/EXPORTS | wc -l)
		done
	mv $prod/EXPORTS/$target $prod/EXPORTS/data.csv
	echo "done $prod"
fi
	done
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
fi
fi