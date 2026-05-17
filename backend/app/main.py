from fastapi import FastAPI
from .api.v1.router import api_router
from .core.config import settings

app = FastAPI(title="investment-market-analyzer")

app.include_router(api_router, prefix="/api/v1")


@app.get("/api/v1/health")
def health():
    return {"status": "ok", "app": "investment-market-analyzer", "version": settings.APP_VERSION}
"""FastAPI application entrypoint.

Copilot should implement this file based on docs/SPECIFICATION_TECHNIQUE.md and docs/API_CONTRACT.md.
Expected first endpoint: GET /api/v1/health.
"""
