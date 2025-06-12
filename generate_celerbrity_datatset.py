#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun  5 15:41:19 2025

@author: user
"""

from bing_image_downloader import downloader

output_folder = "Shelly_Celebrity_Dataset"

celebs = [
    "Taylor Swift", "Dwayne Johnson", "Kim Kardashian", "Justin Bieber", "Ariana Grande",
    "Selena Gomez", "Beyonce", "Rihanna", "Kylie Jenner", "Kanye West",
    "Will Smith", "Chris Evans", "Emma Watson", "Leonardo DiCaprio", "Brad Pitt",
    "Tom Cruise", "Angelina Jolie", "Jennifer Aniston", "Miley Cyrus", "Zendaya",
    "Harry Styles", "Timothée Chalamet", "Tom Holland", "Scarlett Johansson", "Chris Hemsworth",
    "Ryan Reynolds", "Lady Gaga", "Shakira", "Kendall Jenner", "Ed Sheeran",
    "Billie Eilish", "Gigi Hadid", "Doja Cat", "Nicki Minaj", "Post Malone",
    "Drake", "Charlie Puth", "Shawn Mendes", "Kourtney Kardashian", "Travis Barker",
    "Sophie Turner", "Joe Jonas", "Zayn Malik", "Jennifer Lopez", "Ben Affleck",
    "Blake Lively", "Robert Downey Jr", "Jason Momoa", "Gal Gadot", "Anya Taylor-Joy",
    "Florence Pugh", "Pedro Pascal", "Keanu Reeves", "Johnny Depp", "Hailey Bieber",
    "Lizzo", "Machine Gun Kelly", "Megan Fox", "Lana Del Rey", "Olivia Rodrigo",
    "Camila Cabello", "Millie Bobby Brown", "Noah Schnapp", "Finn Wolfhard", "Natalia Dyer",
    "Sadie Sink", "David Harbour", "Winona Ryder", "Natalie Portman", "Jake Gyllenhaal",
    "Andrew Garfield", "Mark Ruffalo", "Matt Damon", "Hugh Jackman", "Christian Bale",
    "Daniel Radcliffe", "Rupert Grint", "Reese Witherspoon", "Anne Hathaway", "Meryl Streep",
    "Saoirse Ronan", "Emma Stone", "Margot Robbie", "Tobey Maguire", "Paul Rudd",
    "Jenna Ortega", "Austin Butler", "Jacob Elordi", "Sydney Sweeney", "Elizabeth Olsen",
    "Chris Pratt", "Jared Leto", "Zooey Deschanel", "James Franco", "Seth Rogen",
    "Jonah Hill", "Nick Jonas", "Priyanka Chopra", "Henry Cavill", "Cillian Murphy"
]

for celeb in celebs:
    try:
        print(f"📥 Downloading: {celeb}")
        downloader.download(
            celeb,
            limit=60,
            output_dir=output_folder,
            adult_filter_off=True,
            force_replace=False,
            timeout=60
        )
    except Exception as e:
        print(f"❌ Failed to download images for {celeb}: {str(e)}")
        continue

print("\n✅ All done. Check the 'Shelly_Celebrity_Dataset' folder for results.")


