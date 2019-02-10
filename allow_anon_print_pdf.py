#!/usr/bin/env python
# Actually setting drupal 7 settings involves either hacking JSON
# in the sqlite database or via HTTP hacks. I'm not sure which is worse.
import requests
import subprocess
import logging
import os
from BeautifulSoup import BeautifulSoup

logging.basicConfig()
log = logging.getLogger("allow_anon_print_pdf")
log.setLevel(logging.DEBUG)

# Create a session authenticated as admin
os.chdir("/var/www/html")
p = subprocess.Popen(["drush", "user-login", "admin"], stdout=subprocess.PIPE)
url = p.communicate()[0].decode().replace("http://default", "http://localhost")
s = requests.Session()
response = s.get(url)
log.debug("User login URL response code: %s", response.status_code)

# Need to send second post to actually authenticate
soup = BeautifulSoup(response.content)
form = soup.body.find("form")
posturl = "http://localhost/" + form['action']
response = s.post(posturl, data={})
assert(b"You have just used your one-time login link" in response.content)
log.debug("Authentication successful")

# Get the module configuration form, set wkhtmltopdf then post back
response = s.get("http://localhost/admin/config/user-interface/print/pdf")
soup = BeautifulSoup(response.content)
form = soup.body.find("form")
formdata = dict((field.get('name'), field.get('value'))
                for field in form.findAll("input"))

# Overriding whatever the current is with a new value
formdata[u'print_pdf_pdf_tool'] = (u'print_pdf_wkhtmltopdf|sites/all'
                                   '/libraries/wkhtmltopdf')
posturl = "http://localhost/" + form['action']
response = s.post(posturl, data=formdata)
assert(response.status_code == 200)
log.debug("Successfully set default pdf tool to wkhtmltopdf")
