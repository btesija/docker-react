# 1. section, BUILD PHASE, install dependencies and tag this phase as builder
FROM node:alpine as builder

WORKDIR '/app'

COPY package.json .
RUN npm install 
RUN mkdir -p node_modules/.cache && chmod -R 777 node_modules/.cache

COPY . . 
# this will create build folder inside WORKDIR
RUN npm run build 

# 2. section, RUN PHASE, 
# any single phase can only have FROM statement
FROM nginx
EXPOSE 80
# copy from /app/build folder from builder phase to 
# nginx static content folder
COPY --from=builder /app/build  /usr/share/nginx/html

# we don't need to define start nginx container because this is default command
