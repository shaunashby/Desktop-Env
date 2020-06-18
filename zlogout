# Cleanup script:
if [[ "$(uname)" != "Darwin" ]]; then
    # Clean up any SSH agents running (Linux only):
    kill -9 $SSH_AGENT_PID >/dev/null 2>&1
    exit 0
fi
