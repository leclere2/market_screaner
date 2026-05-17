from sqlalchemy import Column, Integer, String, ForeignKey, Text
from sqlalchemy.orm import relationship
from ..db.base import Base


class Watchlist(Base):
    __tablename__ = "watchlists"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255))
    description = Column(Text)


class WatchlistItem(Base):
    __tablename__ = "watchlist_items"
    id = Column(Integer, primary_key=True, index=True)
    watchlist_id = Column(Integer, ForeignKey("watchlists.id"))
    instrument_id = Column(Integer, ForeignKey("instruments.id"))
    target_entry_price = Column(DECIMAL(20,6))
    target_exit_price = Column(DECIMAL(20,6))
    priority = Column(Integer)
    user_thesis = Column(Text)
