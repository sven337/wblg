all:
	jekyll build
	rsync --delete -avP _site/* dionysos.aquilenet.fr:~/public_html
