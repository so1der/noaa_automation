# noaa_automation

За допомогою цих скриптів можна автоматизувати прийом, обробку та публікацію зображень з супутників NOAA (18, 19), використовуючи `predict`, `rtl_fm`, `sox`, `noaa-apt`, `ImageMagick`, та Mastodon API через Python.

## Структура проєкту

```
$HOME/
├── get_tle.sh               # Завантаження TLE для погодних супутників
├── noaa_scheduler.sh        # Планування запису, обробки, та публікації зображення
├── process_image.sh         # Обробка аудіофайлу в зображення 
├── post_image.sh            # Враппер для poster.py
├── move_processed_files.sh  # Переміщення оброблених файлів
|
├── Recordings/              # Директорія для оброблених аудіофайлів
├── Pictures/                # Директорія для оброблених зображень
|
├── noaa-apt/                # Бінарник і ресурси noaa-apt image decoder
│   └── noaa-apt             # Бінарний файл noaa-apt image decoder
│   └── res/                 # Ресурси noaa-apt image decoder
|
└── python-mastodon/
    └── poster.py           # Python-скрипт для публікації зображень у Mastodon
```

## Принцип роботи

### `get_tle.sh`
Отримує TLE-дані для супутників NOAA.
```bash
bash get_tle.sh
```

### `noaa_scheduler.sh`
Визначає кращий прохід NOAA 18 або NOAA 19, та через `at` планує:
- запис сигналу (`rtl_fm` + `sox`)
- обробку (`process_image.sh`)
- публікацію (`post_image.sh`)
```bash
bash noaa_scheduler.sh
```

### `process_image.sh`
- Декодує зображення через `noaa-apt`
- Конвертує PNG у JPG, та видаляє PNG

### `post_image.sh`
- Активує Python `venv`
- Запускає `poster.py`

### `move_processed_files.sh`
- Переміщує оброблені файли:
- `.wav` у `~/Recordings`
- `.jpg` у `~/Pictures`

## Залежності

Потрібні пакети:

- `rtl_fm` (RTL-SDR)
- `sox`
- [`noaa-apt`](https://github.com/martinber/noaa-apt)
- `imagemagick`
- `at`
- `wget`
- Python 3 + `venv` + [`Mastodon.py`](https://mastodonpy.readthedocs.io/)

## Приклад запуску

```bash
# Оновлення TLE
bash get_tle.sh

# Планування запису, обробки, та публікації зображення
bash noaa_scheduler.sh
```

## Приклад cron-у:
```cron
0 5 * * * bash /home/ctl/noaa_scheduler.sh
0 3 */2 * * bash /home/ctl/get_tle.sh
```

В даному випадку `get_tle.sh` запускається кожні 2 дня о третій ночі. 

`noaa_scheduler.sh` запускається кожний день о п'ятій ранку.


## Примітки

- Завдання плануються через `at`. Необхідно активувати сервіс atd: `sudo systemctl enable atd && sudo systemctl start atd`
- Скрипти знаходяться у `$HOME` директорії 
- Скрипти працюють в `~/noaa-apt/` та `~/python-mastodon/`

