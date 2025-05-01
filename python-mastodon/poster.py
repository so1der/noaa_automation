import sys
from mastodon import Mastodon

def main():
    print(sys.argv)
    if len(sys.argv) != 4:
        print("Usage: python poster.py <file> <angle> <date>")
        sys.exit(1)
    file_name = sys.argv[1]
    angle = sys.argv[2]
    date = sys.argv[3]
    satellite = file_name[0:7].upper().replace("_", " ")
    # Replace with your basedir
    basedir = "/home/ctl/noaa-apt/"

    post_text = f"""Супутник: {satellite}
Кут піднесення: {angle}°
Початок запису: {date}"""

    mastodon = Mastodon(
        access_token = '',
        api_base_url = ''
    )
    media = mastodon.media_post(basedir + file_name, description=file_name)
    mastodon.status_post(post_text, media_ids=[media])

if __name__ == "__main__":
    main()

