FROM node:12.22.6-buster-slim

WORKDIR /opt/service

# update all OS dependencies to prevent vuln's
RUN apt-get update && apt-get -y upgrade

# Copy PJ, changes should invalidate entire image
COPY package.json yarn.lock /opt/service/

# Copy commong typings
COPY typings /opt/service/typings

# Copy TS configs
COPY tsconfig* /opt/service/

# Build backend
COPY src /opt/service/src

# Build Frontend
COPY webpack.*.js README.md /opt/service/

COPY tools /opt/service/tools

# Install dependencies
RUN yarn --cache-folder ../ycach && NODE_ENV=production yarn build && yarn --production --cache-folder ../ycache && rm -rf ../ycache && rm -rf src && rm -rf tools && rm -rf typings

ENV NODE_ENV=production

EXPOSE 8080

ENTRYPOINT ["npm", "run", "start", "--"]
