FROM nginx:1.27-alpine
RUN dir -s build
COPY build /usr/share/ngnix/html