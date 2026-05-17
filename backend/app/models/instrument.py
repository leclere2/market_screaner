from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from ..db.base import Base


class Exchange(Base):
    __tablename__ = "exchanges"

    id = Column(Integer, primary_key=True, index=True)
    code = Column(String(16), unique=True, index=True)
    name = Column(String(255))


class Instrument(Base):
    __tablename__ = "instruments"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), index=True)
    ticker = Column(String(64), index=True)
    isin = Column(String(32), unique=True, index=True)
    exchange_id = Column(Integer, ForeignKey("exchanges.id"))
    exchange = relationship("Exchange")
