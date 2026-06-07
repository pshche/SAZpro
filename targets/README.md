
ps@MacBook-Pro-Pavel targets % docker --version
Docker version 29.4.0, build 9d7ad9f
ps@MacBook-Pro-Pavel targets % docker compose version
Docker Compose version v5.1.1
ps@MacBook-Pro-Pavel targets % git --version
git version 2.23.0
ps@MacBook-Pro-Pavel targets % python3 --version
Python 3.11.5
ps@MacBook-Pro-Pavel targets % node --version 
v26.0.0
ps@MacBook-Pro-Pavel targets % ls -ll
total 0
drwxr-xr-x@ 65 ps  staff  2080  2 июня  17:50 juice-shop
drwxr-xr-x  29 ps  staff   928  2 июня  18:11 webgoat
ps@MacBook-Pro-Pavel targets % ls juice-shop 
AGENTS.md		crowdin.yaml		eslint.config.mjs	LICENSE			routes			test
app.json		ctf.key			frontend		models			rsn			threat-model.json
app.ts			cypress.config.ts	ftp			monitoring		screenshots		tsconfig.json
CODE_OF_CONDUCT.md	data			Gruntfile.js		node_modules		SECURITY.md		uploads
config			docker-compose.test.yml	HALL_OF_FAME.md		package.json		server.ts		vagrant
config.schema.yml	Dockerfile		i18n			README.md		SOLUTIONS.md		views
CONTRIBUTING.md		encryptionkeys		lib			REFERENCES.md		swagger.yml
ps@MacBook-Pro-Pavel targets % ls webgoat 
CODE_OF_CONDUCT.md		Dockerfile			mvn-debug			README_I18N.md
config				Dockerfile_desktop		mvnw				README.md
CONTRIBUTING.md			docs				mvnw.cmd			RELEASE_NOTES.md
COPYRIGHT.txt			FAQ.md				pom.xml				src
CREATE_RELEASE.md		LICENSE.txt			PULL_REQUEST_TEMPLATE.md
ps@MacBook-Pro-Pavel targets % docker ps
CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS                      PORTS                                                NAMES
f7c059274e35   webgoat/webgoat         "java -Duser.home=/h…"   44 minutes ago   Up 44 minutes (unhealthy)   127.0.0.1:8080->8080/tcp, 127.0.0.1:9090->9090/tcp   webgoat
d9ebd0b7424b   bkimminich/juice-shop   "/nodejs/bin/node /j…"   2 hours ago      Up 2 hours                  0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp          juice-shop
ps@MacBook-Pro-Pavel targets % docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Networks}}"
NAMES        IMAGE                   PORTS                                                NETWORKS
webgoat      webgoat/webgoat         127.0.0.1:8080->8080/tcp, 127.0.0.1:9090->9090/tcp   bridge
juice-shop   bkimminich/juice-shop   0.0.0.0:3000->3000/tcp, [::]:3000->3000/tcp          bridge