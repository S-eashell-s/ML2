#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun  5 20:14:31 2025

@author: user
"""

import os
import time
import requests
from bs4 import BeautifulSoup
from PIL import Image
from io import BytesIO

# 100 widely recognized celebrities
celebrities = [
    "Taylor Swift", "Dwayne Johnson", "Kim Kardashian", "Justin Bieber", "Ariana Grande",
    "Selena Gomez", "Beyonce", "Rihanna", "Kylie Jenner", "Kanye West", "Will Smith",
    "Chris Evans", "Emma Watson", "Leonardo DiCaprio", "Brad Pitt", "Tom Cruise",
    "Angelina Jolie", "Jennifer Aniston", "Miley Cyrus", "Zendaya", "Harry Styles",
    "Timothée Chalamet", "Tom Holland", "Scarlett Johansson", "Chris Hemsworth",
    "Ryan Reynolds", "Lady Gaga", "Shakira", "Kendall Jenner", "Ed Sheeran",
    "Billie Eilish", "Gigi Hadid", "Doja Cat", "Nicki Minaj", "Post Malone", "Drake",
    "Charlie Puth", "Shawn Mendes", "Kourtney Kardashian", "Travis Barker",
    "Sophie Turner", "Joe Jonas", "Zayn Malik", "Jennifer Lopez", "Ben Affleck",
    "Blake Lively", "Robert Downey Jr", "Jason Momoa", "Gal Gadot", "Anya Taylor-Joy",
    "Florence Pugh", "Pedro Pascal", "Keanu Reeves", "Johnny Depp", "Hailey Bieber",
    "Lizzo", "Machine Gun Kelly", "Megan Fox", "Lana Del Rey", "Olivia Rodrigo",
    "Camila Cabello", "Millie Bobby Brown", "Noah Schnapp", "Finn Wolfhard",
    "Natalia Dyer", "Sadie Sink", "David Harbour", "Winona Ryder", "Natalie Portman",
    "Jake Gyllenhaal", "Andrew Garfield", "Mark Ruffalo", "Matt Damon", "Hugh Jackman",
    "Christian Bale", "Daniel Radcliffe", "Rupert Grint", "Reese Witherspoon",
    "Anne Hathaway", "Meryl Streep", "Saoirse Ronan", "Emma Stone", "Margot Robbie",
    "Tobey Maguire", "Paul Rudd", "Jenna Ortega", "Austin Butler", "Jacob Elordi",
    "Sydney Sweeney", "Elizabeth Olsen", "Chris Pratt", "Jared Leto", "Zooey Deschanel",
    "James Franco", "Seth Rogen", "Jonah Hill", "Nick Jonas", "Priyanka Chopra",
    "Henry Cavill", "Cillian Murphy"
]

# Add expressive & angled keywords
modifiers = [
    "face", "side face", "smiling face", "wearing glasses", "looking down",
    "looking up", "angry face", "close up", "profile view", "laughing"
]

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko)"
}

base_dir = "Shelly_Celebrity_Diverse"

if not os.path.exists(base_dir):
    os.makedirs(base_dir)

def get_image_urls(query, max_links=30):
    """Scrapes image URLs from Bing search results."""
    query = query.replace(" ", "+")
    url = f"https://www.bing.com/images/search?q={query}&form=HDRSC2&first=1&tsc=ImageHoverTitle"
    html = requests.get(url, headers=HEADERS).text
    soup = BeautifulSoup(html, "html.parser")
    img_tags = soup.find_all("a", class_="iusc")
    urls = []
    for tag in img_tags:
        m = tag.get("m")
        if m:
            try:
                img_url = eval(m)["murl"]
                urls.append(img_url)
            except:
                continue
        if len(urls) >= max_links:
            break
    return urls

def save_and_resize_images(celeb, urls):
    folder = os.path.join(base_dir, celeb.replace(" ", "_"))
    os.makedirs(folder, exist_ok=True)
    for idx, url in enumerate(urls):
        try:
            response = requests.get(url, timeout=10)
            if response.status_code == 200:
                img = Image.open(BytesIO(response.content)).convert("RGB")
                img = img.resize((224, 224))
                img.save(f"{folder}/{idx+1}.jpg")
                print(f"✅ Saved: {celeb} image {idx+1}")
        except Exception as e:
            print(f"⚠️ Failed: {celeb} image {idx+1} – {e}")

# Main loop
for celeb in celebrities:
    print(f"\n👤 {celeb}")
    all_urls = []
    for mod in modifiers:
        term = f"{celeb} {mod}"
        urls = get_image_urls(term, max_links=10)
        all_urls.extend(urls)
        time.sleep(1)
    save_and_resize_images(celeb, all_urls)
    print(f"📁 Done: {celeb} ({len(all_urls)} images)\n")

print("\n🎉 All 100 celebrities downloaded and resized to 224x224.")
