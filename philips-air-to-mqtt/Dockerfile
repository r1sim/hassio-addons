
ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:14.0.0

FROM node:18 as builder
ARG AIR_TO_MQTT_VERSION=1.2.0

# Create app directory
WORKDIR /builder

# Download release from github and unpack to /builder
RUN wget "https://github.com/r1sim/philips-air-to-mqtt/archive/refs/tags/v${AIR_TO_MQTT_VERSION}.zip" -O /tmp/philips-air-to-mqtt.zip
RUN unzip /tmp/philips-air-to-mqtt.zip
RUN mv /builder/philips-air-to-mqtt-${AIR_TO_MQTT_VERSION}/* /builder/
RUN rm -rf /builder/philips-air-to-mqtt-${AIR_TO_MQTT_VERSION}

RUN ls -la .

# Install app dependencies
RUN npm ci
RUN npm run build

FROM ${BUILD_FROM}

# Install NodeJS
RUN apk add --no-cache nodejs-current npm

# Install py-air-control (used by philips-air package)
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 py3-pip && ln -sf python3 /usr/bin/python
RUN pip3 install py-air-control

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
ENV NODE_ENV production
COPY --from=builder /builder/package.json /builder/package-lock.json ./
RUN npm ci --only=production

COPY --from=builder /builder/dist ./dist

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="r1sim" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Addons by r1sim" \
    org.opencontainers.image.authors="r1sim" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}


COPY root/ /
RUN chmod +x /customstart.sh
CMD ["/customstart.sh"]