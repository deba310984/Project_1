# Reusable prompt — one per project

Copy the block below into a **new chat**, change the number on the first line, and send.
Keep this file at `C:\DEVOPS\projects\` so it's easy to find between chats.

Priority order: `03 → 02 → 05 → 11 → 04 → 17 → 08 → 15 → 18 → 06 → 09 → 24 → 21 → 26`

---

```text
PROJECT: <put the project number here, e.g. 02>

Context about me (don't re-ask):
- I'm working through NotHarshhaa/DevOps-Projects as a portfolio path:
  https://github.com/NotHarshhaa/DevOps-Projects
- Target roles: DevOps Engineer, Cloud/AWS Engineer, SRE/Platform Engineer, DevSecOps.
- Level: entry-level, but I want to MASTER each topic, not just finish it.
- My agreed priority order is:
  03 → 02 → 05 → 11 → 04 → 17 → 08 → 15 → 18 → 06 → 09 → 24 → 21 → 26.
- Working dir on Windows: C:\DEVOPS\projects\  (make a folder per project).

What I want you to do for THIS project:
1. Fetch that project's README from the repo (raw.githubusercontent.com/
   NotHarshhaa/DevOps-Projects/master/DevOps-Project-<NN>/README.md) and
   read the actual tasks — don't work from memory.
2. Scaffold a workspace folder for it with:
   - README.md   (overview, what it teaches, cost warning, how to use)
   - 00-setup.md (prereqs: accounts, tools, how to launch/connect infra)
   - TASKS.md    (the full task list as a phase-by-phase checkbox tracker)
   - solutions/  (one reference file per phase — I check AFTER I attempt)
   - NOTES.md    (empty, for me to write what I learned / got stuck on)
3. TEACH me as we go — this is the main point. For each phase:
   - Explain the CONCEPT first (what it is, why it exists, where it's used
     in real jobs) before any command.
   - Explain WHY each command/resource is used, not just what to type.
   - Call out common mistakes, gotchas, and the "interview angle" (what a
     hiring manager might ask about this).
4. Make me attempt each phase myself first, then I'll ask you to check /
   explain. Don't dump all answers up front.
5. Flag anything I can't do on Windows vs. what needs the cloud/Linux box,
   and always remind me to tear down paid resources at the end.
6. At the end: give me a "resume bullet" I can write from this project and a
   short list of what to put in the repo README to make it portfolio-ready.

Start now: confirm the project name/number, fetch its README, show me the
plan, then scaffold the workspace.
```
