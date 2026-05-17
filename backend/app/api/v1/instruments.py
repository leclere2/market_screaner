from fastapi import APIRouter, Depends, HTTPException
from typing import List
from ...db.session import get_db
from ...models.instrument import Instrument
from ...schemas.instrument import InstrumentSchema

router = APIRouter()


@router.get("/search", response_model=List[InstrumentSchema])
def search(q: str):
    # Prototype: return empty list or simple mock
    return []


@router.get("/{instrument_id}", response_model=InstrumentSchema)
def get_instrument(instrument_id: int):
    # Prototype: raise 404 for now
    raise HTTPException(status_code=404, detail={"error": {"code": "INSTRUMENT_NOT_FOUND", "message": "Instrument not found", "details": {}}})
