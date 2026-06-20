# 0010 — Asymmetric stop hook implementations across Claude and Kimi

**Date**: 2026-06-20
**Status**: Accepted

## Context

The super repo maintains mirrored stop hooks for Claude (`.claude/hooks/stop-hook.sh`) and Kimi (`.kimi-code/hooks/stop-hook.sh`) as part of the hook sync rule established in AGENTS.md Standards. Both hooks orchestrate session-end agents (memory, decision-records, and summarize-chat) at the end of substantive sessions.

Both hooks previously used an identical loop-prevention mechanism: a per-session marker file (e.g., `/tmp/claude-stop-hook-${session_id}`) that prevented the stop hook from firing more than once per session. This marker existed in both platforms despite their different implementation constraints.

## Decision

Remove the per-session marker file mechanism from the Claude stop hook (`.claude/hooks/stop-hook.sh`), leaving the Kimi stop hook (`.kimi-code/hooks/stop-hook.sh`) unchanged:

- **Claude** (`stop-hook.sh`): Loop prevention relies solely on the `stop_hook_active: True` flag in `.claude/settings.json`, which prevents the hook from firing during its own execution.
- **Kimi** (`stop-hook.sh`): Continues to use the per-session marker file (`/tmp/kimi-stop-hook-${session_id}`) because Kimi hooks use `exit 2` to signal re-execution, which would create an infinite loop without the marker.

The two implementations now diverge by design: Claude's native hook mechanism is sufficient for its use case, while Kimi's requires an additional safeguard due to its different signal handling.

## Rationale

The per-session marker in the Claude hook was redundant. Claude's hook system respects the `stop_hook_active: True` flag, which prevents re-entrance during hook execution. The marker added no additional safety and only consumed temporary filesystem resources.

Kimi, by contrast, signals re-execution with `exit 2`, which would bypass the `stop_hook_active`-equivalent mechanism if one existed. The marker file remains necessary for Kimi to prevent infinite loops during session-end processing.

Keeping the implementations asymmetric reflects the underlying platform differences: Claude and Kimi have different hook architectures and constraints. Forcing them to be identical would compromise the clarity and efficiency of each platform's implementation.

## Consequences

- The hook sync rule in AGENTS.md now applies to **intent**, not literal code: both hooks must orchestrate the same session-end agents, but their internal loop prevention strategies may differ based on platform constraints.
- Future maintainers must understand that Claude's and Kimi's stop hooks may not be identical line-for-line; the divergence is intentional and platform-specific.
- If Claude's hook architecture changes (e.g., if `stop_hook_active` stops being respected), the marker may need to be restored to the Claude hook to match Kimi's behavior.
- Temporary marker files under `/tmp/kimi-stop-hook-${session_id}` will continue to accumulate across Kimi sessions; cleanup of old marker files may be needed if Kimi usage scales up.
