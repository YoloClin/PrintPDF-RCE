#!/bin/bash

echo "**********************************************"
echo "This creates many remotely accessible docker"
echo "containers which contain an RCE vulnerability"
echo "Press Y to continue"
echo "**********************************************"
read -p "Continue? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^Y$ ]]
then
    docker build -t drupal_print_wkhtmltopdf .
    for i in $(seq 30000 30010); do
	docker stop drupal_print_wkhtmltopdf_$i && docker rm drupal_print_wkhtmltopdf_$i
	docker run -d -it -p 0.0.0.0:$i:80 --name drupal_print_wkhtmltopdf_$i -d drupal_print_wkhtmltopdf
    done;

    for i in $(seq 30000 30010); do
	docker exec drupal_print_wkhtmltopdf_$i python /var/www/html/allow_anon_print_pdf.py
	docker exec drupal_print_wkhtmltopdf_$i rm /var/www/html/allow_anon_print_pdf.py
    done
fi
