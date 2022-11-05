
# indie-coding

## Collecting open-license images

### `scrape-photoSE.py`

Web scraper to collect the winner photos of the Photography StackExchange contest since 2010.

[Photography StackExchange](https://photo.stackexchange.com/) holds a [regular contest](https://photo.meta.stackexchange.com/questions/7109/new-photo-contest) in which particpants submit their best pictures on a theme. The best photos are listed in the ["Hall of Fame"](https://photo.meta.stackexchange.com/questions/708/image-of-the-week-hall-of-fame).

The photos are licensed under Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA 4.0) with attribution required ([source](https://photo.meta.stackexchange.com/questions/7109/new-photo-contest)).

The script stores each photo together with a text file containing the author, source and details.


### `collect-ubuntu-wallpapers.sh`

Collects every background image (wallpaper) available in any of the past Ubuntu wallpapers packages until now, provided the corresponding license is found.

This script requires an Ubuntu OS. It works by installing every relevant package, extracting the images and then uninstalling the package.

The code relies on information found [here](https://askubuntu.com/questions/11447/where-can-i-find-all-the-wallpapers-ever-included), [here](https://askubuntu.com/questions/519233/what-license-are-the-ubuntu-wallpapers-distributed-under) and [there](https://askubuntu.com/questions/1438419/understanding-the-copyright-file-in-ubuntu-wallpapers).

