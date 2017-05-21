build:
	docker build -t jmcarbo/nomad .

runclient:
	docker run -d --name nomad-worker1  --privileged -v /var/run/docker.sock:/var/run/docker.sock -v $$PWD/nomad-config:/etc/nomad -v /usr/bin/docker:/usr/bin/docker --network consul-net jmcarbo/nomad agent -client


