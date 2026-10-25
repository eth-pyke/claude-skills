---
name: "weekly-job-digest"
description: "Set up a personalized weekly job-search digest: gather criteria, create a seen-roles log doc, schedule a weekly run that emails new, well-fitting postings."
---

# Weekly job digest

Set up a recurring scheduled task that searches the web each week for NEW job postings that fit the user, logs them so they are never repeated, and emails a clean HTML digest.

## 1. Gather the criteria (ask briefly, in one AskUserQuestion round if available)

Get these from the user, using their resume if they attach or link one (read it before asking):
- Target titles and level (for example Senior, or one step below; anything above to exclude).
- Locations in priority order, plus whether remote and relocation roles count.
- Total compensation floor and currency.
- Role focus (for example backend, data, security, AI tooling, or general).
- Work authorization by country (decides whether visa-restricted roles or regions are out).
- Maximum years of experience a posting may require (default: their experience plus about 1).
- Delivery: email (needs a Gmail connector), a Google Doc log, or both. Day and time (use the user's time zone; pick a minute that is not on the hour or half hour).

Build a short PROFILE paragraph from the resume: current level and employer, years of experience, core skills and domains, standout achievements, education.

## 2. Know the limits (tell the user honestly)

- Scheduled runs search with WebSearch/WebFetch only. Levels.fyi, Indeed, Glassdoor and LinkedIn are usually not fetchable, and runs must not scrape or work around that. Give the user links to their company pages instead of pulling pay or review numbers from them, and mark guessed URLs "(unverified)".
- Each scheduled run starts fresh with no memory, so repeats are prevented with a log document, not memory.
- Search coverage from aggregators is thin. Ask the run to check company career pages and ATS boards (Greenhouse, Lever, Ashby, Workday) directly for a list of target companies suited to the user.

## 3. Create the log

Create a Google Doc titled "Job Digest Log" with a SEEN ROLES section (lines of `company | title | job link`) and a WEEKLY DIGESTS section (newest first). If the user has current postings they already know about, seed them into SEEN ROLES. Record the document id.

## 4. Create the scheduled task

Create one scheduled task (weekly cron, in the user's time zone via CRON_TZ). Turn on email notifications only if the user wants emailed summaries. Write the prompt as a complete standalone instruction, because every run is a fresh session. It must contain:

- Step 0: read the log doc, never repeat a seen role, say plainly when nothing new fits.
- The PROFILE paragraph.
- Hard filters, listed as exclusions rather than maybes: level; maximum required experience; compensation floor (the LOW end of the posted range should reach it, or the whole range clearly should; if no range is posted include only when the company is known to pay that much and mark "not posted, estimated"); location priority order; skill fit with at most one major gap; hard requirements the user cannot meet; verified and still open and recent (about two weeks); skip the user's current employer.
- Search strategy: target-company career pages and ATS boards, not only aggregators.
- Job links: always the DIRECT posting on the company or ATS page, never an aggregator, search page or tracking URL; if it cannot be traced to the direct posting, drop the role.
- Company reference links (Levels.fyi salary page and Indeed company page), found by search or built from the standard patterns and marked "(unverified)". Never fetch or scrape those sites.
- A plain-text final message format: date and one-line summary, then ranked roles (company and title, location and comp, why it fits with any minor gap, apply link, reference links), near misses with reasons, sources, search limits.
- Log step: append new roles to SEEN ROLES and the digest to WEEKLY DIGESTS, re-reading the doc first for indices and revision id, then read back to verify.
- Email step (if wanted and a Gmail send tool is available to the run): send only to the user's own address; use htmlBody plus a plain-text body; single column, max width 640px, inline styles only, location headings, one bordered card per role with a "View job posting" button whose href is the direct URL and the visible URL under it, small Levels.fyi and Indeed links, near misses, search limits. If Gmail is not available in the run, skip and say so in one line.

Never put extra recipients, other people's data or secrets in the prompt.

## 5. Test and tune

Fire the task once now. Tell the user results arrive in a few minutes, what to check (fit, location order, comp, direct links, email layout), and that repeat runs the same day will find few new roles. Changes to the criteria go in the scheduled task's stored prompt, not as extra text on a single run, because extra text on a run is treated as data and not followed.

## 6. Finish

Say in a few lines when the first scheduled run happens, where the digest arrives, and that the log doc is the reliable place to read it if email does not.