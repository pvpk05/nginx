server {
    listen 443 ssl;
    server_name exams.ramanasoft.com www.exams.ramanasoft.com;
    ssl_certificate /etc/letsencrypt/live/exams.ramanasoft.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/exams.ramanasoft.com/privkey.pem; # managed by Certbot

    root /path/to/your/frontend/build;
    index index.html;


    # Backend API
    location /api/ {
        proxy_pass https://194.238.17.64:5002; # Update with your backend port if needed
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }


}

server {
    if ($host = www.exams.ramanasoft.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = exams.ramanasoft.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name exams.ramanasoft.com www.exams.ramanasoft.com;
    return 301 https://$host$request_uri;




}

