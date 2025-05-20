FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libhdf5-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="/root/.local/bin:$PATH"

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.create false

RUN touch README.md

RUN poetry install --no-root --all-extras

RUN mkdir -p /var/spitec/data
RUN mkdir -p /app/logging
RUN mkdir -p /app/cache

COPY . .

RUN chmod -R 755 /var/spitec/data
RUN chmod -R 755 /app/logging
RUN chmod -R 755 /app/cache

EXPOSE 8050

CMD ["python", "wsgi.py"]