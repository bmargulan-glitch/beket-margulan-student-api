# beket-margulan-student-api

   Spring Boot CRUD API for students by Beket Margulan — runs with Docker Compose and Jenkins; see the Endpoints table below.

Author: Beket Margulan, group it2-2302, student ID 38109

## Endpoints

Base URL: `http://localhost:8080/api/beket-margulan/students`

| Method | Path | Description |
| --- | --- | --- |
| GET | `/api/beket-margulan/info` | Author and version |
| GET | `/api/beket-margulan/students` | All students |
| GET | `/api/beket-margulan/students/{id}` | One student (404 if missing) |
| POST | `/api/beket-margulan/students` | Create |
| PUT | `/api/beket-margulan/students/{id}` | Update |
| DELETE | `/api/beket-margulan/students/{id}` | Delete |

## Run

```bash
cp .env.example .env      # then set POSTGRES_PASSWORD
docker compose up -d --build
```

Docker image: `beket-margulan-student-api:v1.0-beket-margulan-38109`

## Change log

- Beket Margulan: the create operation now trims first/last name and stores the email in lower case,
  so "Margulan.Beket@IITU.edu.kz" and "margulan.beket@iitu.edu.kz" count as the same student.
- 2026-10-29 11:43: automatic Jenkins build check by Beket Margulan
