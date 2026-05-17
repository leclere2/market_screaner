from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text
from ..db.base import Base
import datetime


class SearchHistory(Base):
    __tablename__ = "search_history"
    id = Column(Integer, primary_key=True, index=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    query = Column(String(255))
    query_type = Column(String(32))
    instrument_id = Column(Integer, ForeignKey("instruments.id"))
    result_count = Column(Integer)
    summary = Column(Text)
