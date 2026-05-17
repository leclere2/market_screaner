from fastapi import APIRouter

router = APIRouter()


@router.get("/")
def list_watchlists():
    return []


@router.post("/")
def create_watchlist():
    return {"ok": True}
