# humiocli-test

Docker image that runs [humioctl](https://github.com/humio/cli) v0.39.0 search queries against the `ezp_developer` repository.

## Build

```bash
docker build -t humiocli .
```

## Usage

```bash
docker run --rm \
  -e HUMIO_ADDRESS=https://your-humio-instance \
  -e HUMIO_TOKEN=your-api-token \
  humiocli --address https://cloud.humio.com/  search repo 'your search query'
```

### Environment variables

| Variable | Description |
|---|---|
| `HUMIO_TOKEN` | API token for authentication |
| `HUMIO_ADDRESS` | Defaults to http://cloud.humio.com |

### Examples

```bash
docker build -f ./Mcp.Dockerfile -t humiocli-mcp .
docker build -f ./Cli.Dockerfile -t humiocli .

# Status
docker run --rm -e HUMIO_TOKEN=abc123 humiocli status

# Simple search
docker run --rm -e HUMIO_TOKEN=abc123 humiocli search reponame 'loglevel=ERROR'

# Search with time range
docker run --rm -e HUMIO_TOKEN=abc123 humiocli search  repo '#type=syslog | count()'


echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"capabilities":{},"clientInfo":{"nam
  e":"test"},"protocolVersion":"2024-11-05"}}' | docker run -i --rm humiocli-mcp
```

The search query is passed as arguments to `humioctl `, so any valid Humio query syntax works.

## MCP (Model Context Protocol) Integration

The MCP image exposes Humio search as a tool that can be used by AI assistants such as Claude Code.

### 1. Build the MCP image

```bash
docker build -f ./Mcp.Dockerfile -t humiocli-mcp .
```

### 2. Create a `.env` file

Create a `.env` file in the project root with your Humio API token:

```
HUMIO_TOKEN=your-api-token-here
```

> **Note:** Keep this file secret and never commit it to version control. Add `.env` to your `.gitignore`.

### 3. Configure `.mcp.json`

Add the following `.mcp.json` to your project root (or merge into an existing one):

```json
{
  "mcpServers": {
    "humioctl": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "--env-file", ".env",
        "humiocli-mcp"
      ]
    }
  }
}
```

This tells Claude Code to launch the `humiocli-mcp` Docker container as an MCP server, injecting credentials from your `.env` file.

### 4. Example query

Once configured, Claude Code can run searches against the `ezp_developer` repository. For example:

> Search humio in ezp_developer repo using query `type=ERROR #microservice=app-bff #environment=staging | count()` and return count
