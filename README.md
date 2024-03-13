# TestToolChain 환경 구성 가이드

## 실행 가이드

### 사전 작업 필요 ( 공식 링크로 대체 )

- [Docker desktop 설치](https://docs.docker.com/desktop/install/windows-install/)
- [docker-compose 설치](https://docs.docker.com/compose/install/standalone/#on-windows-server)

### git clone

```
PS D:\> git clone https://github.com/grapefr/TestToolChain.git
```

### Docker image build

- Jenkins 기본이미지 내 추가 패키지 적용을 위하여 TestToolChain 전용 jenkis image를 만들기 위함

```
# 이미지 제작
PS D:\TestToolChain> docker build --tag seedlabs .
PS D:\TestToolChain>
```

결과 :
![image](https://github.com/grapefr/TestToolChain/assets/68136339/df6c8934-c8e4-456e-bb1d-32eeb5345af7)

```
# 이미지 확인
PS D:\TestToolChain> docker images
REPOSITORY                      TAG       IMAGE ID       CREATED             SIZE
seedlabs                        latest    8d445c2c5148   9 minutes ago       1.47GB
PS D:\TestToolChain>
```

### Docker-compose up

- 3.6 seedlabs 미팅 때 나왔던 서버 목록
  - redmine
  - sonarqube
  - postgresql
  - jenkis
- docker-compose.yaml 확인

```
version: "3"
services:
  # redmine
  redmine:
    image: redmine:latest
    container_name: redmine
    ports:
      - "3000:3000"
    environment:
      - REDMINE_DB_POSTGRES=postgres
      - REDMINE_DB_DATABASE=seedlabs
      - REDMINE_DB_USERNAME=seedlabs
      - REDMINE_DB_PASSWORD=seedlabs
    volumes:
      - redmine_data:/usr/src/redmine/files
    networks:
      - tool_chain

  # jenkis ( ssh-agent 는 ssh-over 를 위함 )
  jenkins:
    image: seedlabs
    container_name: jenkins
    ports:
      - "8080:8080"
    volumes:
      - jenkins_data:/var/jenkins_home
    networks:
      - tool_chain
  ssh-agent:
    image: jenkins/ssh-agent
    networks:
      - tool_chain

  sonarqube:
    image: sonarqube:latest
    container_name: sonarqube
    ports:
      - "9001:9000"
    environment:
      - SONARQUBE_JDBC_URL=jdbc:postgresql://postgres:5432/seedlabs
      - SONARQUBE_JDBC_USERNAME=seedlabs
      - SONARQUBE_JDBC_PASSWORD=seedlabs
    volumes:
      - sonarqube_data:/opt/sonarqube/data
    networks:
      - tool_chain

  postgres:
    image: postgres:latest
    container_name: postgres
    environment:
      - POSTGRES_DB=seedlabs
      - POSTGRES_USER=seedlabs
      - POSTGRES_PASSWORD=seedlabs
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - tool_chain

networks:
  tool_chain:
    driver: bridge

volumes:
  redmine_data:
  jenkins_data:
  sonarqube_data:
  postgres_data:
```

- 컨테이너 실행

```
PS D:\TestToolChain> docker-compose up -d
[+] Running 5/5
 ✔ Container redmine               Running                                                           0.0s
 ✔ Container seedlabs-ssh-agent-1  Running                                                           0.0s
 ✔ Container sonarqube             Running                                                           0.0s
 ✔ Container postgres              Started                                                           1.2s
 ✔ Container jenkins               Started                                                           1.7s
PS D:\TestToolChain>
```
