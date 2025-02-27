#!/bin/bash
source ./common.sh
check_root


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQL Server"

 mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
 VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
#mysql -h db.daws78s.online -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
#if [ $? -ne 0 ]
#then
 #   mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
  #  VALIDATE $? "MySQL Root password Setup"
#else
 #   echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
#fi

#mysql -h 172.31.45.4 -uroot -pExpenseApp@1 -e 'SHOW DATABASES'
#checking schemas
