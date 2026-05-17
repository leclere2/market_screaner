from fastapi import APIRouter, Depends, HTTPException, Query
from typing import List
from sqlalchemy.orm import Session
from ...db.session import get_db
from ...models.instrument import Instrument
from ...schemas.instrument import InstrumentSchema

router = APIRouter()


@router.get("/search", response_model=List[InstrumentSchema])
def search(q: str = Query(..., min_length=1), db: Session = Depends(get_db)):
    # Simple search: match by ticker or name (case-insensitive) or exact ISIN
    stmt = db.query(Instrument)
    q_like = f"%{q}%"
    results = (
        stmt.filter(
            (Instrument.ticker.ilike(q_like)) | (Instrument.name.ilike(q_like)) | (Instrument.isin == q)
        )
        .limit(50)
        .all()
    )
    return results


@router.get("/{instrument_id}", response_model=InstrumentSchema)
def get_instrument(instrument_id: int, db: Session = Depends(get_db)):
    inst = db.get(Instrument, instrument_id)
    if not inst:
        raise HTTPException(status_code=404, detail={"error": {"code": "INSTRUMENT_NOT_FOUND", "message": "Instrument not found", "details": {}}})
    return inst
