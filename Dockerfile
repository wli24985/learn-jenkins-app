FROM nginx:1.27-alpine
RUN pwd
RUN ls -la
WORKDIR /var/jenkins_home/workspace/learn-jenkins-app
RUN ls -la build
COPY build /usr/share/ngnix/html