ARG HOME_APP=/app
FROM node:lts-alpine as builder
ARG HOME_APP
WORKDIR ${HOME_APP}
COPY package.json .
COPY pnpm-lock.yaml .
RUN npm i -g pnpm
RUN pnpm i
COPY tsconfig.json .
COPY src src
RUN pnpm compile

FROM node:lts-alpine
ARG HOME_APP
ENV NODE_ENV=production
WORKDIR /server
COPY --from=builder ${HOME_APP}/dist .
COPY --from=builder ${HOME_APP}/package.json .
COPY --from=builder ${HOME_APP}/pnpm-lock.yaml .
RUN npm i -g pnpm
RUN pnpm i --prod
CMD ["node", "index"]