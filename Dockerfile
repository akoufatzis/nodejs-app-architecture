FROM node:carbon-alpine as builder

RUN mkdir -p /build

COPY ./package.json ./package-lock.json /build/
WORKDIR /build
RUN npi ci --production

# Bundle app source
COPY . /build

# Build app for production
RUN npm run build

FROM node:carbon-alpine
# user with username node is provided from the official node image
ENV user node
# Run the image as a non-root user
USER $user

# Create app directory
RUN mkdir -p /home/$user/src
WORKDIR /home/$user/src

COPY --from=builder /build ./

EXPOSE 5000

ENV NODE_ENV production

CMD ["node", "./dist/server.js"]