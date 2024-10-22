FROM nginx:1.27-alpine
RUN pwd && exit 0
RUN ls -la && exit 0
COPY build /usr/share/ngnix/html
RUN ls -la /usr/share/ngnix/html