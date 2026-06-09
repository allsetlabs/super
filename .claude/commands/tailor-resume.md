# Resume Tailoring Command

You are helping the user tailor their resume for a specific job application. Follow these steps EXACTLY and get confirmation at each stage.

## Context Files

- Base resume: `./resume-builder/actual/resume.json`
- Generator script: `./resume-builder/generate-resume.mjs`
- Output directory: `./resume-builder/{company_name}`

## Step 1: Get Job Description

Ask the user: "Please paste the complete job description including company name and requirements."

Wait for the user to provide the job description.

## Step 2: Extract Company Name

From the job description, identify the company name.

**CRITICAL:** If you cannot find the company name in the job description, ask the user: "What is the company name for this position?"

**DO NOT PROCEED** without a company name. This is mandatory.

## Step 3: Create Requirements File

1. Create directory: `./resume-builder/{COMPANY_NAME}/`
2. Create `requirements.txt` with the job description formatted clearly
3. Show the user the requirements.txt content and ask: "I've created the requirements file. Does this look correct? (yes/no)"
4. Wait for confirmation before proceeding

## Step 4: Analyze Requirements vs Current Resume

1. Read the base `resume.json` in `./resume-builder/actual/resume.json`
2. Compare each requirement against the current resume:
   - ✅ **SATISFIED**: If requirement is already clearly present in resume (skills, achievements, or experience)
   - ❌ **GAP**: If requirement is missing or not adequately highlighted

## Step 5: Propose Changes for Gaps Only

Only propose changes for **GAP** requirements. Do NOT change what's already satisfied.

**IMPORTANT: Spell Check & Grammar Check**
Before presenting proposals:

- Check all proposed text for spelling errors
- Verify grammar correctness
- Ensure professional tone and clarity
- Fix any errors found before showing to user

Present analysis in this format:

```
REQUIREMENTS ANALYSIS:

SATISFIED (No changes needed):
✅ Requirement 1: [Evidence in current resume]
✅ Requirement 2: [Evidence in current resume]

GAPS (Changes proposed):
❌ Requirement 3: Not addressed

PROPOSED CHANGES:

1. [Change to address Gap 1]:
   - CURRENT: "..."
   - PROPOSED: "..."

2. [Change to address Gap 2]:
   - PROPOSED: "..."

[Only changes for gaps...]
```

Ask: "Do you approve these changes? Reply 'yes' or suggest modifications."

## Step 6: Handle User Feedback

If user suggests modifications:

- Make the requested changes
- Present the revised proposals
- Get confirmation again
- Repeat until user says "yes"

## Step 7: Create Tailored Resume

Once approved:

1. Copy base resume to company directory: `cp ./resume-builder/actual/resume.json ./resume-builder/{COMPANY_NAME}/resume.json`
2. Stage the base version in git: `git add ./resume-builder/{COMPANY_NAME}/resume.json`
3. Apply the approved changes to `./resume-builder/{COMPANY_NAME}/resume.json` (use Edit tool)
4. **Final Spell & Grammar Check**: Review the complete tailored resume JSON for any spelling or grammar errors
5. Generate resume files: `npm run generate-resume -- -i resume-builder/{COMPANY_NAME}/resume.json`
6. Create `./resume-builder/{COMPANY_NAME}/updates.txt` showing:
   - Each change with BEFORE → AFTER format
   - Use arrow marks (→) to show transformations
   - Keep it concise and clear

**Why this workflow?** By copying and staging the base resume first, then making changes, the modifications will appear as a diff in VS Code's source control panel, making it easy to review exactly what was tailored.

## Step 8: Final Summary

Show the user:

```
✅ Resume tailored for {COMPANY_NAME}

Files created:
- {COMPANY_NAME}/requirements.txt
- {COMPANY_NAME}/resume.json
- {COMPANY_NAME}/subbiah_resume.docx
- {COMPANY_NAME}/updates.txt

Changes made: [brief summary]
```

## Important Rules

- **NEVER proceed without company name**
- **ALWAYS get confirmation** before creating files
- **PRESERVE AUTHENTICITY** of original experience
- **SPELL CHECK & GRAMMAR CHECK** all proposed changes and final resume before generation
- **USE TodoWrite tool** to track progress through all steps
- Format all confirmations clearly and wait for user response
