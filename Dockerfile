FROM library/drupal:7.63

RUN apt-get update && \
    apt-get install -y \
      curl \
      less \
      sudo \
      sqlite3 \
      python-requests \
      python-beautifulsoup \
      libxrender1 \
      libxext6 \
      libfontconfig1 \
      netcat \
      wget && \
    rm -rf /var/lib/apt/lists/*

RUN php -r "readfile('https://github.com/drush-ops/drush/releases/download/8.1.18/drush.phar');" > drush && chmod +x drush && mv drush /usr/local/bin
RUN sudo -u www-data drush site-install --db-url=sqlite://sites/default/files/.ht.sqlite -y
COPY wkhtmltopdf /var/www/html/sites/all/libraries/wkhtmltopdf
RUN sudo -u www-data drush pm-download print-7.x-2.0
RUN sudo -u www-data drush pm-enable print -y
RUN sudo -u www-data drush pm-enable print_pdf -y
RUN sudo -u www-data drush pm-enable print_pdf_wkhtmltopdf -y
RUN sudo -u www-data drush pm-download devel
RUN sudo -u www-data drush pm-enable devel -y
RUN sudo -u www-data drush pm-enable devel_generate -y
RUN sudo -u www-data drush generate-content 1
RUN sudo -u www-data drush role-add-perm 'anonymous user' 'access PDF version'
COPY allow_anon_print_pdf.py /var/www/html/
COPY generate_article.php /var/www/html/
RUN sudo -u www-data drush scr generate_article.php
EXPOSE 80
