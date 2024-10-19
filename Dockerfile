FROM nginx:1.27-alpine
RUN pwd
RUN ls -la
RUN ls -la build
COPY build /usr/share/ngnix/html