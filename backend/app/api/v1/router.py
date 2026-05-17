from fastapi import APIRouter
from . import instruments

api_router = APIRouter()
api_router.include_router(instruments.router, prefix="/instruments", tags=["instruments"])
