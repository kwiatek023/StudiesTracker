#! /bin/bash

if [ $# != 1 ]; then
  echo "Use: ./tracker.sh [interval]"
fi

interval=$1

declare -A course_sites=( ["mobile"]="https://cs.pwr.edu.pl/zawada/am/"
                          ["www"]="https://cs.pwr.edu.pl/lauks/www.html"
                          ["algorithms"]="https://cs.pwr.edu.pl/golebiewski/#teaching/2021/aisd.php")

echo "You're tracking following websites:"
for course in "${!course_sites[@]}"; do
  echo "$course - ${course_sites[$course]}";
done

git init > /dev/null

for course in "${!course_sites[@]}"; do
  echo "$( lynx -dump ${course_sites[$course]} )" > "${course}.txt" ;
  git add "${course}.txt" > /dev/null
done

git commit -m "Tacking started" > /dev/null

while true; do
  sleep $interval
  for course in "${!course_sites[@]}"; do
    echo "$( lynx -dump ${course_sites[$course]} )" > temporary.txt ;

    if [ "$(diff "${course}.txt" temporary.txt)" != "" ]; then
      zenity --info --text "The ${course} website has changed!" 2> /dev/null
      cat temporary.txt > "${course}.txt"
      git diff
      git commit -m "${course} website changed" > /dev/null
    fi
  done

  rm temporary.txt
done





