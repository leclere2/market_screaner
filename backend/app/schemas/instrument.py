from pydantic import BaseModel


class ExchangeSchema(BaseModel):
    id: int
    code: str
    name: str

    class Config:
        orm_mode = True


class InstrumentSchema(BaseModel):
    id: int
    name: str
    ticker: str
    isin: str | None = None
    exchange: ExchangeSchema | None = None

    class Config:
        orm_mode = True
