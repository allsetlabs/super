# Delete Meme Command

Delete a meme from Meme Vault. This removes the clip from:

1. **Supabase** - Database record
2. **GitHub** - Asset files (video, gif, thumbnail, etc.)
3. **Instagram** - Published reel (if exists)

## Arguments

This command requires the **clip ID** (git directory name).

Format: `{videoId}_{timestamp}` (e.g., `dQw4w9WgXcQ_20240115_143022`)

## Execution

### Step 1: Verify the Clip Exists

If the user provided a clip ID, verify it:

```bash
cd modules/forge-modules/meme-vault && npx tsx -e "
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();
const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_ANON_KEY);
supabase.from('clips').select('id,name,insta_reel_link').eq('id', '<CLIP_ID>').single().then(({data, error}) => {
  if (error) console.log('Error:', error.message);
  else console.log('Clip found:', JSON.stringify(data, null, 2));
});
"
```

### Step 2: Delete the Meme

Run the delete-meme script:

```bash
cd modules/forge-modules/meme-vault && npx tsx independent_node_skills/delete-meme.ts \
  --clip-id "<CLIP_ID>" \
  --env-path .env
```

### Optional: Skip Instagram Deletion

If you want to keep the Instagram reel:

```bash
cd modules/forge-modules/meme-vault && npx tsx independent_node_skills/delete-meme.ts \
  --clip-id "<CLIP_ID>" \
  --env-path .env \
  --skip-instagram
```

## Report

After deletion, output:

```
## Meme Deleted

**Clip ID:** <clip_id>
**Name:** <name>

### Deletion Status
- [x] Supabase: Removed
- [x] GitHub: Removed
- [x] Instagram: Removed (or N/A if no reel)

### Notes
- The clip has been completely removed from all systems
- If you need to restore, you'll need to re-create the meme from source
```

## Troubleshooting

### Missing Environment Variables

Ensure `.env` file contains:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `GITHUB_TOKEN`
- `NEXT_PUBLIC_GITHUB_REPO`
- `NEXT_PUBLIC_GITHUB_BRANCH`
- `INSTAGRAM_ACCESS_TOKEN` (optional)

### Clip Not Found

If the clip doesn't exist in the database, the script will still attempt to delete from GitHub (in case only the DB record was removed previously).

### Partial Deletion

If deletion fails for one service, the script continues with remaining services. Check the error messages and manually clean up if needed.
