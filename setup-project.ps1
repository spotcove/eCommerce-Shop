# setup-project.ps1
# Run PowerShell as Administrator

$projectRoot = Read-Host "Enter the full path to your project folder"

# 1️⃣ Check Docker
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker is not installed. Install it here: https://www.docker.com/get-started" -ForegroundColor Red
    exit
}

# 2️⃣ Remove old containers & volumes
Write-Host "Stopping and removing old containers and volumes..." -ForegroundColor Yellow
docker-compose -f "$projectRoot\docker-compose.yml" down -v -t 5

# 3️⃣ Create docker-compose.yml
$composeFile = Join-Path $projectRoot "docker-compose.yml"
Write-Host "Creating docker-compose.yml..." -ForegroundColor Cyan
@"
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: my_mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: ilovebombay
      MYSQL_USER: bombay_user
      MYSQL_PASSWORD: userpassword
      MYSQL_DEFAULT_AUTH: caching_sha2_password
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

  adminer:
    image: adminer
    container_name: my_adminer
    restart: always
    ports:
      - "8080:8080"
    depends_on:
      - mysql

volumes:
  mysql_data:
"@ | Out-File -Encoding UTF8 $composeFile

# 4️⃣ Start Docker containers
Write-Host "Starting MySQL and Adminer containers..." -ForegroundColor Green
docker-compose -f $composeFile up -d

# 5️⃣ Wait for MySQL to be ready
Write-Host "Waiting for MySQL to initialize..." -ForegroundColor Yellow
$mysqlReady = $false
while (-not $mysqlReady) {
    try {
        docker exec my_mysql mysql -u root -prootpassword -e "SELECT 1;" > $null 2>&1
        if ($LASTEXITCODE -eq 0) { $mysqlReady = $true } else { Start-Sleep -Seconds 2 }
    } catch { Start-Sleep -Seconds 2 }
}
Write-Host "MySQL is ready!" -ForegroundColor Green

# 6️⃣ Grant all privileges to bombay_user
Write-Host "Granting all privileges to bombay_user..." -ForegroundColor Cyan
docker exec my_mysql mysql -u root -prootpassword -e "GRANT ALL PRIVILEGES ON *.* TO 'bombay_user'@'%'; FLUSH PRIVILEGES;"

# 7️⃣ Drop and recreate database (clean slate)
Write-Host "Dropping and recreating database..." -ForegroundColor Yellow
docker exec my_mysql mysql -u root -prootpassword -e "DROP DATABASE IF EXISTS ilovebombay; CREATE DATABASE ilovebombay;"

# 8️⃣ Remove old migrations
$migrationsFolder = Join-Path $projectRoot "server\prisma\migrations"
if (Test-Path $migrationsFolder) {
    Write-Host "Removing old Prisma migrations..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $migrationsFolder
}

# 9️⃣ Create .env files
$rootEnv = Join-Path $projectRoot ".env"
$serverEnv = Join-Path $projectRoot "server\.env"

$envContent = @"
DATABASE_URL=mysql://bombay_user:userpassword@127.0.0.1:3306/ilovebombay
NEXTAUTH_SECRET=12D16C923BA17672F89B18C1DB22A
NEXTAUTH_URL=http://localhost:3000
"@

$serverEnvContent = @"
DATABASE_URL=mysql://bombay_user:userpassword@127.0.0.1:3306/ilovebombay
"@

Write-Host "Creating root .env..." -ForegroundColor Cyan
$envContent | Out-File -Encoding UTF8 $rootEnv

Write-Host "Creating server .env..." -ForegroundColor Cyan
$serverEnvContent | Out-File -Encoding UTF8 $serverEnv

# 🔟 Install Node dependencies
Write-Host "Installing Node.js dependencies in root folder..." -ForegroundColor Cyan
cd $projectRoot
npm install

Write-Host "Installing Node.js dependencies in server folder..." -ForegroundColor Cyan
cd "$projectRoot\server"
npm install

# 1️⃣1️⃣ Create initial migration and apply it
Write-Host "Applying fresh Prisma migration..." -ForegroundColor Cyan
npx prisma migrate dev --name init

# 1️⃣2️⃣ Insert demo data
$utillsFolder = Join-Path $projectRoot "\utills"
Write-Host "Inserting demo data..." -ForegroundColor Cyan
cd $utillsFolder
node insertDemoData.js

# 1️⃣3️⃣ Start backend
Write-Host "Starting backend..." -ForegroundColor Cyan
cd "$projectRoot\"
Start-Process "powershell" -ArgumentList "node app.js" -NoNewWindow

# 1️⃣4️⃣ Start frontend
Write-Host "Starting frontend..." -ForegroundColor Cyan
cd $projectRoot
Start-Process "powershell" -ArgumentList "npm run dev" -NoNewWindow

Write-Host "`nSetup complete! Access your app at http://localhost:3000 and Adminer at http://localhost:8080" -ForegroundColor Green
