#-------------------------------------------------------------------------------
# Name:        JobTrendScraperGIS.py
# Purpose:     Web scraper that performs a job search on LinkedIn, scrapes job descriptions,
#              keeps a count of keywords, and writes final total to a .txt
#
# Author:      ivism
#
# Created:     19/01/2021
# Copyright:   (c) ivism 2021
# Licence:     OpenSource
#-------------------------------------------------------------------------------

from bs4 import BeautifulSoup
from urllib.request import Request, urlopen
import datetime
import time as this
import re
import webbrowser
import requests

#Variables to keep track of job trend keywords
search_term_count = []
search_term_dict = {'data analysis' : 0, 'analyst' : 0, 'relational database' : 0, 'esri' : 0, 'python' : 0, 'qgis' : 0}
search_term = ['data analysis', 'analyst', 'relational database', 'esri', 'python', 'qgis']
links = []

#Variable to keep track of track when script is ran
today_date = datetime.datetime.today()

#Variables to set up GIS Analyst job search and web scraping on LinkedIn
view_page = []
req = Request('https://www.linkedin.com/jobs/search/?geoId=103644278&keywords=GIS%20Analyst&location=United%20States')
html_page = urlopen(req)

soup = BeautifulSoup(html_page, "lxml")
for link in soup.findAll('a'):
    links.append(link.get('href'))

#The html string in the html_page that contains the link to the job description
string = 'https://www.linkedin.com/jobs/view/'

for result in links:
    if string in result:
        view_page.append(result)

# Iterate through the top 25 job listings.
# ***Update this to only scrape text from <section class="description">
for x in view_page[:25]:
    page_req = Request(str(x))
    new_html_page = urlopen(page_req)
    soup = BeautifulSoup(new_html_page, 'html.parser')
    text = soup.find_all(text=True)

    output = ''
    blacklist = [
        '[document]',
        'noscript',
        'header',
        'html',
        'meta',
        'head',
        'input',
        'script',
    ]

    for t in text:
        if t.parent.name not in blacklist:
            output += '{} '.format(t)

    #Create a count function that populates the empty search_term_count list with keyword values.
    #Keyword values are eventually added to search_term_dict dictionary
    def count(word):
            for i in word:
                search_term_count.append(i)

    # iterate through keys in search_term_dict dictionary and run count() function to tally the
    #number of times each search term appears in the job listing
    for k in search_term_dict.keys():
        search = re.compile(k, re.IGNORECASE)
        count(search.findall(output))

#From search_term_count list, this function adds 1 to value for each time the key appears. This ignores case so that
#it includes lower and upper case matches.
def addToDictionary(dictionary, listToAdd):
    for item in listToAdd:
        dictionary.setdefault(item.casefold(), 0)
        dictionary[item.casefold()] = dictionary[item.casefold()] + 1
    return dictionary

#This function displays the final results of the script
def displayDictionary(dictionary):
    print("Frequency of search term:")
    item_total = 0
    for k, v in dictionary.items():
        print(str(v) + " {0}".format(k))
        item_total += v
    print("Total number of items: " + str(item_total))

#This function opens a .txt file and appends new results of keyword searches
#every time the program #runs
def printToDocument(dictionary):
    dateWidth = 13
    valueWidth = 23
    file = open(r'C:\Users\ivism\OneDrive\Desktop\Python\keyword_counts.txt', "a+")
    file.write("\n" + str(today_date).ljust(dateWidth, " ") + "|")

    for v in search_term_dict.values():
        file.write(str(v).center(valueWidth - len(str(v)), " ") + "|")

    file.flush()
    file.close()

#Run functions addToDictionary, displayDictionary, and printToDocument
search_term_dict = addToDictionary(search_term_dict, search_term_count)
displayDictionary(search_term_dict)
printToDocument(search_term_dict)

