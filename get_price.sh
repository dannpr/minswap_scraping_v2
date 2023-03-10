#!/bin/bash


curl https://minswap.org/ > ./minpage.txt
echo "Currently running ..."
echo "This is the current  price of MIN" > ./minprice.txt
echo " " >> ./minprice.txt

#Get price data
token_name=$(cat minpage.txt | grep -Po '(?<=class="jet-listing-dynamic-field__content">).*?(?<=MIN)')
token_name="${token_name:4}"
echo "Name: $token_name">>./minprice.txt

token_price=$(cat minpage.txt | grep -Poz '(?<=class="jet-listing-dynamic-field__content">).*?(?<=₳)' | awk '{print $1}')
echo "Price: $token_price "'₳'>>./minprice.txt

if [ ! -s mindata.csv ]; then
	echo "price,date" >./mindata.csv
else
	echo "$token_price,"| tr -d '\n' >>./mindata.csv
	date >>./mindata.csv 
fi

echo " ">>./minprice.txt 

date >>./minprice.txt 

cat minprice.txt

MESSAGE=$(cat minprice.txt)
echo "Sending the price to your telegram chat"

TOKEN='5681540714:AAEXiIvabIGfHoGS4yxIRHJjH7NGWyJkJfc'
CHAT_ID='1506500267'
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$MESSAGE"

# Connect to SQLite database and insert data
sqlite3 dbPrice.db <<EOF
CREATE TABLE IF NOT EXISTS dbPrice (price text, date text);
INSERT INTO dbPrice (price, date) VALUES ('$token_price', '$date');
SELECT * FROM dbPrice;
EOF

echo "Finito"
