# Stage 1: Build
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# 🔥 Add these 3 lines to fix exit code 126
RUN apk add --no-cache dos2unix
RUN find . -type f -exec dos2unix {} \;
RUN chmod -R +x .

# Build
RUN npm run build

# Stage 2: Serve production
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
