#!/bin/bash
# Part 2 — Git workflow (Tasks 2.1–2.3). Run ONCE from the project root:
#   bash scripts/part2_git_workflow.sh
# It stops at the merge conflict so you resolve it by hand (Task 2.3 requires that).

set -e
cd "$(dirname "$0")/.."

if [ -d .git ]; then
    echo "This folder is already a Git repository. Remove .git first if you want to start over."
    exit 1
fi

step() { echo; echo "### $*"; }
run()  { echo "\$ $*"; eval "$@"; }

# ---------- Task 2.1 ----------
step "Task 2.1 — init, config, .gitignore, first commit"
run "git init -b main"
run "git config user.name 'Margulan Beket'"
run "git config user.email 'bmargulan@iitu.edu.kz'"
run "cat .gitignore"
run "git add ."
run "git status --short | head -20"
run "git commit -q -m 'Initial commit: Beket Margulan Student API'"

# ---------- Task 2.2 ----------
step "Task 2.2 — feature branch with a CRUD improvement"
run "git checkout -b feature/beket-margulan-crud"

# Improve CREATE: trim names and store email in lower case
perl -0pi -e 's/(public Student create\(Student student\) \{\n)/$1        normalize(student);\n/' \
    src/main/java/kz/iitu/beket/studentapi/service/StudentService.java
perl -0pi -e 's/(\n\}\s*)$/\n\n    \/\/ Added by Beket Margulan: clean input before saving\n    private void normalize(Student student) {\n        student.setFirstName(student.getFirstName().trim());\n        student.setLastName(student.getLastName().trim());\n        student.setEmail(student.getEmail().trim().toLowerCase());\n    }\n}\n/' \
    src/main/java/kz/iitu/beket/studentapi/service/StudentService.java
run "git diff --stat"
run "git commit -qam 'Improve create: trim names and lowercase email (Beket Margulan)'"

cat > src/test/java/kz/iitu/beket/studentapi/StudentNormalizationTest.java <<'EOF'
package kz.iitu.beket.studentapi;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
class StudentNormalizationTest {

    @Autowired
    private MockMvc mvc;

    @Test
    void createTrimsNamesAndLowercasesEmail() throws Exception {
        String body = """
                {"firstName":"  Margulan ","lastName":" Beket ",
                 "email":"Margulan.NORMALIZE@IITU.edu.kz","groupName":"it2-2302"}
                """;
        mvc.perform(post("/api/beket-margulan/students").contentType(MediaType.APPLICATION_JSON).content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.firstName").value("Margulan"))
                .andExpect(jsonPath("$.email").value("margulan.normalize@iitu.edu.kz"));
    }
}
EOF
cat >> README.md <<'EOF'

## Change log

- Beket Margulan: the create operation now trims first/last name and stores the email in lower case,
  so "Margulan.Beket@IITU.edu.kz" and "margulan.beket@iitu.edu.kz" count as the same student.
EOF
run "git add ."
run "git commit -qm 'Add normalization test and README change log (Beket Margulan)'"
run "git checkout main"
run "git merge --no-ff feature/beket-margulan-crud -m 'Merge feature/beket-margulan-crud into main'"

# ---------- Task 2.3 ----------
step "Task 2.3 — create a conflict on the same README line"
run "git checkout -b feature/beket-margulan-documentation"
perl -pi -e 's/^Spring Boot CRUD API for students.*$/Spring Boot CRUD API for students — documentation branch: see the Endpoints table below./' README.md
run "git commit -qam 'Docs: describe API in README intro (Beket Margulan)'"
run "git checkout main"
perl -pi -e 's/^Spring Boot CRUD API for students.*$/Spring Boot CRUD API for students — main branch: runs with Docker Compose and Jenkins./' README.md
run "git commit -qam 'Main: mention Docker and Jenkins in README intro (Beket Margulan)'"

echo "\$ git merge feature/beket-margulan-documentation"
git merge feature/beket-margulan-documentation || true
run "git status"

cat <<'EOF'

==================================================================
 CONFLICT! Now resolve it by hand (this is what the teacher wants to see):

 1. Open README.md (e.g.  open -e README.md  or  nano README.md)
 2. Find the block:
      <<<<<<< HEAD
      ...main version...
      =======
      ...documentation version...
      >>>>>>> feature/beket-margulan-documentation
 3. Replace the whole block with ONE line, for example:
      Spring Boot CRUD API for students by Beket Margulan — runs with Docker Compose and Jenkins; see the Endpoints table below.
 4. Save the file and run:
      git add README.md
      git commit -m "Resolve README conflict between main and documentation (Beket Margulan)"
      git log --oneline --graph --all
==================================================================
EOF
