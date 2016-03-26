
all:
	jekyll build
	rsync --delete -avP _site/* dionysos.aquilenet.fr:~/public_html

draft:
	jekyll build --drafts
	rsync --delete -avP _site/* dionysos.aquilenet.fr:~/public_html

stats:
	ssh dionysos.aquilenet.fr 'cat /var/log/apache2/access.log /var/log/apache2/access.log.1; zcat /var/log/apache2/access.log.[0-9].gz'  | grep sven337 | goaccess -a > /tmp/report.html
	firefox -new-tab file:///tmp/report.html

statsfull:
	ssh dionysos.aquilenet.fr 'cat /var/log/apache2/access.log /var/log/apache2/access.log.1; zcat /var/log/apache2/access.log.*.gz'  | grep sven337 | goaccess -a > /tmp/report.html
	firefox -new-tab file:///tmp/report.html
