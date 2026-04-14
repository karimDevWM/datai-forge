FROM python:3.12-slim-bookworm

ENV PYTHONPATH="/app" \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY pyproject.toml .
RUN pip install .

COPY . .

EXPOSE 8050

CMD ["python", "src/app.py"]
