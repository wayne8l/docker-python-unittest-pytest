ARG BASE_IMAGE=ubuntu:16.04

FROM ${BASE_IMAGE}

# install the prerequisites
RUN apt-get update && apt-get install -y python3 python3-pip

# copy in the pip requirements
ADD requirements.txt /srv/requirements.txt
ADD requirements-dev.txt /srv/requirements-dev.txt
# install the requirenents
RUN pip3 install -r /srv/requirements-dev.txt

# copy in the software
ADD some_module /srv/some_module

WORKDIR /srv/

# Build our entrypoint
RUN echo "#!/usr/bin/env bash" > test.sh
RUN echo "python3 -m pytest -v --junit-xml test_results/some_module_results.xml some_module" >> test.sh
RUN chmod +x test.sh

# Run the entrypoint (only when the image is instantiated into a container)
CMD ["./test.sh"]

# to build: docker build -t test_some_module .

# to run: docker run --name test_some_module test_some_module

# once the run is complete, /srv/test_results inside the container will hold JUnit XML files
