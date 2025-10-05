
!python -m pip install python-dotenv
!python -m  pip install "langchain-experimental==0.0.29"
!python -m pip install -U langchain-google-genai duckduckgo-search
!python -m pip install -U ddgs
!python -m pip install langchain langchain-core langchain-community langchain-experimental
!python -m pip install mlflow
!python -m pip install spacy
!python -m pip install textstat

from langchain.chat_models import init_chat_model
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate
from pydantic import BaseModel ,Field
from langchain_community.tools import DuckDuckGoSearchRun
from langchain_community.callbacks.mlflow_callback import MlflowCallbackHandler
from langchain_core.output_parsers import StrOutputParser
import mlflow
mlflow.set_tracking_uri("file:./mlruns")
mlflow.set_experiment("Company market Sentiment analysis")

# ✅ Correct new way — no extra args
mlflow_callback = MlflowCallbackHandler(
    tracking_uri="file:./mlruns",
    name="Company market Sentiment analysis"
)

callbacks = [mlflow_callback]

class NewsSentiment(BaseModel):
    company_name: str = Field(..., description="Company name")
    stock_code: str = Field(..., description="Ticker symbol of company")
    newsdesc: str = Field(..., description=" news desc of headlines/articles")
    sentiment: str = Field(..., description="sentiment: Positive, Negative, or Neutral")
    people_names: list[str] = Field(default_factory=list, description="List of people mentioned")
    places_names: list[str] = Field(default_factory=list, description="List of places mentioned")
    other_companies_referred: list[str] = Field(default_factory=list, description="Other companies mentioned")
    related_industries: list[str] = Field(default_factory=list, description="Industries related to news")
    market_implications: str = Field(..., description="market implications")
    confidence_score: float = Field(..., description="Confidence score between 0.0 and 1.0")

output_parser = StrOutputParser(pydantic_object=NewsSentiment)

