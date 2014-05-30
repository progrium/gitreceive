VERSION = 0.2.0

install:
	cp gitreceive /usr/local/bin/gitreceive
	chmod +x /usr/local/bin/gitreceive

check-docker:
	which docker || exit 1

test: check-docker
	cp gitreceive tests
	docker build -t gitreceive-test tests
	rm tests/gitreceive
	docker run --rm gitreceive-test

clean:
	docker rmi gitreceive-test