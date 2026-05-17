from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    APP_NAME: str = "investment-market-analyzer"
    APP_VERSION: str = "0.1.0"
    DATABASE_URL: str = "mysql+pymysql://user:pass@localhost:3306/investment_app"


settings = Settings()
