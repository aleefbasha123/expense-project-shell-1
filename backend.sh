#!/bin/bash
source ./common.sh
check_root

dnf module disable nodejs -y &>>LOGFILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>LOGFILE
VALIDATE $? "Enabeling nodejs version 20"

dnf install nodejs -y &>>LOGFILE
VALIDATE $? "Insatalling nodejs"

#useradd expense &>>LOGFILE
#VALIDATE $? "Adding expense user"

id expense  &>>LOGFILE
if [ $? -ne 0 ]
then
    useradd expense
    VALIDATE $? "Creating Expense user"
else
     echo -e "Expense user alrady Crated...$Y SKIPPING $N"
fi

mkdir -p /app  -&>>LOGFILE
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip  &>>LOGFILE
VALIDATE $? "Downloading the code"
cd /app 
rm -rf /app/*
VALIDATE $? "Removing all content"

unzip -o /tmp/backend.zip  &>>LOGFILE
VALIDATE $? "Unzipping the application"

cd /app 
npm install &>>LOGFILE
VALIDATE $? "Insatlling Dependences"

cp /root/expense-project-shell-1/backend.service  /etc/systemd/system/backend.service  &>>LOGFILE
VALIDATE $? "Coping backend services"

systemctl daemon-reload &>>LOGFILE
VALIDATE $? "Reloading deamon"

systemctl enable backend &>>LOGFILE
VALIDATE $? "Enabeling backend applcaition"

systemctl start backend  &>>LOGFILE
VALIDATE $? "Starting application"

dnf install mysql -y &>>LOGFILE
VALIDATE $? "Insatlling mysql"

mysql -h 172.31.27.208 -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>LOGFILE
VALIDATE $? "Loading schema file" 