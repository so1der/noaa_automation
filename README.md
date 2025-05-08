# README:  [Українська](#noaa_automation-українська) 

# noaa_automation

These scripts automate the reception, processing, and publication of images from NOAA satellites (18, 19) using `predict`, `rtl_fm`, `sox`, `noaa-apt`, `ImageMagick`, and the Mastodon API via Python.

## Project Structure

```
$HOME/
├── get_tle.sh               # Download TLE data for weather satellites
├── noaa_scheduler.sh        # Schedule recording, processing, and image publishing
├── process_image.sh         # Convert audio file to image
├── post_image.sh            # Wrapper for poster.py
├── move_processed_files.sh  # Move processed files
|
├── Recordings/              # Directory for processed audio files
├── Pictures/                # Directory for processed images
|
├── noaa-apt/                # Binary and resources for noaa-apt image decoder
│   └── noaa-apt             # Binary file for noaa-apt image decoder
│   └── res/                 # Resources for noaa-apt image decoder
|
└── python-mastodon/
    └── poster.py           # Python script for posting images to Mastodon
```

## How It Works

### `get_tle.sh`
Fetches TLE data for NOAA satellites.
```bash
bash get_tle.sh
```

### `noaa_scheduler.sh`
Identifies the best pass of NOAA 18 or NOAA 19 and uses `at` to schedule:
- signal recording (`rtl_fm` + `sox`)
- processing (`process_image.sh`)
- publishing (`post_image.sh`)
```bash
bash noaa_scheduler.sh
```

### `process_image.sh`
- Decodes image using `noaa-apt`
- Converts PNG to JPG and deletes the PNG

### `post_image.sh`
- Activates Python `venv`
- Runs `poster.py`

### `move_processed_files.sh`
- Moves processed files:
  - `.wav` to `~/Recordings`
  - `.jpg` to `~/Pictures`

## Dependencies

Required packages:

- [`predict`](https://www.qsl.net/kd2bd/predict.html)
- `rtl_fm` (RTL-SDR)
- `sox`
- [`noaa-apt`](https://github.com/martinber/noaa-apt)
- `imagemagick`
- `at`
- `wget`
- Python 3 + `venv` + [`Mastodon.py`](https://mastodonpy.readthedocs.io/)

## Example Usage

```bash
# Update TLE data
bash get_tle.sh

# Schedule recording, processing, and image publishing
bash noaa_scheduler.sh
```

## Example Cron Setup:
```cron
0 5 * * * bash /home/ctl/noaa_scheduler.sh
0 3 */2 * * bash /home/ctl/get_tle.sh
```

In this case, `get_tle.sh` runs every 2 days at 3 AM.

`noaa_scheduler.sh` runs daily at 5 AM.

## Notes

- Jobs are scheduled via `at`. Ensure the atd service is active: `sudo systemctl enable atd && sudo systemctl start atd`
- Scripts are located in the `$HOME` directory
- Scripts operate in `~/noaa-apt/` and `~/python-mastodon/`


# noaa_automation Українська:

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

- [`predict`](https://www.qsl.net/kd2bd/predict.html)
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

