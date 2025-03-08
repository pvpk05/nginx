server {
    listen 80;
    server_name rsexamsbackend.ramanasoft.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name rsexamsbackend.ramanasoft.com;

    ssl_certificate /etc/letsencrypt/live/rsexamsbackend.ramanasoft.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/rsexamsbackend.ramanasoft.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location /api/ {
        proxy_pass http://localhost:5002/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

