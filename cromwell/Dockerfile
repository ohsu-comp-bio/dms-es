# http://github.com/broadinstitute/scala-baseimage
FROM broadinstitute/scala-baseimage

# Cromwell's HTTP Port
EXPOSE 8000

# Add cromwell jar and run script
ADD . /cromwell

ENTRYPOINT ["/cromwell/run.sh"]
