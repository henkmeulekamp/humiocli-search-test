import re
import subprocess

from fastmcp import FastMCP

mcp = FastMCP("humioctl")

REPO_PATTERN = re.compile(r"^[a-zA-Z0-9_-]+$")
MAX_QUERY_LENGTH = 10000


@mcp.tool
def search(repo: str, query: str) -> str:
    """Run a humioctl search query against a LogScale/Humio repository."""
    if not REPO_PATTERN.match(repo):
        return "Error: invalid repo name. Only alphanumeric characters, hyphens, and underscores are allowed."
    if len(query) > MAX_QUERY_LENGTH:
        return f"Error: query too long (max {MAX_QUERY_LENGTH} characters)."

    result = subprocess.run(
        ["humioctl", "search", f"--repo={repo}", query],
        capture_output=True,
        text=True,
        timeout=120,
    )
    if result.returncode != 0:
        return f"Error (exit {result.returncode}): {result.stderr.strip()}"
    return result.stdout


if __name__ == "__main__":
    mcp.run()
