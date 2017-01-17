#!/bin/bash
pdftotext -layout Selection\ ETF\ gratuits.pdf
cat Selection\ ETF\ gratuits.txt  | sed 's/\f//' | egrep --color '[A-Z]{2}[A-Z0-9]{9}[0-9]' | sed -e 's/^ \+//' -e 's/  \+/\t/g'  > degiro_ETF_gratuits.txt

# Resolve ISIN codes to something that allows us to make out the index
(cat degiro_ETF_gratuits.txt | awk '{print $1}' | while read ISIN
do
	universe="FR-prof"

	case "$ISIN" in 
		US*)
			#etfinfo.com does not have US ETFs XXX wtf
			echo -e $ISIN\\tUNKNOWN
			continue
			;;
		NL*)
			universe="NL-prof"
			;;
		FR*)
			universe="FR-prof"
			;;
		IE*)
			universe="IE-prof"
			;;
	esac

	title=$(curl -s -b "DisclaimerAccepted=true;DisplayUniverse=$universe" http://www.etfinfo.com/en/product/$ISIN | sed -n '/<title>/,/<\/title>/p' | sed -e 's/<.\?title>//' -e 's/\ ([0-9A-Z]\+) | etfinfo.*//') 
	if [ -z "$title" ]; then
		# unknown fund in that universe
		title="UNKNOWN"
	fi

	echo -e $ISIN\\t$title
	sleep 1
done) > resolved_ISIN.txt

cat resolved_ISIN.txt | cut -f2 | paste degiro_ETF_gratuits.txt - | awk -F $'\t' 'BEGIN { OFS=FS } {printf("%s\t%s\t%s\t%s\t%s\n",$1, $5, $3,$4, $2);}' > final_list.txt

