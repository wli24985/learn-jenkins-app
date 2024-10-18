FROM nginx:1.27-alpine
RUN ls -la ./build
COPY ./build /usr/share/ngnix/html