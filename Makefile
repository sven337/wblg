all:
	jekyll build
	rsync -avP _site/* dionysos.aquilenet.fr:~/public_html
