#!/bin/bash
#Author: Summer0nguyen

cwd=`dirname $0`
RESULT_PATH="$cwd/results"

TOTAL_THREADS=8



if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <list_file>"
    exit
fi

configFile=$1

if [ ! -f $configFile ];
then
    echo "List file $configFile does not exists"
    exit
fi

mkdir -p $RESULT_PATH



function getDomain {
    url=$1




    domain=`echo $url | sed 's/http:\/\///;s|\/.*||'`
    if [ $domain == "https:" ]
    then
        domain=`echo $url | sed 's/https:\/\///;s|\/.*||'`
    fi
    echo $domain
    
}

function checkDomain {
    url=$1
    domain=`getDomain $url`
    echo "Check Domain : $domain"
    robot_url="$url/robots.txt"

    checkRobots $robot_url

}

function checkRobots {
    robot_url=$1
    echo "Check Robot: $robot_url"

    sitemaps=`curl --compressed -s "$robot_url"| grep -i Sitemap | awk '{print $NF}'`



    for sitemap in $sitemaps
    do

        if [[ "$sitemap" == *gz ]]
        then
            checkXMLGZ $sitemap
        elif [[ "$sitemap" == *xml ]]
        then 
            checkXML $sitemap
        else
            echo "[Warning] Ignore File $sitemap"
        fi
        
    done



}

function checkXML {
    sitemap_url=$1
    domain=`getDomain $sitemap_url`

    echo "Checking XML: $sitemap_url"

    urls=`curl --compressed -s "$sitemap_url"| sed -e 's/></>\'$'\n</g' | grep "<loc>"  | awk -F'>' '{print $2}' | awk -F'<' '{print $1}'`
    N=$TOTAL_THREADS
    (
    for url in $urls
    do
        ((i=i%N)); ((i++==0)) && wait

        if [[ "$url" == *gz ]]
        then
            checkXMLGZ $url &
        elif [[ "$url" == *xml ]]
        then 
            checkXML $url &
        else
            echo "$url" >> $RESULT_PATH/$domain
        fi
    done
    )


}

function checkXMLGZ {
    sitemap_url=$1
    domain=`getDomain $sitemap_url`

    echo "check XML Gzip : $sitemap_url" 


    urls=`curl --compressed -s "$sitemap_url"| gunzip -c| sed -e 's/></>\'$'\n</g' | grep "<loc>"  | awk -F'>' '{print $2}' | awk -F'<' '{print $1}'`

    
    N=$TOTAL_THREADS
    (
    for url in $urls
    do
        ((i=i%N)); ((i++==0)) && wait
        if [[ "$url" == *gz ]]
        then
            checkXMLGZ $url &
        elif [[ "$url" == *xml ]]
        then 
            checkXML $url &
        else
            echo "$url" >> $RESULT_PATH/$domain
        fi
    done
    )

}





websites=`cat $configFile`

for website in $websites
do


    if [[ "$website" == *gz ]]
    then
        checkXMLGZ $website
    elif [[ "$website" == *xml ]]
    then 
        checkXML $website
    elif [[ "$website" == *robots.txt ]]
    then
        checkRobots $website
    else
        checkDomain $website
    fi
     
done
