import urllib3
from bs4 import BeautifulSoup
import os

output_dir = 'photoSE'
target = 'https://photo.meta.stackexchange.com/questions/708/image-of-the-week-hall-of-fame'

def get_pages_by_year(links):
    pages = {}
    target_years = [ str(y) for y in range(2010, 2030) ]
    for link in links:
        page = link.get('href')
        text = link.get_text()
        if text in target_years:
            pages[text] = add_http(page)
    return pages

def collect_images(url, soup):
    print('*** '+url)
    full_links = soup.find_all('a')
    links = [ link.get('href') for link in full_links ] 
    imgs = soup.find_all('img')
    for link in imgs:
        src = link.get('src')
        if src[len(src)-4:len(src)] == '.jpg' or src[len(src)-4:len(src)] == '.png' :
            index = find_in_list(src, links)
            if index is not None:
                author_link=add_http(links[index-1])
                author = full_links[index-1].get_text()
                alt_txt = link.get('alt')
                save_image(src)
                save_text(url, src, author_link, author, alt_txt)
                #            print(author_link, author, alt_txt)
                #            print()
        else:
            print('   Ignored:', src)

def save_image(src):
        parts = src.split('/')
        filename = parts[-1]
        r2 = http.request('GET', src)
        if r2.status != 200:
            raise Exception("Error, unable to get image: ", src)
        path = os.path.join(output_dir, filename)
        with open(path, 'wb') as handler:
            handler.write(r2.data)

def save_text(url, src, author_link, author, alt_text):
    parts = src.split('/')
    filename = parts[-1]
    parts = filename.split('.')
    filename = parts[-2]+".txt"
    path = os.path.join(output_dir, filename)
    with open(path, 'w') as handler:
        handler.write(f"{author}\n{author_link}\n{alt_text}\n{url}\n")
    

def find_in_list(s, l):
    for i,e in enumerate(l):
        if s == e:
            return i
    return None

def add_http(link):
    if link[0:2] == '//':
        return "http:"+link
    else:
        return link


if not os.path.isdir(output_dir):
    os.mkdir(output_dir)
http = urllib3.PoolManager()
r = http.request('GET', target)
if r.status != 200:
    raise Exception("Error, unable to get html page: ", target)
soup = BeautifulSoup(r.data, 'html.parser')
collect_images(target, soup)
links = soup.find_all('a')
pages_by_year = get_pages_by_year(links)
# print(pages_by_year)
ages_by_year={}
for year, target in pages_by_year.items():
    r = http.request('GET', target)
    if r.status != 200:
        raise Exception("Error, unable to get html page: ", target)
    soup = BeautifulSoup(r.data, 'html.parser')
    collect_images(target, soup)



