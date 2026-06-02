# Stage 1: Build the React App
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve the App
FROM node:20-alpine
WORKDIR /app
RUN npm install -g serve
# This copies the compiled files from the 'build' stage above
COPY --from=build /app/dist ./dist
EXPOSE 80
CMD ["serve", "-s", "dist", "-l", "80"]