# Variables - customize these
$containerName = "my_mysql"
$rootPassword  = "rootpassword"
$newDatabase   = "ilovebombay"
$newUser       = "bombay_user"
$newPassword   = "userpassword"

# Create database
docker exec -i $containerName sh -c "export MYSQL_PWD=$rootPassword; mysql -u root -e `"CREATE DATABASE $newDatabase;`""

# Create user
docker exec -i $containerName sh -c "export MYSQL_PWD=$rootPassword; mysql -u root -e `"CREATE USER '$newUser'@'%' IDENTIFIED BY '$newPassword';`""

# Grant privileges
docker exec -i $containerName sh -c "export MYSQL_PWD=$rootPassword; mysql -u root -e `"GRANT ALL PRIVILEGES ON $newDatabase.* TO '$newUser'@'%';`""

# Flush privileges
docker exec -i $containerName sh -c "export MYSQL_PWD=$rootPassword; mysql -u root -e `"FLUSH PRIVILEGES;`""

Write-Host "Database '$newDatabase' and user '$newUser' created successfully."
cd sh