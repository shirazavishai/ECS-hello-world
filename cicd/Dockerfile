FROM node:20-alpine
WORKDIR /app
RUN printf "const http=require('http');http.createServer((_,res)=>res.end('Hello World')).listen(80);" > server.js
EXPOSE 80
CMD ["node", "server.js"]
