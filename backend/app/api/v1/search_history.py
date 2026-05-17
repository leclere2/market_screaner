from fastapi import APIRouter

router = APIRouter()


@router.get("/")
def list_search_history():
    return []


@router.post("/")
def create_search_history():
    return {"ok": True}
