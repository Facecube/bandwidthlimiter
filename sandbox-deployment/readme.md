# Sandbox Deployment

A local development environment for testing the `bandwidthlimiter` Traefik plugin. It spins up Traefik with the plugin loaded as a local plugin, alongside a minimal dummy API to test against.

## Stack

| Component     | Description                                                     |
|---------------|-----------------------------------------------------------------|
| **Traefik**   | Reverse proxy with the `bandwidthlimiter` plugin loaded locally |
| **dummy-api** | Minimal HTTP server (bash + socat) that echoes a JSON response  |

## Prerequisites

- Docker with compose plugin
- The plugin source lives at the repository root (`../`) and is mounted into Traefik as a local plugin

## Usage

```bash
# Start the stack
docker compose up --build

# Stop the stack
docker compose down
```

## Endpoints

| URL                           | Description                                    |
|-------------------------------|------------------------------------------------|
| `http://localhost/dummy`      | Dummy API, fully consuming a POST request body |
| `http://localhost/dashboard/` | Traefik dashboard                              |
| `http://localhost/api/...`    | Traefik API                                    |

## Middleware Configuration

The bandwidth limiter middleware configuration is defined in `dynamic.yml`:

Adjust `defaultLimit` and `burstSize` (values in bytes/s) to experiment with different rate limits. See the [root readme](../readme.md) for the full configuration reference and bandwidth value table.

## Testing the upload rate limit

Send a large upload to observe limiting on the request body:

```bash
# Generate a 50 MB payload and POST it
dd if=/dev/urandom bs=1M count=50 2>/dev/null | \          
curl -v -X POST http://localhost/dummy --data-binary @- --progress-bar -H "Expect:" -w "\nTime: %{time_total}s  Speed: %{speed_upload} B/s\n"
```
