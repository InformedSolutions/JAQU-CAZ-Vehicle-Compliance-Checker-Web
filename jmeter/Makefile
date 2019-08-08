build:
	docker build -t jmeter -f Dockerfile .

run-example:
	docker run -it -v "$(pwd)":/opt/scripts jmeter -n -t /opt/scripts/valid_vehicle_compliance.jmx


run-taurus
	bzt valid_vehicle_compliance.yml
