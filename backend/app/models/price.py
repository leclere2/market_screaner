from sqlalchemy import Column, Integer, ForeignKey, Date, DECIMAL, String
from sqlalchemy.orm import relationship
from ..db.base import Base


class PriceBar(Base):
    __tablename__ = "price_bars"

    id = Column(Integer, primary_key=True, index=True)
    instrument_id = Column(Integer, ForeignKey("instruments.id"), index=True)
    bar_date = Column(Date, index=True)
    timeframe = Column(String(16), default="1d")
    open = Column(DECIMAL(20, 6))
    high = Column(DECIMAL(20, 6))
    low = Column(DECIMAL(20, 6))
    close = Column(DECIMAL(20, 6))
    adjusted_close = Column(DECIMAL(20, 6))
    volume = Column(Integer)
    source = Column(String(128))
