# Build할 Java Version에 따라 JDK를 변경
FROM jenkins/jenkins:lts-jdk17

USER root

# install docker
RUN apt-get update && \
    apt-get -y install apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        zip \
        unzip \
        software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce

# 기타 Shell 환경에서의 Build 를 위한 프로그램을 설치 ( 예시 Python 설치 )
RUN apt-get install -y python3-pip python-dev-is-python3 build-essential
# 공식 홈페이지 가이드대로 진행해보았으나 진행 불가함.
# RUN jenkins-plugin-cli --plugins github-branch-source:1781.va_153cda_09d1b_
# RUN jenkins-plugin-cli --plugins nodejs:1.6.1


USER jenkins