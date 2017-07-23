echo "###################################################"
echo "#              Script Created By TSH              #"
echo "#              Bayrem Ghanmi + Fatima             #"
echo "#                   @bayrem_g                     #"
echo "#                 www.whitehats.tn                #"
echo "###################################################"

# Demand domain

domain=$(zenity --entry --text "Please enter the domain name :")


echo "###################################################" > evidence.txt
echo "#              Script Created By TSH              #" >> evidence.txt
echo "#              Bayrem Ghanmi + Fatima             #" >> evidence.txt
echo "#                   @bayrem_g                     #" >> evidence.txt
echo "#                 www.whitehats.tn                #" >> evidence.txt
echo "###################################################" >> evidence.txt
echo "$(LANG=en_US date)" >> evidence.txt
echo "Time Sync evidence " >> evidence.txt
ntpq -p  >> evidence.txt
echo "####################################################" >> evidence.txt



echo " The Domain is : $domain " >> evidence.txt

# Terminal output
echo " Getting IP of Adress ..."
# Get IP with last element of nslookup output
IP=$(nslookup $domain | tail -2 | head -1 | awk '{print $2}')
echo "IP of the Address is : $IP " >> evidence.txt

echo "########################################################" >> evidence.txt
echo "# Investigating the Domain Registry and the Registrant #" >> evidence.txt
echo "########################################################" >> evidence.txt

# Terminal output
echo "Investigating the Domain Registry and the Registrant ..."

echo "Domain Registry : " >> evidence.txt

# DNS Lookup based on domain extension

if [[ -n `echo "$domain" | grep ".com$"` ]] || [[ -n `echo "$domain" | grep ".edu$"` ]] || [[ -n `echo "$domain" | grep ".net$"` ]];then
	whois -h whois.internic.net $domain>> evidence.txt
elif [[ -n `echo "$domain" | grep ".org$"` ]];then
	whois -h whois.pir.org $domain >> evidence.txt
fi

#To do : add conditions for other domains ex : .info .biz .uk .ma etc ..

echo "Domain Owner :" >> evidence.txt

whois -h whois.iana.org $domain >> evidence.txt


echo "###################################################" >> evidence.txt
echo "#          Investigating the DNS owners:          #" >> evidence.txt
echo "###################################################" >> evidence.txt

# Terminal output
echo " Investigating the DNS owners ..."


echo "  DNS Server Owners " >> evidence.txt

whois -h whois.internic.net iana-servers.net>> evidence.txt

echo " DNS Server Registry " >> evidence.txt

whois -h whois.register.com iana-servers.net>> evidence.txt

echo "###################################################" >> evidence.txt
echo "#      Investigating the IP network owners        #" >> evidence.txt
echo "###################################################" >> evidence.txt

# Terminal output
echo " Investigating the IP network owners   ..."


echo "Network Owners" >> evidence.txt

# Check 5 continents

nslookup $domain a.iana-servers.net >> evidence.txt

echo " Checking ARIN :" >> evidence.txt
whois -h whois.arin.net $IP >> evidence.txt
echo " Checking LACNIC :" >> evidence.txt
whois -h whois.lacnic.net $IP >> evidence.txt
echo " Checking AfriNIC :" >> evidence.txt
whois -h whois.afrinic.net $IP >> evidence.txt
echo " Checking RIPE :" >> evidence.txt
whois -h whois.ripe.net $IP >> evidence.txt


echo "###################################################" >> evidence.txt
echo "#          Investigating reversed DNS             #" >> evidence.txt
echo "###################################################" >> evidence.txt

# Terminal output
echo " Investigating reversed DNS  ..."

echo " Network Owners " >> evidence.txt

# using dig instead of nslookup

dig +noall +answer -x $IP >> evidence.txt

# Missing element : Getting Domain from previous command result , have to handle error

echo "###################################################" >> evidence.txt
echo "#      Investigating the web server owner         #" >> evidence.txt
echo "###################################################" >> evidence.txt

# Terminal output
echo "  Investigating the web server owner  ..."


echo "Web Server Owners" >> evidence.txt

nslookup $IP a.iana-servers.net >> evidence.txt

echo "###################################################" >> evidence.txt
echo "#       Investigating the upstream ISPs           #" >> evidence.txt
echo "###################################################" >> evidence.txt

# Terminal output
echo "  Investigating the upstream ISPs      ..."

echo "Upstream ISPs" >> evidence.txt
traceroute $domain>> evidence.txt

echo " Extracting Service Providers information " >> evidence.txt

# This is a way I created to extract the last ISP of the traceroute result
# not sure if its always accurate

full_link=$(traceroute $IP |  grep -Eo ' [a-zA-Z0-9./?=_-]*.net| [a-zA-Z0-9./?=_-]*.com'| tail -1)

IFS="."
last_elements=$(echo $full_link| awk '{printf "%s %s", $(NF-1),$NF}')
IFS=" "
provider=$(echo $last_elements | awk '{printf "%s.%s",$1,$2}')



whois -h whois.internic.net $provider >> evidence.txt
whois -h whois.networksolutions.com $provider >> evidence.txt

echo "###################################################" >> evidence.txt
echo "#     Investigating the routing information       #" >> evidence.txt
echo "###################################################" >> evidence.txt

# Terminal output
echo " Investigating the routing information    ..."

echo "AS Owners" >> evidence.txt

whois -h whois.radb.net $IP>> evidence.txt

# Missing element : Extracting unique number of system , I didnt know which element to choose from previous
# command result

echo "###################################################" >> evidence.txt
echo "#         Investigating the email owners          #" >> evidence.txt
echo "###################################################" >> evidence.txt

# Terminal output
echo "Investigating the email owners  ..."

echo "Email Server Owners" >> evidence.txt
nslookup -type=MX $IP a.iana-servers.net >> evidence.txt


echo " Please find your report at evidence.txt in this exact folder "

echo " Showing report :"
cat evidence.txt
