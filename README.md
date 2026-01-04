# 🎙️ Whisper Docker — Быстрый старт

## Что находится в этом Docker образе?
- **OpenAI Whisper** — все версии (tiny, base, small, medium, large, large-v3)
- **FFmpeg** — для работы с аудиофайлами (.mp3, .ogg, .wav, .m4a)
- **Python 3.11** + все нужные библиотеки
- **Модели скачиваются при первом запуске** внутри контейнера и кэшируются в volume
- **Только CPU** — работает без видеокарты

## 🚀 Для установки: Развертывание в одну команду

### Шаг 1: Клонируй репозиторий
```bash
git clone https://github.com/donrikoo/whisper-docker.git
cd whisper-docker
```

### Шаг 2: Сборка Docker образа
```bash
make build
```
⏱️ **Первый раз:** ~15–20 минут (ставятся зависимости)

### Шаг 3: Запуск контейнера
```bash
make up
```

### Шаг 4: Вход в контейнер (интерактивный bash)
```bash
make bash
```

Готово! Теперь ты внутри контейнера (`root@...:/app#`) и можешь запускать команды.

---

## 💻 Для ML-инженера: Работа в контейнере

Когда ты внутри контейнера (после `make bash`):

### ✅ Проверка: Все ли модели доступны?
```bash
python3 -c "import whisper; print(whisper.available_models())"
```
Должно вывести:
```
['tiny', 'base', 'small', 'medium', 'large', 'large-v3']
```

### 📥 Предзагрузка моделей (по желанию)

Эти команды скачивают модели и кэшируют их в `/root/.cache/whisper` (volume `whisper-models`):

```bash
python3 -c "import whisper; whisper.load_model('small')"
python3 -c "import whisper; whisper.load_model('medium')"
python3 -c "import whisper; whisper.load_model('large-v3')"
```

Можно выполнить все сразу или только нужные модели.

### 🎯 Быстрый тест распознавания

Если у тебя есть аудиофайл `audio.ogg` в папке `audio_data/` на хосте (она смонтирована как `/app/audio_data` в контейнере):

```bash
python3 << 'EOF'
import whisper

# Загружаем модель small (если не была скачана, скачает сейчас)
model = whisper.load_model("small")

# Распознаём аудио на русском
result = model.transcribe("audio_data/audio.ogg", language="ru")

# Выводим текст
print(result["text"])
EOF
```

### 📊 Измерение времени обработки (RTF)

```bash
python3 << 'EOF'
import time
import whisper

start = time.time()
model = whisper.load_model("small")
result = model.transcribe("audio_data/audio.ogg", language="ru")
elapsed = time.time() - start

duration = result["segments"][-1]["end"] if result["segments"] else 0
rtf = elapsed / duration if duration > 0 else 0

print(f"⏱️  Время обработки: {elapsed:.2f}с")
print(f"🎵 Длительность аудио: {duration:.2f}с")
print(f"📈 RTF (Real-Time Factor): {rtf:.2f}")
print(f"
📝 Распознанный текст:
{result['text']}")
EOF
```

### 🔄 Переключение между моделями

```bash
python3 << 'EOF'
import whisper

# Выбери одну из шести:
model = whisper.load_model("tiny")       # Очень быстро, низкое качество
model = whisper.load_model("base")       # Быстро, хорошее качество
# model = whisper.load_model("small")    # Рекомендуется, RTF ~0.3–0.5
# model = whisper.load_model("medium")   # Среднее качество, RTF ~0.75–1.5
# model = whisper.load_model("large")    # Хорошее качество, RTF ~2–4
# model = whisper.load_model("large-v3") # Лучшее качество, RTF ~2–4

result = model.transcribe("audio_data/audio.ogg", language="ru")
print(result["text"])
EOF
```

---

## 📂 Структура папок

На **хосте** (твой ноут/сервер):
```
whisper-docker/
├── README.md              ← этот файл
├── docker-compose.yml     ← конфиг Docker
├── Dockerfile             ← инструкции сборки
├── requirements.txt       ← Python библиотеки
├── .gitignore             ← что не загружать в Git
├── .dockerignore          ← что не копировать в контейнер
├── Makefile               ← удобные команды (make build/up/bash/...)
└── audio_data/            ← ТВОЯ РАБОЧАЯ ПАПКА
    ├── audio.ogg          ← аудиофайлы сюда
    ├── audio.mp3
    └── my_script.py       ← твои скрипты сюда
```

В **контейнере**:
- `/app/audio_data` → то же, что `./audio_data` на хосте (видно обе стороны)
- `/root/.cache/whisper` → кэш моделей (volume `whisper-models`)

---

## 🐛 Troubleshooting

### ❓ Контейнер не стартует?
```bash
docker-compose logs whisper
```
Посмотри ошибку в логах.

### ❓ Долго собирается образ?
Нормально! Первый раз ставятся библиотеки и при первом `load_model` скачиваются модели (до ~8 ГБ).

### ❓ Как выйти из контейнера?
```bash
exit
```

### ❓ Как остановить контейнер?
```bash
make down
```

### ❓ Хочу перезагрузить контейнер?
```bash
make restart
```

### ❓ Как посмотреть логи контейнера?
```bash
make logs
```

### ❓ Как удалить всё и начать заново?
```bash
make down
docker volume rm whisper-docker_whisper-models
make build
```

---

## 📞 Контакты

Вопросы? Обращайся к ML-инженеру.
