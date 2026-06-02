FROM node:20-alpine
WORKDIR /app
# We assume you have a 'dist' folder already. 
# If not, run 'npm run build' on your terminal first!
COPY dist ./dist
RUN npm install -g serve
EXPOSE 80
CMD ["serve", "-s", "dist", "-l", "80"]