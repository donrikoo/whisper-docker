FROM python:3.11-slim

# Установка системных зависимостей (ffmpeg нужен для работы с аудио)
RUN apt-get update && apt-get install -y \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Рабочая директория
WORKDIR /app

# Копирование requirements
COPY requirements.txt .

# Установка Python зависимостей
RUN pip install --no-cache-dir -r requirements.txt

# Интерактивный bash для ML-инженера
ENTRYPOINT ["/bin/bash"]
CMD ["-i"]
