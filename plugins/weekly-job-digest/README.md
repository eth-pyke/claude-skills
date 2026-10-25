# weekly-job-digest

Sets up a personalized, recurring job search. Claude gathers your criteria (titles, level,
locations, compensation floor, work authorization), optionally reads your resume, creates a
"Job Digest Log" Google Doc that tracks roles already seen, and schedules a weekly task that
searches company career pages and ATS boards for new postings that fit. Each run sends you a
digest with direct application links, so you never see the same role twice.

## Install

```
/plugin marketplace add eth-pyke/claude-skills
/plugin install weekly-job-digest@eth-pyke-skills
```

## Requirements

- Scheduled tasks (routines) enabled for your account.
- Google Docs / Drive connector for the log document.
- Gmail connector if you want the digest emailed to you (optional).
- A cloud environment with Custom network access that allows `boards-api.greenhouse.io`, `api.lever.co` and `api.ashbyhq.com` (plus `boards.greenhouse.io`, `jobs.lever.co`, `jobs.ashbyhq.com`). Without it, runs cannot verify posting dates.

## Usage

Say "set up a weekly job digest" and attach or link your resume. Claude will ask a short
round of questions, create the log and schedule, then fire one test run.
