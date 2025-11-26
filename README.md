# Atlas UI with AWS Data Processing MCP Server Setup via MCP-Proxy

This setup demonstrates how to integrate
the [AWS Data Processing MCP Server][aws-data-mcp]
with [Atlas UI][atlas]
using [mcp-proxy][mcp-proxy]
for SSE (Server-Sent Events) communication.

Thanks to Karlo Berket for suggestion / idea!

# Quickstart

1. Clone [atlas][Atlas UI GitHub]
2. Copy the Dockerfile.atlas to add version with [mcp-proxy][mcp-proxy]
  ```
  cp Dockerfile.atlas atlas-ui-3/Dockerfile
  ```
3. Modify the `mcp.json` for setting the AWS credentials
  - NOTE: This is suppose to be enabled by `.env` file but I
    could not get the `mcp.json` to take the `${AWS_*}` variables from env vars.
    In future would read: `Create `.env` using `.env.template` to add your AWS creds
4. Build and run containers
  ```
  docker compose down && docker compose build && docker compose up
  ```
5. Navigate to http://localhost:8080 for Altas UI, click on yellow tool icon, and Lakehouse tool should show up

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Atlas UI Container                    │
│  ┌─────────────────────────────────────────────────────┐ │
│  │  Atlas Backend (Port 8000)                          │ │
│  │  - mcp.json configured with "lakehouse" tool       │ │
│  │  - mcp-proxy client (SSE mode)                     │ │
│  │    └─ connects to: mcp-proxy-server:8096/sse       │ │
│  └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
                          ↓ (SSE over HTTP)
┌─────────────────────────────────────────────────────────┐
│              MCP Proxy Server Container                  │
│  ┌─────────────────────────────────────────────────────┐ │
│  │  mcp-proxy Server (Port 8096)                       │ │
│  │  - Exposes SSE endpoint at /sse                     │ │
│  │  - Spawns local stdio server:                       │ │
│  │    └─ awslabs.aws-dataprocessing-mcp-server        │ │
│  │       (Glue, EMR, Athena tools)                     │ │
│  └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## References
 - [mcp-proxy GitHub][mcp-proxy]
 - [AWS Data Processing MCP Server][aws-data-mcp]
 - [Atlas UI GitHub][atlas]
 - [Model Context Protocol][mcp]

[mcp-proxy]: https://github.com/sparfenyuk/mcp-proxy
[aws-data-mcp]: https://awslabs.github.io/mcp/servers/aws-dataprocessing-mcp-server/
[atlas]: https://github.com/sandialabs/atlas-ui-3
[mcp]: https://modelcontextprotocol.io/
