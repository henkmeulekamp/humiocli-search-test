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
  humiocli 'your search query'
```

### Environment variables

| Variable | Description |
|---|---|
| `HUMIO_ADDR` | URL of your Humio/LogScale instance |
| `HUMIO_TOKEN` | API token for authentication |

### Examples

```bash
# Simple search
docker run --rm -e HUMIO_ADDR=https://cloud.humio.com -e HUMIO_TOKEN=abc123 humiocli 'loglevel=ERROR'

# Search with time range
docker run --rm -e HUMIO_ADDR=https://cloud.humio.com -e HUMIO_TOKEN=abc123 humiocli '#type=syslog | count()'
```

The search query is passed as arguments to `humioctl search --repo=ezp_developer`, so any valid Humio query syntax works.
