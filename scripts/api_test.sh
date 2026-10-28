#!/bin/bash
# Task 3.4 — API tests with curl. Run after: docker compose up -d --build
# Usage: bash scripts/api_test.sh  [base-url]

BASE=${1:-http://localhost:8080/api/beket-margulan/students}
EMAIL="margulan.beket.$(date +%s)@iitu.edu.kz"   # unique each run

show() { echo; echo "### $1"; echo "\$ $2"; eval "$2"; echo; }

show "Info (author and version)" \
  "curl -s -w '\nHTTP %{http_code}\n' http://localhost:8080/api/beket-margulan/info"

echo "### 1. Create a student with my name"
CREATE=$(curl -s -X POST "$BASE" -H 'Content-Type: application/json' \
  -d "{\"firstName\":\"Margulan\",\"lastName\":\"Beket\",\"email\":\"$EMAIL\",\"groupName\":\"it2-2302\"}" \
  -w '\nHTTP %{http_code}')
echo "$CREATE"
ID=$(echo "$CREATE" | head -1 | sed -E 's/.*"id":([0-9]+).*/\1/')
echo "Created id = $ID"

show "2. Get all students" \
  "curl -s -w '\nHTTP %{http_code}\n' $BASE"

show "3. Get student by id $ID" \
  "curl -s -w '\nHTTP %{http_code}\n' $BASE/$ID"

show "4. Update student $ID" \
  "curl -s -w '\nHTTP %{http_code}\n' -X PUT $BASE/$ID -H 'Content-Type: application/json' -d '{\"firstName\":\"Margulan\",\"lastName\":\"Beket\",\"email\":\"$EMAIL\",\"groupName\":\"it2-2302 (updated)\"}'"

show "5. Delete student $ID" \
  "curl -s -w 'HTTP %{http_code}\n' -X DELETE $BASE/$ID"

show "6. Request a nonexistent student (expect 404)" \
  "curl -s -w '\nHTTP %{http_code}\n' $BASE/99999"
