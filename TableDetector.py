import sys
import string
from pdftables import get_tables
import csv


def main(argv):
    f = open(argv[1], "rb")
    result = get_tables(f)
    with open(argv[2], "wb") as f:
        for sublist in result:
            for subsublist in sublist:
            	flag1=0
            	flag2=0
            	count=0
            	subsublist2=[]
            	tmp_sublist=[]
                writer = csv.writer(f)
                if(subsublist[0]!='' and subsublist[1]=='' and subsublist[2]=='' and subsublist[3]==''):
               		flag1=1
               	for item in subsublist:
               		if item == '-':
               			count+=1
                if(count>=2):
                	flag2=1
                if(not flag1):
                	for item in subsublist:
                		if(item != ''):
                			subsublist2.append(item)
                	subsublist=subsublist2
                if(flag1 or flag2):
                	for elem in subsublist:
                		elem=elem.replace(",","/")
                		tmp_sublist.append(elem)
                	writer.writerow(tmp_sublist)


if __name__ == '__main__':
    main(sys.argv)
