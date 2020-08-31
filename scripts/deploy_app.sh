#! /bin/bash

ssh worker-vm-1 << EOF
git clone https://github.com/K1610174/QA-SFIA2.git
EOF
ssh worker-vm-2 << EOF
git clone https://github.com/K1610174/QA-SFIA2.git
EOF

ssh manager-vm-1 << EOF
export MYSQL_DB="$MYSQL_DB"
export MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD"
git clone https://github.com/K1610174/QA-SFIA2.git
cd QA-SFIA2
docker-compose up -d
docker-compose ps
docker exec -it qa-sfia2_service1_1 bash
python3 create.py
exit
docker stack deploy --compose-file docker-compose.yaml appstack
docker stack services appstack
cd ..
rm -r QA-SFIA2
docker service scale appstack_service1=2
docker service scale appstack_service2=2
docker service scale appstack_service3=2
docker service scale appstack_service4=2
docker stack services appstack
EOF
