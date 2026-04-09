#!/bin/bash
IP_TARGET=$1

echo "--- Testing SQLi Bypass ---"
# Mencoba login paksa, lalu cek apakah server mencoba melempar kita ke dashboard
sqli_status=$(curl -s -i -d "username=' OR 1=1 -- &password=x&login=" http://$IP_TARGET/login.php | grep -i "Location: dashboard.php")

if [ ! -z "$sqli_status" ]; then
    echo "❌ SQLi: MASIH BOCOR! (Bisa Bypass Login)"
else
    echo "✅ SQLi: AMAN."
fi

echo -e "\n--- Testing IDOR Access ---"
# Mencoba akses ID 3 langsung, lalu cek apakah nama 'Sultan' muncul
idor_content=$(curl -s "http://$IP_TARGET/dashboard.php?id=3")

if [[ "$idor_content" == *"Sultan Firaun"* ]]; then
    echo "❌ IDOR: MASIH BOCOR! (Bisa liat saldo Sultan)"
else
    echo "✅ IDOR: AMAN."
fi