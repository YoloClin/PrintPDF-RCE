#!/bin/bash

docker stop drupal_print_wkhtmltopdf && docker rm drupal_print_wkhtmltopdf
docker build -t drupal_print_wkhtmltopdf .
docker run -d -it -p 30000:80 --name drupal_print_wkhtmltopdf -d drupal_print_wkhtmltopdf
docker exec drupal_print_wkhtmltopdf python /var/www/html/allow_anon_print_pdf.py
docker exec drupal_print_wkhtmltopdf rm /var/www/html/allow_anon_print_pdf.py
