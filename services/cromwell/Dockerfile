# http://github.com/broadinstitute/scala-baseimage
FROM broadinstitute/scala-baseimage

RUN apt-get update && \
    apt-get install -y wget
    
RUN wget -c -P /cromwell https://github.com/broadinstitute/cromwell/releases/download/0.14/cromwell-0.14.jar

# Cromwell's HTTP Port
EXPOSE 8000

ADD . /
