# humiocli-test

Docker image that runs [humioctl](https://github.com/humio/cli) v0.39.0 search queries against the `ezp_developer` repository.

## Build

```bash
docker build -t humiocli .
```

## Usage

```bash
docker run --rm \
  -e HUMIO_ADDR=https://your-humio-instance \
  -e HUMIO_TOKEN=your-api-token \
  humiocli --address https://cloud.humio.com/  search repo 'your search query'
```

### Environment variables

| Variable | Description |
|---|---|
| `HUMIO_TOKEN` | API token for authentication |

### Examples

```bash
# Status
docker run --rm -e HUMIO_TOKEN=abc123 humiocli --address https://cloud.humio.com/  status

# Simple search
docker run --rm -e HUMIO_TOKEN=abc123 humiocli --address https://cloud.humio.com/  search reponame 'loglevel=ERROR'

# Search with time range
docker run --rm -e HUMIO_TOKEN=abc123 humiocli --address https://cloud.humio.com/  search  repo '#type=syslog | count()'
```

The search query is passed as arguments to `humioctl `, so any valid Humio query syntax works.

