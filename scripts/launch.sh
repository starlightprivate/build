sudo docker kill $(docker ps -q) || true
sudo docker-compose build
sudo docker-compose up -d