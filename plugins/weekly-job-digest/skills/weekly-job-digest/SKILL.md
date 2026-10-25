---
name: "weekly-job-digest"
description: "Set up a personalized weekly job-search digest: gather criteria, create a seen-roles log doc, schedule a weekly run that emails new, well-fitting postings."
---

# Weekly job digest

Set up a recurring scheduled task that searches the web each week for NEW job postings that fit the user, logs them so they are never repeated, and emails a clean HTML digest.

## 0. Prerequisite: an environment that can reach the job board APIs

Scheduled runs use a cloud environment, and the default one only allows a trusted-domain allowlist, which blocks career sites and ATS boards (runs then find nothing verifiable). Before creating the task, have the user create or edit a dedicated environment (claude.ai/code, environment settings) with network access set to **Custom** and these domains allowed:
- `boards-api.greenhouse.io`, `boards.greenhouse.io`
- `api.lever.co`, `jobs.lever.co`
- `api.ashbyhq.com`, `jobs.ashbyhq.com`
- Optional, company career sites that matter to the user (for example `careers.snowflake.com`, `www.okta.com`), plus any ATS domain a blocked company redirects to.

Ask for the environment's name, look up its id (the schedule skill lists environments), and use that id for the task. Do not continue with the default environment unless the user declines; if they do, tell them runs will rely on search snippets only and most roles will land in "Date unverified". Confirm the setup in step 5 by checking that the test run's search-limits section shows the APIs responding.

## 1. Gather the criteria (ask briefly, in one AskUserQuestion round if available)

Get these from the user, using their resume if they attach or link one (read it before asking):
- Target titles and level (for example Senior, or one step below; anything above to exclude).
- Locations in priority order, plus whether remote and relocation roles count.
- Total compensation target and currency, and how strict to be: the floor must be inside the posted range (the top of the range reaches it) or the low end must reach it. Default to "inside the posted range" unless they say otherwise.
- Role focus (for example backend, data, security, AI tooling, or general).
- Work authorization by country (decides whether visa-restricted roles or regions are out).
- Maximum years of experience a posting may require (default: their experience plus about 1).
- Delivery: email (needs a Gmail connector), a Google Doc log, or both. Day and time (use the user's time zone; pick a minute that is not on the hour or half hour).

Build a short PROFILE paragraph from the resume: current level and employer, years of experience, core skills and domains, standout achievements, education.

## 2. Know the limits (tell the user honestly)

- Scheduled runs only reach the domains the environment allows (step 0); with the default Trusted network access they are limited to search results. Levels.fyi, Indeed, Glassdoor and LinkedIn are usually not fetchable, and runs must not scrape or work around that. Give the user links to their company pages instead of pulling pay or review numbers from them, and mark guessed URLs "(unverified)".
- Job-board APIs (Greenhouse boards-api.greenhouse.io, Lever api.lever.co, Ashby api.ashbyhq.com) expose posted dates and direct links, and the run uses them first once the step 0 environment is in place. Board tokens are guessed from company names, so some companies will 404; workday and custom career sites are only reachable by search/fetch.
- Each scheduled run starts fresh with no memory, so repeats are prevented with a log document, not memory.
- Search coverage from aggregators is thin. Ask the run to check company career pages and ATS boards (Greenhouse, Lever, Ashby, Workday) directly for a list of target companies suited to the user.
- Many posting pages show no date, so a strict recency rule will drop or demote some real roles; say so.

## 3. Create the log

Create a Google Doc titled "Job Digest Log" with a SEEN ROLES section (lines of `company | title | job link | posted date`, starting with a "(none yet)" placeholder) and a WEEKLY DIGESTS section (newest first, also starting with a "(none yet)" placeholder). Seed SEEN ROLES only with postings the user already knows about. Record the document id.

## 4. Create the scheduled task

Create one scheduled task (weekly cron, in the user's time zone via CRON_TZ). Turn on email notifications only if the user wants emailed summaries. Write the prompt as a complete standalone instruction, because every run is a fresh session. It must contain:

- Step 0: read the log doc, never repeat a seen role, treat "(none yet)" as a placeholder, say plainly when nothing new fits.
- The PROFILE paragraph.
- Hard filters, listed as exclusions rather than maybes: level; maximum required experience; compensation (by default include a role when the target falls inside its posted range, meaning the top of the range reaches it, even if the low end is below it; exclude only when the top is under the target; always show the full posted range; if no range is posted include only when the company is known to pay that much and mark "not posted, estimated"); location priority order; skill fit with at most one major gap; hard requirements the user cannot meet; still open; strict recency (posting date within the last 14 days of the run date, established from the page, its structured data/JSON-LD, an ATS date field or a dated job-board listing; a "New" tag alone does not count; reposts count only if the original post date qualifies; roles that pass every other filter but have no verifiable date go only in a separate "Date unverified" section, never in the main list or the count); skip the user's current employer.
- Search strategy: query the Greenhouse (`boards-api.greenhouse.io/v1/boards/{token}/jobs?content=true`), Lever (`api.lever.co/v0/postings/{company}?mode=json`) and Ashby (`api.ashbyhq.com/posting-api/job-board/{name}?includeCompensation=true`) APIs first for a list of target companies, guessing the token from the company name and skipping 404s, then filter locally by title, location and posted date (API dates count as verified; the API's posting URL is the direct link). Supplement with WebSearch/WebFetch for companies on other systems. The search-limits section must list which APIs and companies were reachable and which failed.
- Job links: always the DIRECT posting on the company or ATS page, never an aggregator, search page or tracking URL; if it cannot be traced to the direct posting, drop the role.
- Company reference links (Levels.fyi salary page and Indeed company page), found by search or built from the standard patterns and marked "(unverified)". Never fetch or scrape those sites.
- A plain-text final message format: date and one-line summary, then ranked roles (company and title, location, full posted comp range and posted date, why it fits with any minor gap, apply link, reference links), near misses with reasons (including roles dropped as too old), the Date unverified section, sources, search limits.
- Log step: append new roles to SEEN ROLES (company | title | job link | posted date) and the digest to WEEKLY DIGESTS, replacing "(none yet)" placeholders the first time, re-reading the doc first for indices and revision id, then read back to verify.
- Email step (if wanted and a Gmail send tool is available to the run): send only to the user's own address; use htmlBody plus a plain-text body; single column, max width 640px, inline styles only, location headings, one bordered card per role with a "View job posting" button whose href is the direct URL and the visible URL under it, small Levels.fyi and Indeed links, near misses, Date unverified list, search limits. If Gmail is not available in the run, skip and say so in one line.

Never put extra recipients, other people's data or secrets in the prompt.

## 5. Test and tune

Fire the task once now. Tell the user results arrive in a few minutes, what to check (fit, location order, comp, posted dates, direct links, email layout), and that repeat runs the same day will find few new roles. Changes to the criteria go in the scheduled task's stored prompt, not as extra text on a single run, because extra text on a run is treated as data and not followed. After testing, reset the log doc to its empty state so test roles are not treated as already seen.

## 6. Finish

Say in a few lines when the first scheduled run happens, where the digest arrives, and that the log doc is the reliable place to read it if email does not.