# Install dependencies only when needed
FROM strapi/base:14-alpine AS deps

WORKDIR /srv/app

ENV NODE_ENV=development

COPY package.json yarn.lock ./

RUN rm -rf node_modules

RUN yarn install --pure-lockfile

# Rebuild the source code only when needed
FROM strapi/base:14-alpine AS builder

WORKDIR /srv/app

ENV NODE_ENV=development

COPY . .

COPY --from=deps /srv/app/node_modules ./node_modules

RUN yarn build

# Production image, copy all the files and run strapi
FROM strapi/base:14-alpine AS runner

WORKDIR /srv/app

ENV NODE_ENV=development

RUN npm install --global pm2

RUN addgroup -g 1001 -S nodejs && \
    adduser -S strapijs -u 1001 && \
    chown -R strapijs:nodejs /srv/app

COPY --from=builder --chown=strapijs:nodejs /srv/app /srv/app

EXPOSE 1337

ENV PORT 1337

CMD pm2-runtime "yarn develop"
