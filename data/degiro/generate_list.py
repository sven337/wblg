#!/usr/bin/python2

from bs4 import BeautifulSoup
import urllib
import time

# search fund details from ISIN
def etf360_search_ISIN(isin):
    url = 'https://www.etf360.eu/en/?searchword=' + isin + '&searchphrase=any&limit=20&ordering=newest&view=search&option=com_search'
    r = urllib.urlopen(url).read()
    soup = BeautifulSoup(r, "lxml")
    
    list_of_results = soup.select(".result-title a")
    if len(list_of_results) < 1:
        print("Cannot find results for ISIN " + isin)
        return ""
    elif len(list_of_results) > 1:
        print("Too many results for ISIN " + isin)
        return ""
    
    return unicode(list_of_results[0]['href'])

def etf360_get_soup(link):
    url = 'https://www.etf360.eu/' + link
    r = urllib.urlopen(url.encode("UTF-8")).read()
    soup = BeautifulSoup(r, "lxml")
    return soup

# scrape data from fund details link
def etf360_scrape_ISIN(link):
    soup = etf360_get_soup(link)
# title looks like: u'AMUNDI ETF S&P 500 UCITS ETF : Market Quotes for ETF - FR0010892224 - 500 - ETF360'
    title = soup.title.contents[0].split(':')
    fullname = title[0]
    isincheck = title[1].split('-')[1].strip()
    ticker = title[1].split('-')[2].strip()
    
    pea_allowed = soup.select(".pea .value")[0].contents[0]
    
    unk = 'UNKNOWN'
    result = { 'fullname' : fullname,
               'ISIN' : isincheck,
               'ticker' : ticker,
               'PEA' : pea_allowed,
               'aum' : unk,
               'quote' : unk,
               'index' : unk,
               'TER'   : unk,
               'replication' : unk,
               'last_dividend' : unk,
               'dividend_freq' : unk,
    
             }
    
    table = soup.select(".blocContent")[0].find_all("td")
    sz = len(table)
    if (sz != 13):
            print("Table does not have the expected 13 values");
            return { 'fullname' : 'ERROR' }
    i = 0
    for i in range(0,sz):
        lbl = table[i].select(".cellLabel")[0].text.strip()
        val = table[i].select(".cellValue")[0].text.strip()
        if (lbl == "Underlying index"):
            result['index'] = val 
        elif (lbl == "TER"):
            result['TER'] = val
        elif (lbl == "Replication"):
            result['replication'] = val
        elif (lbl == "Last dividend"):
            result['last_dividend'] = val
        elif (lbl == "Dividend frequency"):
            result['dividend_freq'] = val
        elif (lbl == "AUM (range)"):
            result['aum'] = val
        elif (lbl == "Quote"):
            result['quote'] = val
    return result

    
def justetf_get_soup(isin):
    url = 'https://www.justetf.com/en/etf-profile.html?isin=' + isin
    r = urllib.urlopen(url.encode("UTF-8")).read()
    soup = BeautifulSoup(r, "lxml")
    return soup

def justetf_search_ISIN(isin):
    return isin

def justetf_scrape_ISIN(isin):
    soup = justetf_get_soup(isin)
    if (soup.title.contents[0].startswith("ETF Screener |")):
        print("Unknown ISIN " + isin + " at justETF.com")
        return { 'fullname' : 'UNKNOWN' }
    
    title = soup.title.contents[0].split('|')
    fullname = title[0]
    ticker = title[1].strip()
    isincheck = title[2].strip()
    
    unk = 'UNKNOWN'
    result = { 'fullname' : fullname,
               'ISIN' : isincheck,
               'ticker' : ticker,
               'PEA' : '?',
               'aum' : unk,
               'quote' : unk,
               'index' : unk,
               'TER'   : unk,
               'replication' : unk,
               'last_dividend' : unk,
               'dividend_freq' : unk,
    
             }
    
    result['TER'] = soup.find_all("h2",string="Fees")[0].find_next_siblings(class_="infobox")[0].find_all("div", class_="val")[0].text.split(" ")[0]
    result['aum'] = soup.find_all("h2",string="Risk")[0].find_next_siblings(class_="infobox")[0].find_all("div", class_="val")[0].string.strip().replace("\n","").replace("\t","")
    result['dividend_freq'] = soup.find_all("td",string="Distribution policy")[0].find_next_siblings(class_="val")[0].text
    result['replication'] = soup.find_all("h3",string="Replication")[0].parent.find_next_siblings("td")[0].select(".val")[0].text
    return result

f = open("degiro_ETF_gratuits.txt");
out = open("scraped_list.txt", "w")

# etf360 is preferred because it gives us more info (the explicit index name), but it does not have all funds
#search_ISIN = etf360_search_ISIN
#scrape_ISIN = etf360_scrape_ISIN
# justetf is useful for funds that don't exist on etf360
search_ISIN = justetf_search_ISIN
scrape_ISIN = justetf_scrape_ISIN

out.write("ISIN\tFullname\tIndex\tTER\tPEA?\tAUM\tReplication\tDiv. freq.\tLast div\tQuote\tTicker\n")
for line in f.readlines():
    isin = line.split("\t")[0]
    url = search_ISIN(isin)
    if (url == ""):
        print("Skipping ISIN " + isin)
        continue
    result = scrape_ISIN(url)
    if (result['fullname'] == "UNKNOWN"):
        print("Skipping ISIN " + isin)
        continue
    
    data = result['ISIN'] + "\t" + \
        result['fullname'] + "\t" +\
        result['index'] + "\t" +\
        result['TER'] + "\t" +\
        result['PEA'] + "\t" +\
        result['aum'] + "\t" +\
        result['replication'] + "\t" +\
        result['dividend_freq'] + "\t" +\
        result['last_dividend'] + "\t" +\
        result['quote'] + "\t" +\
        result['ticker'] + "\n"
    data = data.encode('utf-8')
    out.write(data)
    out.flush()
    print("Done ISIN " + isin)
    time.sleep(1)
out.close()
f.close()


