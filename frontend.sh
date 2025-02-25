#!/bin/bash
source ./common.sh
check_root

dnf install nginx -y  &>>LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>LOGFILE
VALIDATE $? "Enable nginx"

systemctl start nginx &>>LOGFILE
VALIDATE $? "Start nginx"

rm -rf /usr/share/nginx/html/* &>>LOGFILE
VALIDATE $? "Removing html nginx"

curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/expense-frontend-v2.zip &>>LOGFILE
VALIDATE $? "Downloading nginx"

cd /usr/share/nginx/html &>>LOGFILE
unzip -o /tmp/frontend.zip &>>LOGFILE
VALIDATE $? "Extracting frontend application"

cp /root/expense-project-shell/expense.conf /etc/nginx/default.d/expense.conf &>>LOGFILE
VALIDATE $? "Coping expense application"

systemctl restart nginx &>>LOGFILE
VALIDATE $? "Restarting nginx"