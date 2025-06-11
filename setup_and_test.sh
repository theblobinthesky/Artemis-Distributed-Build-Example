RELEASE_VERSION=8.1.3

# Download an Artemis release:
curl -L https://github.com/ls1intum/Artemis/releases/download/$RELEASE_VERSION/Artemis.war --output artemis.war 

# Startup the dependencies using docker-compose:
# - postgresql 17
sudo docker-compose down -v
sudo docker-compose rm
sudo rm -rf ~/Downloads/postgres
sudo docker-compose up --detach

# Start the main Artemis instance.
java -jar artemis.war --server.port=8080 --eureka.instance.instanceId=Artemis:1 \
   --spring.profiles.active=prod,core,localvc,localci,scheduling \
   --spring.config.location=file:/opt/artemis/node1/
